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

        expect(newState.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });

      test("rejectCurrentChange rejects change at cursor", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.rejectCurrentChange();

        expect(newState.document.pendingChanges.first.status, equals(ChangeStatus.rejected));
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

        expect(newState.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });

      test("acceptAll accepts all pending changes", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.acceptAll();

        expect(newState.document.pendingChanges.every((c) => c.status == ChangeStatus.accepted), isTrue);
      });

      test("rejectAll rejects all pending changes", () {
        final state = SelectionEditorState.fromDocument(document);
        final newState = state.rejectAll();

        expect(newState.document.pendingChanges.every((c) => c.status == ChangeStatus.rejected), isTrue);
      });
    });

    group("undo/redo", () {
      test("undo reverts last change", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();

        expect(undone.document.pendingChanges.first.status, equals(ChangeStatus.pending));
      });

      test("redo restores undone change", () {
        final state = SelectionEditorState.fromDocument(document);
        final accepted = state.acceptCurrentChange();
        final undone = accepted.undo();
        final redone = undone.redo();

        expect(redone.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
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

        expect(moved.vimState.cursorPosition, lessThan(1000));
      });
    });

    group("vim mode transitions", () {
      test("enterInsertMode changes vim mode", () {
        final state = SelectionEditorState.fromDocument(document);
        final insertMode = state.enterInsertMode();

        expect(insertMode.vimState.mode, equals(VimMode.insert));
      });

      test("enterNormalMode changes vim mode", () {
        final state = SelectionEditorState.fromDocument(document).enterInsertMode();
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
        final state = SelectionEditorState.fromDocument(document).moveCursor(0).enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.document.getText().startsWith("X"), isTrue);
      });

      test("insertText moves cursor forward", () {
        final state = SelectionEditorState.fromDocument(document).moveCursor(0).enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.vimState.cursorPosition, equals(1));
      });

      test("insert at the start of a change keeps it pending", () {
        final state = SelectionEditorState.fromDocument(document);
        final inserted = state.enterInsertMode().insertText("X");

        expect(inserted.document.getText(), equals("Hello Xoldnew world"));
        expect(inserted.document.getPendingChangeCount(), equals(1));
      });

      test("insert in original region auto-rejects change", () {
        final state = SelectionEditorState.fromDocument(document).moveCursor(7).enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.document.getText(), equals("Hello oXld world"));
        expect(inserted.document.getPendingChangeCount(), equals(0));
      });

      test("insert in new region auto-accepts change", () {
        final state = SelectionEditorState.fromDocument(document).moveCursor(10).enterInsertMode();
        final inserted = state.insertText("X");

        expect(inserted.document.getText(), equals("Hello nXew world"));
        expect(inserted.document.getPendingChangeCount(), equals(0));
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

    // B3: any keystroke used to flatten the document, baking "original +
    // suggestion" into the text and dropping every pending change.
    group("editing next to pending changes (B3)", () {
      late SelectionEditorState theCat;

      setUp(() {
        theCat = SelectionEditorState.fromDocument(
          EditorDocument.fromDiffs([Diff(DIFF_DELETE, "teh"), Diff(DIFF_INSERT, "the"), Diff(DIFF_EQUAL, " cat")]),
        );
      });

      test("typing after the change keeps it pending", () {
        final typed = theCat.enterInsertMode().replaceRange(10, 10, "!");

        expect(typed.document.getText(), equals("tehthe cat!"));
        expect(typed.document.getPendingChangeCount(), equals(1));
        expect(typed.document.pendingChanges.single.originalText, equals("teh"));
        expect(typed.document.acceptAll().getText(), equals("the cat!"));
        expect(typed.document.rejectAll().getText(), equals("teh cat!"));
      });

      test("typing inside the suggestion accepts it", () {
        final typed = theCat.moveCursor(4).enterInsertMode().insertText("X");

        expect(typed.document.getText(), equals("tXhe cat"));
        expect(typed.document.getPendingChangeCount(), equals(0));
      });

      test("typing inside the original rejects it", () {
        final typed = theCat.moveCursor(1).enterInsertMode().insertText("X");

        expect(typed.document.getText(), equals("tXeh cat"));
        expect(typed.document.getPendingChangeCount(), equals(0));
      });

      test("undo restores the pending change", () {
        final typed = theCat.moveCursor(1).enterInsertMode().insertText("X");
        final undone = typed.undo();

        expect(undone.document, equals(theCat.document));
        expect(undone.document.getPendingChangeCount(), equals(1));
      });

      test("edits keep the Vim mode", () {
        final typed = theCat.enterInsertMode().replaceRange(10, 10, "!");

        expect(typed.vimState.mode, equals(VimMode.insert));
      });

      test("changing a word keeps insert mode and the change", () {
        // What cw on "cat" does: delete to the next word, stay in insert.
        final changed = theCat.enterInsertMode().replaceRange(7, 10, "", cursor: 7).insertText("dog");

        expect(changed.vimState.mode, equals(VimMode.insert));
        expect(changed.document.getText(), equals("tehthe dog"));
        expect(changed.document.getPendingChangeCount(), equals(1));
      });

      test("deleting a line keeps changes on other lines and the history", () {
        final lines = SelectionEditorState.fromDocument(
          EditorDocument.fromDiffs([
            Diff(DIFF_DELETE, "teh"),
            Diff(DIFF_INSERT, "the"),
            Diff(DIFF_EQUAL, " cat\nmiddle line\nthe "),
            Diff(DIFF_DELETE, "dgo"),
            Diff(DIFF_INSERT, "dog"),
          ]),
        );
        final kept = lines.acceptCurrentChange();

        // What dd on the middle line does.
        final deleted = kept.replaceRange(8, 20, "", cursor: 8);

        expect(deleted.document.getText(), equals("the cat\nthe dgodog"));
        expect(
          deleted.document.pendingChanges.map((c) => c.status),
          equals([ChangeStatus.accepted, ChangeStatus.pending]),
        );
        expect(deleted.undoStack, hasLength(2));
        expect(deleted.undo().document, equals(kept.document));
        expect(deleted.undo().undo().document, equals(lines.document));
      });

      test("edits keep the undo history", () {
        final accepted = theCat.acceptCurrentChange();
        final typed = accepted.moveCursor(7).enterInsertMode().insertText("!");

        expect(typed.undoStack, hasLength(2));
        expect(typed.undo().undo().document, equals(theCat.document));
      });
    });
  });
}
