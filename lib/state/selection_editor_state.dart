import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/services/vim/vim_state.dart";

class SelectionEditorState {
  final EditorDocument document;
  final VimState vimState;
  final List<SelectionEditorState> _undoStack;
  final List<SelectionEditorState> _redoStack;
  final bool hasUnsavedChanges;

  SelectionEditorState._({
    required this.document,
    required this.vimState,
    List<SelectionEditorState>? undoStack,
    List<SelectionEditorState>? redoStack,
    this.hasUnsavedChanges = false,
  })  : _undoStack = undoStack ?? [],
        _redoStack = redoStack ?? [];

  factory SelectionEditorState.fromDocument(EditorDocument document) {
    final firstChangeIndex = document.getNextPendingChangeIndex(0);
    final cursorPosition = firstChangeIndex != null
        ? document.getChangeStartPosition(firstChangeIndex)
        : 0;

    return SelectionEditorState._(
      document: document,
      vimState: VimState(cursorPosition: cursorPosition),
    );
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  SelectionEditorState acceptCurrentChange() {
    final changeIndex = document.getChangeAtPosition(vimState.cursorPosition) ??
        document.getNextPendingChangeIndex(vimState.cursorPosition);

    if (changeIndex == null) return this;

    final newDoc = document.acceptChange(changeIndex);
    final nextChangeIndex =
        newDoc.getNextPendingChangeIndex(vimState.cursorPosition);

    final newCursor = nextChangeIndex != null
        ? newDoc.getChangeStartPosition(nextChangeIndex)
        : vimState.cursorPosition;

    return SelectionEditorState._(
      document: newDoc,
      vimState: vimState.moveCursor(newCursor),
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState rejectCurrentChange() {
    final changeIndex = document.getChangeAtPosition(vimState.cursorPosition) ??
        document.getNextPendingChangeIndex(vimState.cursorPosition);

    if (changeIndex == null) return this;

    final newDoc = document.rejectChange(changeIndex);
    final nextChangeIndex =
        newDoc.getNextPendingChangeIndex(vimState.cursorPosition);

    final newCursor = nextChangeIndex != null
        ? newDoc.getChangeStartPosition(nextChangeIndex)
        : vimState.cursorPosition;

    return SelectionEditorState._(
      document: newDoc,
      vimState: vimState.moveCursor(newCursor),
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState acceptAll() {
    return SelectionEditorState._(
      document: document.acceptAll(),
      vimState: vimState,
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState rejectAll() {
    return SelectionEditorState._(
      document: document.rejectAll(),
      vimState: vimState,
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState undo() {
    if (!canUndo) return this;

    final previous = _undoStack.last;
    return SelectionEditorState._(
      document: previous.document,
      vimState: previous.vimState,
      undoStack: _undoStack.sublist(0, _undoStack.length - 1),
      redoStack: [..._redoStack, this],
      hasUnsavedChanges: previous.hasUnsavedChanges,
    );
  }

  SelectionEditorState redo() {
    if (!canRedo) return this;

    final next = _redoStack.last;
    return SelectionEditorState._(
      document: next.document,
      vimState: next.vimState,
      undoStack: [..._undoStack, this],
      redoStack: _redoStack.sublist(0, _redoStack.length - 1),
      hasUnsavedChanges: next.hasUnsavedChanges,
    );
  }

  SelectionEditorState moveCursor(int position) {
    final maxPosition = document.getText().length - 1;
    final clampedPosition =
        position.clamp(0, maxPosition < 0 ? 0 : maxPosition);

    return SelectionEditorState._(
      document: document,
      vimState: vimState.moveCursor(clampedPosition),
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState enterInsertMode() {
    return SelectionEditorState._(
      document: document,
      vimState: vimState.enterInsertMode(),
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState enterNormalMode() {
    return SelectionEditorState._(
      document: document,
      vimState: vimState.enterNormalMode(),
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState enterVisualMode() {
    return SelectionEditorState._(
      document: document,
      vimState: vimState.enterVisualMode(),
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState insertText(String text) {
    final position = vimState.cursorPosition;

    var state = this;
    final changeIndex = document.getChangeAtPosition(position);
    if (changeIndex != null) {
      final change = document.pendingChanges[changeIndex];
      if (change.isPending) {
        if (document.isInOriginalRegion(position)) {
          state = state._autoRejectChange(changeIndex);
        } else if (document.isInNewRegion(position)) {
          state = state._autoAcceptChange(changeIndex);
        }
      }
    }

    final docText = state.document.getText();
    final actualPosition = position.clamp(0, docText.length);
    final newText = docText.substring(0, actualPosition) +
        text +
        docText.substring(actualPosition);

    final newDoc = _rebuildDocumentFromText(state.document, newText);

    return SelectionEditorState._(
      document: newDoc,
      vimState: state.vimState.moveCursor(actualPosition + text.length),
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState _autoRejectChange(int changeIndex) {
    return SelectionEditorState._(
      document: document.rejectChange(changeIndex),
      vimState: vimState,
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState _autoAcceptChange(int changeIndex) {
    return SelectionEditorState._(
      document: document.acceptChange(changeIndex),
      vimState: vimState,
      undoStack: _undoStack,
      redoStack: _redoStack,
      hasUnsavedChanges: hasUnsavedChanges,
    );
  }

  SelectionEditorState deleteCharBefore() {
    final position = vimState.cursorPosition;
    if (position <= 0) return this;

    final currentText = document.getText();
    final newText = currentText.substring(0, position - 1) +
        currentText.substring(position);

    final newDoc = _rebuildDocumentFromText(document, newText);

    return SelectionEditorState._(
      document: newDoc,
      vimState: vimState.moveCursor(position - 1),
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  SelectionEditorState deleteCharAt() {
    final position = vimState.cursorPosition;
    final currentText = document.getText();
    if (position >= currentText.length) return this;

    final newText = currentText.substring(0, position) +
        currentText.substring(position + 1);

    final newDoc = _rebuildDocumentFromText(document, newText);

    return SelectionEditorState._(
      document: newDoc,
      vimState: vimState,
      undoStack: [..._undoStack, this],
      redoStack: [],
      hasUnsavedChanges: true,
    );
  }

  EditorDocument _rebuildDocumentFromText(
      EditorDocument original, String newText) {
    final segments = <DocumentSegment>[];
    segments.add(DocumentSegment.text(newText));
    return EditorDocument(segments: segments, pendingChanges: []);
  }

  String? getResultText() {
    return document.getResultText();
  }

  int getPendingChangeCount() {
    return document.getPendingChangeCount();
  }

  int getTotalChangeCount() {
    return document.getTotalChangeCount();
  }
}
