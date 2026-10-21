import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/services/vim/vim_state.dart";

void main() {
  group("VimMode", () {
    test("has all expected modes", () {
      expect(VimMode.values, containsAll([VimMode.normal, VimMode.insert, VimMode.visual]));
    });

    test("displayName returns correct strings", () {
      expect(VimMode.normal.displayName, equals("NORMAL"));
      expect(VimMode.insert.displayName, equals("INSERT"));
      expect(VimMode.visual.displayName, equals("VISUAL"));
    });
  });

  group("VimState", () {
    group("creation", () {
      test("creates with default values", () {
        final state = VimState();

        expect(state.mode, equals(VimMode.normal));
        expect(state.cursorPosition, equals(0));
        expect(state.visualStart, isNull);
        expect(state.pendingOperator, isNull);
        expect(state.countBuffer, isEmpty);
      });

      test("creates with custom values", () {
        final state = VimState(mode: VimMode.insert, cursorPosition: 10);

        expect(state.mode, equals(VimMode.insert));
        expect(state.cursorPosition, equals(10));
      });
    });

    group("mode transitions", () {
      test("enterInsertMode changes mode to insert", () {
        final state = VimState();
        final newState = state.enterInsertMode();

        expect(newState.mode, equals(VimMode.insert));
        expect(state.mode, equals(VimMode.normal));
      });

      test("enterNormalMode changes mode to normal", () {
        final state = VimState(mode: VimMode.insert);
        final newState = state.enterNormalMode();

        expect(newState.mode, equals(VimMode.normal));
      });

      test("enterVisualMode changes mode to visual and sets visualStart", () {
        final state = VimState(cursorPosition: 5);
        final newState = state.enterVisualMode();

        expect(newState.mode, equals(VimMode.visual));
        expect(newState.visualStart, equals(5));
      });

      test("exitVisualMode returns to normal and clears visualStart", () {
        final state = VimState(mode: VimMode.visual, cursorPosition: 10, visualStart: 5);
        final newState = state.exitVisualMode();

        expect(newState.mode, equals(VimMode.normal));
        expect(newState.visualStart, isNull);
      });
    });

    group("cursor movement", () {
      test("moveCursor updates cursor position", () {
        final state = VimState(cursorPosition: 5);
        final newState = state.moveCursor(10);

        expect(newState.cursorPosition, equals(10));
        expect(state.cursorPosition, equals(5));
      });

      test("moveCursor clamps to non-negative", () {
        final state = VimState(cursorPosition: 5);
        final newState = state.moveCursor(-5);

        expect(newState.cursorPosition, equals(0));
      });
    });

    group("visual selection", () {
      test("getSelectionRange returns null when not in visual mode", () {
        final state = VimState(cursorPosition: 5);

        expect(state.getSelectionRange(), isNull);
      });

      test("getSelectionRange returns range when in visual mode", () {
        final state = VimState(mode: VimMode.visual, cursorPosition: 10, visualStart: 5);

        final range = state.getSelectionRange();
        expect(range, isNotNull);
        expect(range!.$1, equals(5));
        expect(range.$2, equals(10));
      });

      test("getSelectionRange handles reversed selection", () {
        final state = VimState(mode: VimMode.visual, cursorPosition: 3, visualStart: 10);

        final range = state.getSelectionRange();
        expect(range, isNotNull);
        expect(range!.$1, equals(3));
        expect(range.$2, equals(10));
      });
    });

    group("pending operator", () {
      test("setPendingOperator stores operator", () {
        final state = VimState();
        final newState = state.setPendingOperator("d");

        expect(newState.pendingOperator, equals("d"));
      });

      test("clearPendingOperator removes operator", () {
        final state = VimState(pendingOperator: "d");
        final newState = state.clearPendingOperator();

        expect(newState.pendingOperator, isNull);
      });

      test("hasPendingOperator returns correct value", () {
        final withOperator = VimState(pendingOperator: "d");
        final withoutOperator = VimState();

        expect(withOperator.hasPendingOperator, isTrue);
        expect(withoutOperator.hasPendingOperator, isFalse);
      });
    });

    group("count buffer", () {
      test("appendToCountBuffer adds digit", () {
        final state = VimState();
        final newState = state.appendToCountBuffer("5");

        expect(newState.countBuffer, equals("5"));
      });

      test("appendToCountBuffer accumulates digits", () {
        final state = VimState(countBuffer: "1");
        final newState = state.appendToCountBuffer("2");

        expect(newState.countBuffer, equals("12"));
      });

      test("clearCountBuffer empties buffer", () {
        final state = VimState(countBuffer: "123");
        final newState = state.clearCountBuffer();

        expect(newState.countBuffer, isEmpty);
      });

      test("getCount returns 1 when buffer is empty", () {
        final state = VimState();

        expect(state.getCount(), equals(1));
      });

      test("getCount parses buffer as int", () {
        final state = VimState(countBuffer: "15");

        expect(state.getCount(), equals(15));
      });

      test("getCount returns 1 for invalid buffer", () {
        final state = VimState(countBuffer: "abc");

        expect(state.getCount(), equals(1));
      });
    });

    group("copyWith", () {
      test("copies with new mode", () {
        final state = VimState(mode: VimMode.normal, cursorPosition: 5);
        final copied = state.copyWith(mode: VimMode.insert);

        expect(copied.mode, equals(VimMode.insert));
        expect(copied.cursorPosition, equals(5));
      });

      test("copies with multiple changes", () {
        final state = VimState();
        final copied = state.copyWith(mode: VimMode.visual, cursorPosition: 10, visualStart: 5);

        expect(copied.mode, equals(VimMode.visual));
        expect(copied.cursorPosition, equals(10));
        expect(copied.visualStart, equals(5));
      });
    });

    group("isInMode helpers", () {
      test("isNormalMode returns true only in normal mode", () {
        expect(VimState(mode: VimMode.normal).isNormalMode, isTrue);
        expect(VimState(mode: VimMode.insert).isNormalMode, isFalse);
        expect(VimState(mode: VimMode.visual).isNormalMode, isFalse);
      });

      test("isInsertMode returns true only in insert mode", () {
        expect(VimState(mode: VimMode.normal).isInsertMode, isFalse);
        expect(VimState(mode: VimMode.insert).isInsertMode, isTrue);
        expect(VimState(mode: VimMode.visual).isInsertMode, isFalse);
      });

      test("isVisualMode returns true only in visual mode", () {
        expect(VimState(mode: VimMode.normal).isVisualMode, isFalse);
        expect(VimState(mode: VimMode.insert).isVisualMode, isFalse);
        expect(VimState(mode: VimMode.visual).isVisualMode, isTrue);
      });
    });
  });
}
