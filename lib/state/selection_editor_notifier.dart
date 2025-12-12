import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/services.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/services/vim/vim_handler.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "selection_editor_notifier.g.dart";

@riverpod
class SelectionEditorNotifier extends _$SelectionEditorNotifier {
  String _clipboard = "";

  @override
  SelectionEditorState? build() {
    return null;
  }

  void initialize(List<Diff> diffs) {
    final document = EditorDocument.fromDiffs(diffs);
    state = SelectionEditorState.fromDocument(document);
  }

  void clear() {
    state = null;
  }

  void handleKey(
    LogicalKeyboardKey key, {
    required bool shift,
    required bool ctrl,
    required bool meta,
  }) {
    if (state == null) return;

    final currentState = state!;
    final text = currentState.document.getText();
    final vimState = currentState.vimState;

    final result = VimHandler.handleKey(
      key,
      text,
      vimState,
      shift: shift,
      ctrl: ctrl,
      meta: meta,
    );

    var newState = currentState;

    if (result.mode != vimState.mode) {
      switch (result.mode) {
        case VimMode.normal:
          newState = newState.enterNormalMode();
        case VimMode.insert:
          newState = newState.enterInsertMode();
        case VimMode.visual:
          newState = newState.enterVisualMode();
      }
    }

    if (result.cursorPosition != vimState.cursorPosition) {
      newState = newState.moveCursor(result.cursorPosition);
    }

    if (result.textToInsert != null) {
      newState = newState.insertText(result.textToInsert!);
    }

    if (result.deleteBeforeCursor) {
      newState = newState.deleteCharBefore();
    }

    if (result.deleteAtCursor) {
      newState = newState.deleteCharAt();
    }

    if (result.insertNewLineBelow) {
      newState = _insertNewLineBelow(newState);
    }

    if (result.insertNewLineAbove) {
      newState = _insertNewLineAbove(newState);
    }

    if (result.deleteToPosition != null) {
      newState = _deleteToPosition(newState, result.deleteToPosition!);
    }

    if (result.deleteLine) {
      newState = _deleteLine(newState);
    }

    if (result.deleteSelection && vimState.visualStart != null) {
      newState = _deleteSelection(newState, vimState.visualStart!);
    }

    if (result.changeToPosition != null) {
      newState = _deleteToPosition(newState, result.changeToPosition!);
    }

    if (result.changeLine) {
      newState = _clearLine(newState);
    }

    if (result.yankLine) {
      _yankLine(currentState);
    }

    if (result.yankSelection && vimState.visualStart != null) {
      _yankSelection(currentState, vimState.visualStart!);
    }

    if (result.pasteAfter) {
      newState = _pasteAfter(newState);
    }

    if (result.pasteBefore) {
      newState = _pasteBefore(newState);
    }

    if (result.undo) {
      newState = newState.undo();
    }

    if (result.redo) {
      newState = newState.redo();
    }

    state = newState;
  }

  SelectionEditorState _insertNewLineBelow(SelectionEditorState state) {
    final text = state.document.getText();
    final lineEnd = _getLineEnd(text, state.vimState.cursorPosition);
    var newState = state.moveCursor(lineEnd);
    newState = newState.enterInsertMode();
    return newState.insertText("\n");
  }

  SelectionEditorState _insertNewLineAbove(SelectionEditorState state) {
    final text = state.document.getText();
    final lineStart = _getLineStart(text, state.vimState.cursorPosition);
    var newState = state.moveCursor(lineStart);
    newState = newState.enterInsertMode();
    newState = newState.insertText("\n");
    return newState.moveCursor(lineStart);
  }

  SelectionEditorState _deleteToPosition(
    SelectionEditorState state,
    int targetPos,
  ) {
    final currentPos = state.vimState.cursorPosition;
    final start = currentPos < targetPos ? currentPos : targetPos;
    final end = currentPos < targetPos ? targetPos : currentPos;

    final text = state.document.getText();
    final newText = text.substring(0, start) + text.substring(end);
    _clipboard = text.substring(start, end);

    return _rebuildState(state, newText, start);
  }

  SelectionEditorState _deleteLine(SelectionEditorState state) {
    final text = state.document.getText();
    final pos = state.vimState.cursorPosition;
    final lineStart = _getLineStart(text, pos);
    var lineEnd = _getLineEnd(text, pos);

    if (lineEnd < text.length && text[lineEnd] == "\n") {
      lineEnd++;
    } else if (lineStart > 0) {
      final adjustedStart = lineStart - 1;
      _clipboard = text.substring(adjustedStart, lineEnd);
      final newText =
          text.substring(0, adjustedStart) + text.substring(lineEnd);
      return _rebuildState(
        state,
        newText,
        adjustedStart.clamp(0, newText.length - 1),
      );
    }

    _clipboard = text.substring(lineStart, lineEnd);
    final newText = text.substring(0, lineStart) + text.substring(lineEnd);
    return _rebuildState(
      state,
      newText,
      lineStart.clamp(0, newText.isEmpty ? 0 : newText.length - 1),
    );
  }

  SelectionEditorState _deleteSelection(
    SelectionEditorState state,
    int visualStart,
  ) {
    final pos = state.vimState.cursorPosition;
    final start = visualStart < pos ? visualStart : pos;
    final end = (visualStart < pos ? pos : visualStart) + 1;

    final text = state.document.getText();
    final clampedEnd = end.clamp(0, text.length);
    _clipboard = text.substring(start, clampedEnd);

    final newText = text.substring(0, start) + text.substring(clampedEnd);
    return _rebuildState(state, newText, start);
  }

  SelectionEditorState _clearLine(SelectionEditorState state) {
    final text = state.document.getText();
    final pos = state.vimState.cursorPosition;
    final lineStart = _getLineStart(text, pos);
    final lineEnd = _getLineEnd(text, pos);

    _clipboard = text.substring(lineStart, lineEnd);
    final newText = text.substring(0, lineStart) + text.substring(lineEnd);
    return _rebuildState(state, newText, lineStart);
  }

  void _yankLine(SelectionEditorState state) {
    final text = state.document.getText();
    final pos = state.vimState.cursorPosition;
    final lineStart = _getLineStart(text, pos);
    final lineEnd = _getLineEnd(text, pos);
    _clipboard = text.substring(lineStart, lineEnd);
    if (lineEnd < text.length && text[lineEnd] == "\n") {
      _clipboard += "\n";
    }
  }

  void _yankSelection(SelectionEditorState state, int visualStart) {
    final pos = state.vimState.cursorPosition;
    final start = visualStart < pos ? visualStart : pos;
    final end = (visualStart < pos ? pos : visualStart) + 1;

    final text = state.document.getText();
    _clipboard = text.substring(start, end.clamp(0, text.length));
  }

  SelectionEditorState _pasteAfter(SelectionEditorState state) {
    if (_clipboard.isEmpty) return state;

    final text = state.document.getText();
    final pos = state.vimState.cursorPosition;
    final insertPos = (pos + 1).clamp(0, text.length);

    final newText =
        text.substring(0, insertPos) + _clipboard + text.substring(insertPos);
    return _rebuildState(state, newText, insertPos);
  }

  SelectionEditorState _pasteBefore(SelectionEditorState state) {
    if (_clipboard.isEmpty) return state;

    final text = state.document.getText();
    final pos = state.vimState.cursorPosition;

    final newText = text.substring(0, pos) + _clipboard + text.substring(pos);
    return _rebuildState(state, newText, pos);
  }

  SelectionEditorState _rebuildState(
    SelectionEditorState oldState,
    String newText,
    int cursorPos,
  ) {
    final segments = <DocumentSegment>[DocumentSegment.text(newText)];
    final newDoc = EditorDocument(segments: segments, pendingChanges: []);

    return SelectionEditorState.fromDocument(newDoc).moveCursor(
      cursorPos.clamp(0, newText.isEmpty ? 0 : newText.length - 1),
    );
  }

  int _getLineStart(String text, int position) {
    var pos = position;
    while (pos > 0 && text[pos - 1] != "\n") {
      pos--;
    }
    return pos;
  }

  int _getLineEnd(String text, int position) {
    var pos = position;
    while (pos < text.length && text[pos] != "\n") {
      pos++;
    }
    return pos;
  }

  void acceptCurrentChange() {
    if (state == null) return;
    state = state!.acceptCurrentChange();
  }

  void rejectCurrentChange() {
    if (state == null) return;
    state = state!.rejectCurrentChange();
  }

  void acceptAll() {
    if (state == null) return;
    state = state!.acceptAll();
  }

  void rejectAll() {
    if (state == null) return;
    state = state!.rejectAll();
  }

  void undo() {
    if (state == null) return;
    state = state!.undo();
  }

  void redo() {
    if (state == null) return;
    state = state!.redo();
  }

  String? getResultText() {
    return state?.getResultText();
  }

  String getCurrentText() {
    return state?.document.getText() ?? "";
  }

  bool get hasUnsavedChanges => state?.hasUnsavedChanges ?? false;
  bool get canUndo => state?.canUndo ?? false;
  bool get canRedo => state?.canRedo ?? false;
  int get pendingChangeCount => state?.getPendingChangeCount() ?? 0;
  int get totalChangeCount => state?.getTotalChangeCount() ?? 0;
}
