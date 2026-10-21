import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/services.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/word_diff.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/services/vim/vim_handler.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "review.freezed.dart";
part "review.g.dart";

/// What happened to one suggestion. Stored in history; the assistant
/// reads it to spot habits.
@freezed
abstract class Decision with _$Decision {
  const factory Decision({required String before, required String after, required bool kept}) = _Decision;

  factory Decision.fromJson(Map<String, dynamic> json) => _$DecisionFromJson(json);
}

/// What the review produces. On the state, not the notifier, so widgets
/// that watch the review rebuild when a change is kept or undone.
extension ReviewResult on SelectionEditorState {
  /// Text to deliver: decided changes as decided, open ones accepted.
  String get finalText => document.acceptAll().getText();

  /// What happened to each suggestion, for history and the assistant
  /// ("you always undo whilst to while"). Open ones count as kept, because
  /// delivery accepts them. Changes typed over in the Vim editor become plain
  /// text and are left out: they were neither kept nor undone, so they say
  /// nothing about the user's habits.
  List<Decision> get decisions => [
    for (final change in document.pendingChanges)
      Decision(before: change.originalText, after: change.newText, kept: change.status != ChangeStatus.rejected),
  ];
}

/// The word diff of the finished result, computed once per run. Null
/// while there is no finished result.
@Riverpod(keepAlive: true)
List<Diff>? reviewDiff(Ref ref) {
  final input = ref.watch(sessionProvider.select((s) => s.input?.text));
  final run = ref.watch(currentRunProvider)?.value;
  if (input == null || run is! Done) return null;
  return wordDiff(input, run.text);
}

/// The single review of the finished result. The main view (n, p, y, x) and
/// the Vim editor (Tab) edit this same state, so there is one undo history
/// and one text to deliver. Rebuilt from scratch when a new run finishes.
@Riverpod(keepAlive: true)
class Review extends _$Review {
  @override
  SelectionEditorState? build() {
    final diffs = ref.watch(reviewDiffProvider);
    return diffs == null ? null : SelectionEditorState.fromDocument(EditorDocument.fromDiffs(diffs));
  }

  void next() => _move(forward: true);
  void previous() => _move(forward: false);

  void keep() => state = state?.acceptCurrentChange();
  void undo() => state = state?.rejectCurrentChange();
  void undoLast() => state = state?.undo();
  void redoLast() => state = state?.redo();
  void keepAll() => state = state?.acceptAll();
  void undoAll() => state = state?.rejectAll();

  /// The assistant's decide_changes tool, by change index.
  void keepAt(int index) => _at(index, keep: true);
  void undoAt(int index) => _at(index, keep: false);

  void _at(int index, {required bool keep}) {
    final current = state;
    if (current == null || index < 0 || index >= current.document.pendingChanges.length) return;
    state = current.moveCursor(current.document.getChangeStartPosition(index));
    state = keep ? state!.acceptCurrentChange() : state!.rejectCurrentChange();
  }

  /// The Vim editor (Tab) sends every key here. Moved from the old
  /// SelectionEditorNotifier; every edit now goes through replaceRange, so
  /// untouched suggestions and the undo history survive (B3).
  void handleKey(
    LogicalKeyboardKey key, {
    required bool shift,
    required bool ctrl,
    required bool meta,
    String? character,
  }) {
    final current = state;
    if (current == null) return;
    final text = current.document.getText();
    final vimState = current.vimState;
    final result = VimHandler.handleKey(
      key,
      text,
      vimState,
      shift: shift,
      ctrl: ctrl,
      meta: meta,
      character: character,
    );

    var next = current;
    if (result.mode != vimState.mode) {
      next = switch (result.mode) {
        VimMode.normal => next.enterNormalMode(),
        VimMode.insert => next.enterInsertMode(),
        VimMode.visual => next.enterVisualMode(),
      };
    }
    if (result.cursorPosition != vimState.cursorPosition) next = next.moveCursor(result.cursorPosition);
    if (result.textToInsert case final insert?) next = next.insertText(insert);
    if (result.deleteBeforeCursor) next = next.deleteCharBefore();
    if (result.deleteAtCursor) next = next.deleteCharAt();
    if (result.insertNewLineBelow) next = _insertNewLineBelow(next);
    if (result.insertNewLineAbove) next = _insertNewLineAbove(next);
    if (result.deleteToPosition case final target?) next = _deleteToPosition(next, target);
    if (result.deleteLine) next = _deleteLine(next);
    if (result.deleteSelection && vimState.visualStart != null) next = _deleteSelection(next, vimState.visualStart!);
    if (result.changeToPosition case final target?) next = _deleteToPosition(next, target);
    if (result.changeLine) next = _clearLine(next);
    if (result.yankLine) _yankLine(current);
    if (result.yankSelection && vimState.visualStart != null) _yankSelection(current, vimState.visualStart!);
    if (result.pasteAfter) next = _pasteAfter(next);
    if (result.pasteBefore) next = _pasteBefore(next);
    if (result.undo) next = next.undo();
    if (result.redo) next = next.redo();
    // Keep the half typed command (the first d of dd, a count like 3w), or
    // the next key would start over.
    state = next.copyWith(
      vimState: next.vimState.copyWith(pendingOperator: result.pendingOperator, countBuffer: result.countBuffer),
    );
  }

  /// Vim's unnamed register. Lives as long as the review.
  String _register = "";

  SelectionEditorState _insertNewLineBelow(SelectionEditorState s) {
    final end = _lineEnd(s.document.getText(), s.vimState.cursorPosition);
    return s.enterInsertMode().replaceRange(end, end, "\n");
  }

  SelectionEditorState _insertNewLineAbove(SelectionEditorState s) {
    final start = _lineStart(s.document.getText(), s.vimState.cursorPosition);
    return s.enterInsertMode().replaceRange(start, start, "\n", cursor: start);
  }

  SelectionEditorState _deleteToPosition(SelectionEditorState s, int target) {
    final at = s.vimState.cursorPosition;
    final start = at < target ? at : target;
    final end = at < target ? target : at;
    _register = s.document.getText().substring(start, end);
    return s.replaceRange(start, end, "", cursor: start);
  }

  SelectionEditorState _deleteLine(SelectionEditorState s) {
    final text = s.document.getText();
    final at = s.vimState.cursorPosition;
    var start = _lineStart(text, at);
    var end = _lineEnd(text, at);
    if (end < text.length) {
      end++; // take the newline after the line
    } else if (start > 0) {
      start--; // last line: take the newline before it
    }
    _register = text.substring(start, end);
    return s.replaceRange(start, end, "", cursor: start);
  }

  SelectionEditorState _deleteSelection(SelectionEditorState s, int visualStart) {
    final text = s.document.getText();
    final at = s.vimState.cursorPosition;
    final start = visualStart < at ? visualStart : at;
    final end = ((visualStart < at ? at : visualStart) + 1).clamp(0, text.length);
    _register = text.substring(start, end);
    return s.replaceRange(start, end, "", cursor: start);
  }

  SelectionEditorState _clearLine(SelectionEditorState s) {
    final text = s.document.getText();
    final at = s.vimState.cursorPosition;
    final start = _lineStart(text, at);
    final end = _lineEnd(text, at);
    _register = text.substring(start, end);
    return s.replaceRange(start, end, "", cursor: start);
  }

  void _yankLine(SelectionEditorState s) {
    final text = s.document.getText();
    final at = s.vimState.cursorPosition;
    final end = _lineEnd(text, at);
    _register = text.substring(_lineStart(text, at), end) + (end < text.length ? "\n" : "");
  }

  void _yankSelection(SelectionEditorState s, int visualStart) {
    final text = s.document.getText();
    final at = s.vimState.cursorPosition;
    final start = visualStart < at ? visualStart : at;
    final end = ((visualStart < at ? at : visualStart) + 1).clamp(0, text.length);
    _register = text.substring(start, end);
  }

  SelectionEditorState _pasteAfter(SelectionEditorState s) {
    if (_register.isEmpty) return s;
    final at = (s.vimState.cursorPosition + 1).clamp(0, s.document.getText().length);
    return s.replaceRange(at, at, _register, cursor: at);
  }

  SelectionEditorState _pasteBefore(SelectionEditorState s) {
    if (_register.isEmpty) return s;
    final at = s.vimState.cursorPosition;
    return s.replaceRange(at, at, _register, cursor: at);
  }

  int _lineStart(String text, int position) {
    var at = position.clamp(0, text.length);
    while (at > 0 && text[at - 1] != "\n") {
      at--;
    }
    return at;
  }

  int _lineEnd(String text, int position) {
    var at = position.clamp(0, text.length);
    while (at < text.length && text[at] != "\n") {
      at++;
    }
    return at;
  }

  void _move({required bool forward}) {
    final current = state;
    if (current == null) return;
    final document = current.document;
    final cursor = current.vimState.cursorPosition;
    final index = forward
        ? document.getNextPendingChangeIndex(cursor + 1)
        : document.getPreviousPendingChangeIndex(cursor);
    if (index == null) return;
    state = current.moveCursor(document.getChangeStartPosition(index));
  }
}
