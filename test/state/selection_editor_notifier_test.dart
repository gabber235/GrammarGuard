import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("SelectionEditorNotifier", () {
    late ProviderContainer container;
    late SelectionEditorNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(selectionEditorProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    group("initialization", () {
      test("build returns null initially", () {
        final state = container.read(selectionEditorProvider);

        expect(state, isNull);
      });

      test("initialize creates state from diffs", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];

        notifier.initialize(diffs);

        final state = container.read(selectionEditorProvider);
        expect(state, isNotNull);
        expect(state!.document.getText(), equals("Hello oldnew world"));
      });

      test("clear sets state to null", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.clear();

        final state = container.read(selectionEditorProvider);
        expect(state, isNull);
      });
    });

    group("accept/reject operations", () {
      test("acceptCurrentChange accepts change at cursor", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);

        notifier.acceptCurrentChange();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });

      test("rejectCurrentChange rejects change at cursor", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);

        notifier.rejectCurrentChange();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.rejected),
        );
      });

      test("acceptAll accepts all pending changes", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        notifier.initialize(diffs);

        notifier.acceptAll();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.every(
            (c) => c.status == ChangeStatus.accepted,
          ),
          isTrue,
        );
      });

      test("rejectAll rejects all pending changes", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        notifier.initialize(diffs);

        notifier.rejectAll();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.every(
            (c) => c.status == ChangeStatus.rejected,
          ),
          isTrue,
        );
      });

      test("operations on null state are no-ops", () {
        notifier.acceptCurrentChange();
        notifier.rejectCurrentChange();
        notifier.acceptAll();
        notifier.rejectAll();

        final state = container.read(selectionEditorProvider);
        expect(state, isNull);
      });
    });

    group("undo/redo", () {
      test("undo reverts last change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();

        notifier.undo();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.pending),
        );
      });

      test("redo restores undone change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();
        notifier.undo();

        notifier.redo();

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });

      test("canUndo returns false initially", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        expect(notifier.canUndo, isFalse);
      });

      test("canRedo returns false initially", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        expect(notifier.canRedo, isFalse);
      });

      test("undo on null state is no-op", () {
        notifier.undo();

        expect(container.read(selectionEditorProvider), isNull);
      });

      test("redo on null state is no-op", () {
        notifier.redo();

        expect(container.read(selectionEditorProvider), isNull);
      });
    });

    group("text access", () {
      test("getResultText returns null when pending changes exist", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);

        expect(notifier.getResultText(), isNull);
      });

      test("getResultText returns text after all changes resolved", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptAll();

        expect(notifier.getResultText(), equals("Hello new world"));
      });

      test("getCurrentText returns document text", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        expect(notifier.getCurrentText(), equals("Hello world"));
      });

      test("getCurrentText returns empty string when null", () {
        expect(notifier.getCurrentText(), equals(""));
      });
    });

    group("state properties", () {
      test("pendingChangeCount returns correct count", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        notifier.initialize(diffs);

        expect(notifier.pendingChangeCount, equals(2));
      });

      test("totalChangeCount returns correct count", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();

        expect(notifier.totalChangeCount, equals(2));
        expect(notifier.pendingChangeCount, equals(1));
      });

      test("hasUnsavedChanges returns false initially", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        expect(notifier.hasUnsavedChanges, isFalse);
      });

      test("hasUnsavedChanges returns true after accept", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();

        expect(notifier.hasUnsavedChanges, isTrue);
      });

      test("null state returns zero counts", () {
        expect(notifier.pendingChangeCount, equals(0));
        expect(notifier.totalChangeCount, equals(0));
        expect(notifier.hasUnsavedChanges, isFalse);
        expect(notifier.canUndo, isFalse);
        expect(notifier.canRedo, isFalse);
      });
    });

    group("handleKey mode transitions", () {
      test("pressing i enters insert mode", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyI,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.mode, equals(VimMode.insert));
      });

      test("pressing Escape in insert mode returns to normal mode", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyI,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.escape,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.mode, equals(VimMode.normal));
      });

      test("pressing v enters visual mode", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyV,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.mode, equals(VimMode.visual));
      });
    });

    group("handleKey cursor movement", () {
      test("pressing l moves cursor right", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);
        final initialPos = container
            .read(selectionEditorProvider)!
            .vimState
            .cursorPosition;

        notifier.handleKey(
          LogicalKeyboardKey.keyL,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.cursorPosition, equals(initialPos + 1));
      });

      test("pressing h moves cursor left", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyL,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.keyL,
          shift: false,
          ctrl: false,
          meta: false,
        );
        final posAfterRight = container
            .read(selectionEditorProvider)!
            .vimState
            .cursorPosition;

        notifier.handleKey(
          LogicalKeyboardKey.keyH,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.cursorPosition, equals(posAfterRight - 1));
      });
    });

    group("handleKey text insertion", () {
      test("typing in insert mode inserts text", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyI,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.keyX,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.document.getText().contains("x"), isTrue);
      });

      test("backspace in insert mode deletes character", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyI,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.keyL,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.keyL,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final textBefore = container
            .read(selectionEditorProvider)!
            .document
            .getText();

        notifier.handleKey(
          LogicalKeyboardKey.backspace,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final textAfter = container
            .read(selectionEditorProvider)!
            .document
            .getText();
        expect(textAfter.length, equals(textBefore.length - 1));
      });
    });

    group("handleKey delete operations", () {
      test("x in normal mode deletes character at cursor", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        notifier.initialize(diffs);
        final textBefore = container
            .read(selectionEditorProvider)!
            .document
            .getText();

        notifier.handleKey(
          LogicalKeyboardKey.keyX,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final textAfter = container
            .read(selectionEditorProvider)!
            .document
            .getText();
        expect(textAfter.length, equals(textBefore.length - 1));
      });
    });

    group("handleKey undo/redo", () {
      test("u undoes last change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();

        notifier.handleKey(
          LogicalKeyboardKey.keyU,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.pending),
        );
      });

      test("Ctrl+r redoes undone change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "new "),
          Diff(DIFF_EQUAL, "world"),
        ];
        notifier.initialize(diffs);
        notifier.acceptCurrentChange();
        notifier.undo();

        notifier.handleKey(
          LogicalKeyboardKey.keyR,
          shift: false,
          ctrl: true,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(
          state!.document.pendingChanges.first.status,
          equals(ChangeStatus.accepted),
        );
      });
    });

    group("handleKey new line operations", () {
      test("o inserts new line below and enters insert mode", () {
        final diffs = [Diff(DIFF_EQUAL, "Line one\nLine two")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyO,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.mode, equals(VimMode.insert));
        expect(state.document.getText().split("\n").length, greaterThan(2));
      });

      test("O inserts new line above and enters insert mode", () {
        final diffs = [Diff(DIFF_EQUAL, "Line one\nLine two")];
        notifier.initialize(diffs);

        notifier.handleKey(
          LogicalKeyboardKey.keyJ,
          shift: false,
          ctrl: false,
          meta: false,
        );
        notifier.handleKey(
          LogicalKeyboardKey.keyO,
          shift: true,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state!.vimState.mode, equals(VimMode.insert));
        expect(state.document.getText().split("\n").length, greaterThan(2));
      });
    });

    group("handleKey on null state", () {
      test("handleKey on null state is no-op", () {
        notifier.handleKey(
          LogicalKeyboardKey.keyI,
          shift: false,
          ctrl: false,
          meta: false,
        );

        final state = container.read(selectionEditorProvider);
        expect(state, isNull);
      });
    });
  });
}
