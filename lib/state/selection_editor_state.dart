import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/services/vim/vim_state.dart";

part "selection_editor_state.freezed.dart";

/// The review document, the Vim cursor and the undo history. Every change
/// returns a new state; the old one goes on the undo stack.
@freezed
abstract class SelectionEditorState with _$SelectionEditorState {
  const SelectionEditorState._();

  const factory SelectionEditorState({
    required EditorDocument document,
    required VimState vimState,
    @Default(<SelectionEditorState>[]) List<SelectionEditorState> undoStack,
    @Default(<SelectionEditorState>[]) List<SelectionEditorState> redoStack,
  }) = _SelectionEditorState;

  /// Starts on the first pending change.
  factory SelectionEditorState.fromDocument(EditorDocument document) {
    final first = document.getNextPendingChangeIndex(0);
    return SelectionEditorState(
      document: document,
      vimState: VimState(cursorPosition: first == null ? 0 : document.getChangeStartPosition(first)),
    );
  }

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  /// A new document, recorded for undo.
  SelectionEditorState _edit(EditorDocument next, {VimState? vimState}) =>
      SelectionEditorState(document: next, vimState: vimState ?? this.vimState, undoStack: [...undoStack, this]);

  int? get _target =>
      document.getChangeAtPosition(vimState.cursorPosition) ??
      document.getNextPendingChangeIndex(vimState.cursorPosition);

  SelectionEditorState acceptCurrentChange() => _decide(accept: true);
  SelectionEditorState rejectCurrentChange() => _decide(accept: false);

  /// Decides the change under (or after) the cursor and moves to the next.
  SelectionEditorState _decide({required bool accept}) {
    final index = _target;
    if (index == null) return this;
    final next = accept ? document.acceptChange(index) : document.rejectChange(index);
    final following = next.getNextPendingChangeIndex(vimState.cursorPosition);
    return _edit(
      next,
      vimState: vimState.moveCursor(
        following == null ? vimState.cursorPosition : next.getChangeStartPosition(following),
      ),
    );
  }

  SelectionEditorState acceptAll() => _edit(document.acceptAll());
  SelectionEditorState rejectAll() => _edit(document.rejectAll());

  SelectionEditorState undo() {
    if (!canUndo) return this;
    final previous = undoStack.last;
    return previous.copyWith(undoStack: undoStack.sublist(0, undoStack.length - 1), redoStack: [...redoStack, this]);
  }

  SelectionEditorState redo() {
    if (!canRedo) return this;
    final next = redoStack.last;
    return next.copyWith(undoStack: [...undoStack, this], redoStack: redoStack.sublist(0, redoStack.length - 1));
  }

  /// In insert mode the cursor may sit after the last character (A, a).
  SelectionEditorState moveCursor(int position) {
    final length = document.getText().length;
    final max = vimState.isInsertMode ? length : length - 1;
    return copyWith(vimState: vimState.moveCursor(position.clamp(0, max < 0 ? 0 : max)));
  }

  SelectionEditorState enterInsertMode() => copyWith(vimState: vimState.enterInsertMode());
  SelectionEditorState enterNormalMode() => copyWith(vimState: vimState.enterNormalMode());
  SelectionEditorState enterVisualMode() => copyWith(vimState: vimState.enterVisualMode());

  /// The one editing operation. Keeps untouched suggestions, the undo
  /// history and the Vim mode (so `cw` stays in insert mode).
  SelectionEditorState replaceRange(int start, int end, String text, {int? cursor}) {
    final next = document.replaceRange(start, end, text);
    final length = next.getText().length;
    return _edit(next, vimState: vimState.moveCursor((cursor ?? start + text.length).clamp(0, length)));
  }

  SelectionEditorState insertText(String text) {
    final at = vimState.cursorPosition;
    return replaceRange(at, at, text);
  }

  SelectionEditorState deleteCharBefore() {
    final at = vimState.cursorPosition;
    return at <= 0 ? this : replaceRange(at - 1, at, "");
  }

  SelectionEditorState deleteCharAt() {
    final at = vimState.cursorPosition;
    if (at >= document.getText().length) return this;
    return replaceRange(at, at + 1, "", cursor: at);
  }

  int getPendingChangeCount() => document.getPendingChangeCount();
  int getTotalChangeCount() => document.getTotalChangeCount();
}
