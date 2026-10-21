import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/review/word_diff.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Review.handleKey never stores the result's pendingOperator or
/// countBuffer in the Vim state, so the first key of dd, cw, yy, gg or 3w
/// is forgotten before the second arrives. Unskip once that is fixed.

/// Review.handleKey moves the cursor through SelectionEditorState.moveCursor,
/// which clamps to the last character even in insert mode.

void main() {
  group("Review", () {
    late ProviderContainer container;

    /// A fresh review built from [diffs], as if a run just finished.
    void initialize(List<Diff>? diffs) {
      container = ProviderContainer(overrides: [reviewDiffProvider.overrideWithValue(diffs)]);
      addTearDown(container.dispose);
    }

    Review notifier() => container.read(reviewProvider.notifier);
    SelectionEditorState? state() => container.read(reviewProvider);
    String text() => state()!.document.getText();

    void press(LogicalKeyboardKey key, {bool shift = false, bool ctrl = false, String? character}) =>
        notifier().handleKey(key, shift: shift, ctrl: ctrl, meta: false, character: character);

    void type(String characters) {
      for (final rune in characters.runes) {
        final character = String.fromCharCode(rune);
        press(character == " " ? LogicalKeyboardKey.space : LogicalKeyboardKey.keyA, character: character);
      }
    }

    final helloNew = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "new "), Diff(DIFF_EQUAL, "world")];

    final twoInsertions = [
      Diff(DIFF_EQUAL, "A "),
      Diff(DIFF_INSERT, "first "),
      Diff(DIFF_EQUAL, "B "),
      Diff(DIFF_INSERT, "second "),
      Diff(DIFF_EQUAL, "C"),
    ];

    final plain = [Diff(DIFF_EQUAL, "Hello world")];

    setUp(() => initialize(null));

    group("initialization", () {
      test("is null without a finished result", () {
        expect(state(), isNull);
      });

      test("builds from the review diff", () {
        initialize([
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ]);

        expect(state(), isNotNull);
        expect(text(), equals("Hello oldnew world"));
        expect(state()!.vimState.cursorPosition, equals(6));
      });
    });

    group("keep and undo", () {
      test("keep accepts the change at the cursor", () {
        initialize(helloNew);

        notifier().keep();

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });

      test("undo rejects the change at the cursor", () {
        initialize(helloNew);

        notifier().undo();

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.rejected));
      });

      test("keepAll accepts every pending change", () {
        initialize(twoInsertions);

        notifier().keepAll();

        expect(state()!.document.pendingChanges.map((c) => c.status), everyElement(ChangeStatus.accepted));
      });

      test("undoAll rejects every pending change", () {
        initialize(twoInsertions);

        notifier().undoAll();

        expect(state()!.document.pendingChanges.map((c) => c.status), everyElement(ChangeStatus.rejected));
      });

      test("keepAt and undoAt decide by index", () {
        initialize(twoInsertions);

        notifier()
          ..undoAt(1)
          ..keepAt(0);

        expect(
          state()!.document.pendingChanges.map((c) => c.status),
          equals([ChangeStatus.accepted, ChangeStatus.rejected]),
        );
        expect(state()!.finalText, equals("A first B C"));
      });

      test("keepAt ignores an index out of range", () {
        initialize(twoInsertions);
        final before = state();

        notifier()
          ..keepAt(-1)
          ..keepAt(2)
          ..undoAt(5);

        expect(state(), same(before));
      });

      test("operations without a review are no-ops", () {
        notifier()
          ..keep()
          ..undo()
          ..keepAll()
          ..undoAll()
          ..keepAt(0)
          ..undoAt(0)
          ..next()
          ..previous()
          ..undoLast()
          ..redoLast();

        expect(state(), isNull);
      });
    });

    group("navigation", () {
      test("next moves to the following pending change", () {
        initialize(twoInsertions);

        notifier().next();

        expect(state()!.vimState.cursorPosition, equals(state()!.document.getChangeStartPosition(1)));
      });

      test("next stays on the last pending change", () {
        initialize(twoInsertions);

        notifier()
          ..next()
          ..next();

        expect(state()!.vimState.cursorPosition, equals(state()!.document.getChangeStartPosition(1)));
      });

      test("previous moves back to the earlier pending change", () {
        initialize(twoInsertions);

        notifier()
          ..next()
          ..previous();

        expect(state()!.vimState.cursorPosition, equals(state()!.document.getChangeStartPosition(0)));
      });

      test("next skips decided changes", () {
        initialize([...twoInsertions, Diff(DIFF_INSERT, " third")]);
        notifier()
          ..undoAt(1)
          ..previous();
        expect(state()!.vimState.cursorPosition, equals(state()!.document.getChangeStartPosition(0)));

        notifier().next();

        expect(state()!.vimState.cursorPosition, equals(state()!.document.getChangeStartPosition(2)));
      });
    });

    group("undoLast and redoLast", () {
      test("undoLast reverts the last decision", () {
        initialize(helloNew);
        notifier()
          ..keep()
          ..undoLast();

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.pending));
      });

      test("redoLast restores the undone decision", () {
        initialize(helloNew);
        notifier()
          ..keep()
          ..undoLast()
          ..redoLast();

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });

      test("there is no history right after building", () {
        initialize(plain);

        expect(state()!.canUndo, isFalse);
        expect(state()!.canRedo, isFalse);
      });
    });

    group("finalText and decisions", () {
      test("finalText keeps open changes", () {
        initialize(helloNew);

        expect(state()!.finalText, equals("Hello new world"));
      });

      test("finalText respects undone changes", () {
        initialize(helloNew);
        notifier().undo();

        expect(state()!.finalText, equals("Hello world"));
      });

      test("finalText is the plain text without changes", () {
        initialize(plain);

        expect(state()!.finalText, equals("Hello world"));
      });

      test("decisions list every change, open ones as kept", () {
        initialize([
          Diff(DIFF_DELETE, "teh"),
          Diff(DIFF_INSERT, "the"),
          Diff(DIFF_EQUAL, " "),
          Diff(DIFF_DELETE, "kat"),
          Diff(DIFF_INSERT, "cat"),
        ]);
        notifier().undoAt(1);

        expect(
          state()!.decisions,
          equals(const [
            Decision(before: "teh", after: "the", kept: true),
            Decision(before: "kat", after: "cat", kept: false),
          ]),
        );
      });
    });

    group("counts", () {
      test("pending and total change counts", () {
        initialize(twoInsertions);
        notifier().keep();

        expect(state()!.getTotalChangeCount(), equals(2));
        expect(state()!.getPendingChangeCount(), equals(1));
      });
    });

    // B2: undoing a replacement must bring back the exact original word.
    group("undoing a replacement (B2)", () {
      test("restores the original word from a hand built diff", () {
        initialize([
          Diff(DIFF_EQUAL, "I eat "),
          Diff(DIFF_DELETE, "food"),
          Diff(DIFF_INSERT, "foods"),
          Diff(DIFF_EQUAL, "."),
        ]);

        notifier().undo();

        expect(state()!.finalText, equals("I eat food."));
        expect(state()!.decisions.single, equals(const Decision(before: "food", after: "foods", kept: false)));
      });

      test("a word diff gives one whole word replacement that undo restores", () {
        initialize(wordDiff("I eat food.", "I eat foods."));

        expect(
          state()!.document.pendingChanges,
          equals([PendingChange.replacement(originalText: "food", newText: "foods")]),
        );
        notifier().undo();
        expect(state()!.finalText, equals("I eat food."));
      });

      test("restores the original text from a word diff", () {
        const before = "Ik heb  de café's gezien, maar teh rest niet.";
        const after = "Ik heb de cafés gezien maar de rest niet!";
        initialize(wordDiff(before, after));

        notifier().undoAll();
        expect(state()!.finalText, equals(before));

        notifier().keepAll();
        expect(state()!.finalText, equals(before), reason: "decided changes stay decided");
      });

      test("undo of each replacement one by one restores the input", () {
        const before = "teh food is grate";
        const after = "the foods are great";
        initialize(wordDiff(before, after));

        while (state()!.getPendingChangeCount() > 0) {
          notifier().undo();
        }

        expect(state()!.finalText, equals(before));
        expect(state()!.decisions.map((d) => d.kept), everyElement(isFalse));
      });

      test("keeping every replacement gives the result", () {
        const before = "teh food is grate";
        const after = "the foods are great";
        initialize(wordDiff(before, after));

        notifier().keepAll();

        expect(state()!.finalText, equals(after));
      });
    });

    group("handleKey modes", () {
      test("i enters insert mode", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyI);

        expect(state()!.vimState.mode, equals(VimMode.insert));
      });

      test("Escape in insert mode returns to normal mode", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyI);
        press(LogicalKeyboardKey.escape);

        expect(state()!.vimState.mode, equals(VimMode.normal));
      });

      test("v enters visual mode", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyV);

        expect(state()!.vimState.mode, equals(VimMode.visual));
      });

      test("keys without a review are no-ops", () {
        press(LogicalKeyboardKey.keyI);

        expect(state(), isNull);
      });
    });

    group("handleKey cursor movement", () {
      test("l moves the cursor right", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyL);

        expect(state()!.vimState.cursorPosition, equals(1));
      });

      test("h moves the cursor left", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyH);

        expect(state()!.vimState.cursorPosition, equals(1));
      });
    });

    group("handleKey editing", () {
      test("typing in insert mode inserts text", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyI);
        press(LogicalKeyboardKey.keyX);

        expect(text(), equals("xHello world"));
        expect(state()!.vimState.mode, equals(VimMode.insert));
      });

      test("insert mode types punctuation and accents from the character", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyI);
        press(LogicalKeyboardKey.keyE, character: "é");
        press(LogicalKeyboardKey.digit1, shift: true, character: "!");
        press(LogicalKeyboardKey.comma, character: ",");
        press(LogicalKeyboardKey.quote, character: "'");
        press(LogicalKeyboardKey.space, character: " ");

        expect(text(), equals("é!,' Hello world"));
      });

      test("backspace in insert mode deletes the character before", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyI);
        press(LogicalKeyboardKey.backspace);

        expect(text(), equals("Hllo world"));
      });

      test("x deletes the character at the cursor", () {
        initialize(plain);

        press(LogicalKeyboardKey.keyX);

        expect(text(), equals("ello world"));
      });

      test("o opens a line below in insert mode", () {
        initialize([Diff(DIFF_EQUAL, "Line one\nLine two")]);

        press(LogicalKeyboardKey.keyO);

        expect(state()!.vimState.mode, equals(VimMode.insert));
        expect(text(), equals("Line one\n\nLine two"));
      });

      test("O opens a line above in insert mode", () {
        initialize([Diff(DIFF_EQUAL, "Line one\nLine two")]);

        press(LogicalKeyboardKey.keyJ);
        press(LogicalKeyboardKey.keyO, shift: true);

        expect(state()!.vimState.mode, equals(VimMode.insert));
        expect(text(), equals("Line one\n\nLine two"));
      });
    });

    group("handleKey undo and redo", () {
      test("u undoes the last decision", () {
        initialize(helloNew);
        notifier().keep();

        press(LogicalKeyboardKey.keyU);

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.pending));
      });

      test("Ctrl+R redoes the undone decision", () {
        initialize(helloNew);
        notifier()
          ..keep()
          ..undoLast();

        press(LogicalKeyboardKey.keyR, ctrl: true);

        expect(state()!.document.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });
    });

    // B3: every keystroke used to flatten the document, baking
    // "original + suggestion" into the text and dropping all suggestions.
    group("editing next to pending changes (B3)", () {
      final theCat = [Diff(DIFF_DELETE, "teh"), Diff(DIFF_INSERT, "the"), Diff(DIFF_EQUAL, " cat sat")];

      test("typing in plain text keeps the change pending", () {
        initialize(theCat);

        press(LogicalKeyboardKey.keyW); // onto "cat"
        press(LogicalKeyboardKey.keyI);
        type("big ");

        expect(text(), equals("tehthe big cat sat"));
        expect(state()!.getPendingChangeCount(), equals(1));
        expect(state()!.finalText, equals("the big cat sat"));
        notifier().undoAt(0);
        expect(state()!.finalText, equals("teh big cat sat"));
      });

      test("typing inside the suggestion keeps it", () {
        initialize(theCat);

        for (var i = 0; i < 4; i++) {
          press(LogicalKeyboardKey.keyL);
        }
        press(LogicalKeyboardKey.keyI);
        type("X");

        expect(text(), equals("tXhe cat sat"));
        expect(state()!.getPendingChangeCount(), equals(0));
        expect(state()!.finalText, equals("tXhe cat sat"));
        // Typed over: neither kept nor undone, so no habit to learn from.
        expect(state()!.decisions, isEmpty);
      });

      test("typing inside the original undoes the suggestion", () {
        initialize(theCat);

        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyI);
        type("X");

        expect(text(), equals("tXeh cat sat"));
        expect(state()!.getPendingChangeCount(), equals(0));
      });

      test("u after typing restores the pending change", () {
        initialize(theCat);
        final original = state()!.document;

        press(LogicalKeyboardKey.keyL);
        press(LogicalKeyboardKey.keyI);
        type("X");
        press(LogicalKeyboardKey.escape);
        press(LogicalKeyboardKey.keyU);

        expect(state()!.document, equals(original));
        expect(state()!.getPendingChangeCount(), equals(1));
      });

      test("cw stays in insert mode and keeps the change", () {
        initialize(theCat);

        press(LogicalKeyboardKey.keyW); // onto "cat"
        press(LogicalKeyboardKey.keyC);
        press(LogicalKeyboardKey.keyW);
        expect(state()!.vimState.mode, equals(VimMode.insert));
        type("dog ");

        expect(state()!.vimState.mode, equals(VimMode.insert));
        expect(text(), equals("tehthe dog sat"));
        expect(state()!.getPendingChangeCount(), equals(1));
      });

      test("dd keeps changes on other lines and the undo history", () {
        initialize([
          Diff(DIFF_DELETE, "teh"),
          Diff(DIFF_INSERT, "the"),
          Diff(DIFF_EQUAL, " cat\nmiddle line\nthe "),
          Diff(DIFF_DELETE, "dgo"),
          Diff(DIFF_INSERT, "dog"),
        ]);
        final original = state()!.document;
        notifier().keep(); // first change, cursor moves to the second

        press(LogicalKeyboardKey.keyG);
        press(LogicalKeyboardKey.keyG);
        press(LogicalKeyboardKey.keyJ);
        press(LogicalKeyboardKey.keyD);
        press(LogicalKeyboardKey.keyD);

        expect(text(), equals("the cat\nthe dgodog"));
        expect(
          state()!.document.pendingChanges.map((c) => c.status),
          equals([ChangeStatus.accepted, ChangeStatus.pending]),
        );
        expect(state()!.undoStack, hasLength(2));

        press(LogicalKeyboardKey.keyU);
        expect(text(), equals("the cat\nmiddle line\nthe dgodog"));
        press(LogicalKeyboardKey.keyU);
        expect(state()!.document, equals(original));
      });

      test("A then typing appends at the end of the line", () {
        initialize([Diff(DIFF_DELETE, "teh"), Diff(DIFF_INSERT, "the"), Diff(DIFF_EQUAL, " cat")]);

        press(LogicalKeyboardKey.keyA, shift: true);
        type("!");

        expect(text(), equals("tehthe cat!"));
        expect(state()!.getPendingChangeCount(), equals(1));
      });
    });
  });
}
