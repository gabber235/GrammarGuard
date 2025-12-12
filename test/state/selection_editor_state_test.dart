import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_state.dart";

void main() {
  group("SelectionEditorState", () {
    late EditorDocument document;

    setUp(() {
      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_DELETE, "old"),
        Diff(DIFF_INSERT, "new"),
        Diff(DIFF_EQUAL, " world"),
      ];
      document = EditorDocument.fromDiffs(diffs);
    });

    group("creation", () {
      test("creates with document and default vim state", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.document, equals(document));
        expect(state.vimState.mode, equals(VimMode.normal));
        expect(state.vimState.cursorPosition, equals(6));
      });

      test("places cursor at first pending change", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.vimState.cursorPosition, equals(6));
      });

      test("places cursor at 0 when no pending changes", () {
        final noChangeDiffs = [Diff(DIFF_EQUAL, "Hello world")];
        final noChangeDoc = EditorDocument.fromDiffs(noChangeDiffs);
        final state = SelectionEditorState.fromDocument(noChangeDoc);

        expect(state.vimState.cursorPosition, equals(0));
      });
    });

    group("accept/reject changes", () {
      test("acceptCurrentChange accepts change at cursor", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.acceptCurrentChange();

        expect(
          newState.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });

      test("rejectCurrentChange rejects change at cursor", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.rejectCurrentChange();

        expect(
          newState.document.pendingChanges.first.status,
          equals(ChangeStatus.rejected),
        );
      });

      test("accept moves cursor to next pending change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);
        final state = SelectionEditorState.fromDocument(doc);

        final newState = state.acceptCurrentChange();

        final nextChangeStart = newState.document.getChangeStartPosition(1);
        expect(newState.vimState.cursorPosition, equals(nextChangeStart));
      });

      test("reject moves cursor to next pending change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);
        final state = SelectionEditorState.fromDocument(doc);

        final newState = state.rejectCurrentChange();

        final nextChangeStart = newState.document.getChangeStartPosition(1);
        expect(newState.vimState.cursorPosition, equals(nextChangeStart));
      });

      test("accept when not on change accepts next change", () {
        final state = SelectionEditorState.fromDocument(document).moveCursor(0);
        final newState = state.acceptCurrentChange();

        expect(
          newState.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });

      test("acceptAll accepts all pending changes", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.acceptAll();

        expect(
          newState.document.pendingChanges.every(
            (c) => c.status == ChangeStatus.accepted,
          ),
          isTrue,
        );
      });

      test("rejectAll rejects all pending changes", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.rejectAll();

        expect(
          newState.document.pendingChanges.every(
            (c) => c.status == ChangeStatus.rejected,
          ),
          isTrue,
        );
      });
    });

    group("undo/redo", () {
      test("undo reverts last change", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();

        expect(
          undone.document.pendingChanges.first.status,
          equals(ChangeStatus.pending),
        );
      });

      test("redo restores undone change", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();
        final redone = undone.redo();

        expect(
          redone.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });

      test("canUndo returns false when no history", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.canUndo, isFalse);
      });

      test("canUndo returns true after action", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();

        expect(accepted.canUndo, isTrue);
      });

      test("canRedo returns false when no redo history", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.canRedo, isFalse);
      });

      test("canRedo returns true after undo", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();

        expect(undone.canRedo, isTrue);
      });

      test("new action clears redo history", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();
        final newAction = undone.rejectCurrentChange();

        expect(newAction.canRedo, isFalse);
      });
    });

    group("cursor movement", () {
      test("moveCursor updates vim state cursor", () {
        final state = SelectionEditorState.fromDocument(document);
        final moved = state.moveCursor(10);

        expect(moved.vimState.cursorPosition, equals(10));
      });

      test("moveCursor clamps to document bounds", () {
        final state = SelectionEditorState.fromDocument(document);
        final moved = state.moveCursor(1000);

        expect(
          moved.vimState.cursorPosition,
          lessThan(1000),
        );
      });
    });

    group("vim mode transitions", () {
      test("enterInsertMode changes vim mode", () {
        final state = SelectionEditorState.fromDocument(document);
        final insertMode = state.enterInsertMode();

        expect(insertMode.vimState.mode, equals(VimMode.insert));
      });

      test("enterNormalMode changes vim mode", () {
        final state =
            SelectionEditorState.fromDocument(document).enterInsertMode();
        final normalMode = state.enterNormalMode();

        expect(normalMode.vimState.mode, equals(VimMode.normal));
      });

      test("enterVisualMode changes vim mode and sets visualStart", () {
        final state = SelectionEditorState.fromDocument(document).moveCursor(5);
        final visualMode = state.enterVisualMode();

        expect(visualMode.vimState.mode, equals(VimMode.visual));
        expect(visualMode.vimState.visualStart, equals(5));
      });
    });

    group("text insertion", () {
      test("insertText inserts at cursor position", () {
        final state = SelectionEditorState.fromDocument(document)
            .moveCursor(0)
            .enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.document.getText().startsWith("X"), isTrue);
      });

      test("insertText moves cursor forward", () {
        final state = SelectionEditorState.fromDocument(document)
            .moveCursor(0)
            .enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.vimState.cursorPosition, equals(1));
      });

      test("insert in original region auto-rejects change", () {
        final state = SelectionEditorState.fromDocument(document);
        final inserted = state.enterInsertMode().insertText("X");

        expect(inserted.document.pendingChanges, isEmpty);
        expect(inserted.document.getText().contains("X"), isTrue);
      });

      test("insert in new region auto-accepts change", () {
        final state = SelectionEditorState.fromDocument(document)
            .moveCursor(9)
            .enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.document.pendingChanges, isEmpty);
        expect(inserted.document.getText().contains("X"), isTrue);
      });
    });

    group("text deletion", () {
      test("deleteCharBefore removes character before cursor", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        final doc = EditorDocument.fromDiffs(diffs);
        final state = SelectionEditorState.fromDocument(doc).moveCursor(5);
        final deleted = state.deleteCharBefore();

        expect(deleted.document.getText(), equals("Hell world"));
        expect(deleted.vimState.cursorPosition, equals(4));
      });

      test("deleteCharAt removes character at cursor", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        final doc = EditorDocument.fromDiffs(diffs);
        final state = SelectionEditorState.fromDocument(doc).moveCursor(5);
        final deleted = state.deleteCharAt();

        expect(deleted.document.getText(), equals("Helloworld"));
        expect(deleted.vimState.cursorPosition, equals(5));
      });
    });

    group("getResultText", () {
      test("returns null when pending changes exist", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.getResultText(), isNull);
      });

      test("returns text after all changes resolved", () {
        final state = SelectionEditorState.fromDocument(document).acceptAll();

        expect(state.getResultText(), equals("Hello new world"));
      });
    });

    group("change counts", () {
      test("getPendingChangeCount returns pending count", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.getPendingChangeCount(), equals(1));
      });

      test("getTotalChangeCount returns total count", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.getTotalChangeCount(), equals(1));
      });
    });

    group("hasUnsavedChanges", () {
      test("returns false on initial state", () {
        final state = SelectionEditorState.fromDocument(document);

        expect(state.hasUnsavedChanges, isFalse);
      });

      test("returns true after accept", () {
        final state =
            SelectionEditorState.fromDocument(document).acceptCurrentChange();

        expect(state.hasUnsavedChanges, isTrue);
      });

      test("returns true after text edit", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        final doc = EditorDocument.fromDiffs(diffs);
        final state = SelectionEditorState.fromDocument(doc)
            .moveCursor(5)
            .enterInsertMode()
            .insertText("X");

        expect(state.hasUnsavedChanges, isTrue);
      });
    });
  });
}
