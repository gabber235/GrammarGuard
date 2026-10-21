import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/services/vim/vim_handler.dart";
import "package:grammar_guard/services/vim/vim_state.dart";

void main() {
  group("VimHandler", () {
    group("normal mode motions", () {
      test("h moves cursor left", () {
        const text = "Hello world";
        final state = VimState(cursorPosition: 5);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyH,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(4));
      });

      test("l moves cursor right", () {
        const text = "Hello world";
        final state = VimState(cursorPosition: 5);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyL,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(6));
      });

      test("j moves cursor down", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyJ,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(8));
      });

      test("k moves cursor up", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 8);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyK,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(2));
      });

      test("w moves to next word", () {
        const text = "Hello world test";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyW,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(6));
      });

      test("b moves to previous word", () {
        const text = "Hello world test";
        final state = VimState(cursorPosition: 12);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyB,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(6));
      });

      test("e moves to end of word", () {
        const text = "Hello world";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyE,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(4));
      });

      test("0 moves to line start", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 8);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.digit0,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(6));
      });

      test(r"$ moves to line end", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 6);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.digit4,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(10));
      });

      test("gg moves to document start", () {
        const text = "Hello\nWorld\nTest";
        var state = VimState(cursorPosition: 12);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyG,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyG,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(0));
      });

      test("G moves to document end", () {
        const text = "Hello\nWorld\nTest";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyG,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(15));
      });
    });

    group("mode transitions", () {
      test("i enters insert mode", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 3);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyI,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.cursorPosition, equals(3));
      });

      test("a enters insert mode after cursor", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 3);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyA,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.cursorPosition, equals(4));
      });

      test("I enters insert mode at line start", () {
        const text = "Hello\n  World";
        final state = VimState(cursorPosition: 10);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyI,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.cursorPosition, equals(6));
      });

      test("A enters insert mode at line end", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 6);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyA,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.cursorPosition, equals(11));
      });

      test("o enters insert mode on new line below", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 3);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyO,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.insertNewLineBelow, isTrue);
      });

      test("O enters insert mode on new line above", () {
        const text = "Hello\nWorld";
        final state = VimState(cursorPosition: 8);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyO,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.insertNewLineAbove, isTrue);
      });

      test("v enters visual mode", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyV,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.visual));
        expect(result.visualStart, equals(2));
      });

      test("escape in insert mode returns to normal", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 3);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.escape,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.normal));
      });

      test("escape in visual mode returns to normal", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.visual, cursorPosition: 3, visualStart: 1);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.escape,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.normal));
        expect(result.visualStart, isNull);
      });
    });

    group("delete operations", () {
      test("x sets delete at cursor action", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyX,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.deleteAtCursor, isTrue);
      });

      test("dd sets delete line action", () {
        const text = "Hello\nWorld";
        var state = VimState(cursorPosition: 2);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyD,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyD,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.deleteLine, isTrue);
      });

      test("dw sets delete word action", () {
        const text = "Hello world";
        var state = VimState(cursorPosition: 0);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyD,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyW,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.deleteToPosition, equals(6));
      });
    });

    group("count prefix", () {
      test("digit sets count buffer", () {
        const text = "Hello world";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.digit5,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.countBuffer, equals("5"));
      });

      test("multiple digits accumulate", () {
        const text = "Hello world";
        var state = VimState(cursorPosition: 0);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.digit1,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.digit2,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.countBuffer, equals("12"));
      });

      test("count applied to motion", () {
        const text = "a b c d e f g";
        final state = VimState(cursorPosition: 0, countBuffer: "3");
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyW,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.cursorPosition, equals(6));
        expect(result.countBuffer, isEmpty);
      });
    });

    group("visual mode", () {
      test("motions extend selection", () {
        const text = "Hello world";
        final state = VimState(mode: VimMode.visual, cursorPosition: 0, visualStart: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyW,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.visual));
        expect(result.cursorPosition, equals(6));
        expect(result.visualStart, equals(0));
      });

      test("d in visual mode sets delete selection", () {
        const text = "Hello world";
        final state = VimState(mode: VimMode.visual, cursorPosition: 5, visualStart: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyD,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.deleteSelection, isTrue);
        expect(result.mode, equals(VimMode.normal));
      });

      test("y in visual mode sets yank selection", () {
        const text = "Hello world";
        final state = VimState(mode: VimMode.visual, cursorPosition: 5, visualStart: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyY,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.yankSelection, isTrue);
        expect(result.mode, equals(VimMode.normal));
      });
    });

    group("arrow keys", () {
      test("arrow keys work in normal mode", () {
        const text = "Hello\nWorld";
        var state = VimState(cursorPosition: 2);

        state = VimHandler.handleKey(
          LogicalKeyboardKey.arrowRight,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        expect(state.cursorPosition, equals(3));

        state = VimHandler.handleKey(
          LogicalKeyboardKey.arrowLeft,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        expect(state.cursorPosition, equals(2));

        state = VimHandler.handleKey(
          LogicalKeyboardKey.arrowDown,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        expect(state.cursorPosition, equals(8));

        state = VimHandler.handleKey(
          LogicalKeyboardKey.arrowUp,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        expect(state.cursorPosition, equals(2));
      });

      test("arrow keys work in insert mode", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.arrowRight,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.mode, equals(VimMode.insert));
        expect(result.cursorPosition, equals(3));
      });
    });

    group("insert mode", () {
      test("regular keys pass through as text input", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 5);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyX,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.textToInsert, equals("x"));
      });

      test("shift+letter inserts uppercase", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 5);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyX,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.textToInsert, equals("X"));
      });

      test("backspace sets delete before", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 3);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.backspace,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.deleteBeforeCursor, isTrue);
      });

      test("enter inserts newline", () {
        const text = "Hello";
        final state = VimState(mode: VimMode.insert, cursorPosition: 5);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.enter,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.textToInsert, equals("\n"));
      });

      group("typed character", () {
        const insertState = VimState(mode: VimMode.insert, cursorPosition: 5);

        VimHandlerResult type(LogicalKeyboardKey key, String? character, {bool shift = false, bool ctrl = false}) =>
            VimHandler.handleKey(
              key,
              "Hello",
              insertState,
              shift: shift,
              ctrl: ctrl,
              meta: false,
              character: character,
            );

        test("inserts punctuation the key label cannot express", () {
          expect(type(LogicalKeyboardKey.period, ".").textToInsert, equals("."));
          expect(type(LogicalKeyboardKey.comma, ",").textToInsert, equals(","));
          expect(type(LogicalKeyboardKey.digit1, "!", shift: true).textToInsert, equals("!"));
          expect(type(LogicalKeyboardKey.slash, "?", shift: true).textToInsert, equals("?"));
          expect(type(LogicalKeyboardKey.quote, "'").textToInsert, equals("'"));
        });

        test("inserts accented and non Latin characters", () {
          expect(type(LogicalKeyboardKey.keyE, "é").textToInsert, equals("é"));
          expect(type(LogicalKeyboardKey.keyU, "ü").textToInsert, equals("ü"));
          expect(type(LogicalKeyboardKey.keyE, "ë").textToInsert, equals("ë"));
          expect(type(LogicalKeyboardKey.keyA, "한").textToInsert, equals("한"));
        });

        test("prefers the typed character over the key label", () {
          // An AZERTY keyboard reports keyQ for the key that types "a".
          expect(type(LogicalKeyboardKey.keyQ, "a").textToInsert, equals("a"));
        });

        test("falls back to the key label without a character", () {
          expect(type(LogicalKeyboardKey.keyX, null).textToInsert, equals("x"));
          expect(type(LogicalKeyboardKey.keyX, "").textToInsert, equals("x"));
        });

        test("ignores control characters", () {
          expect(type(LogicalKeyboardKey.period, "\u0001").textToInsert, isNull);
          expect(type(LogicalKeyboardKey.delete, "\u007F").textToInsert, isNull);
        });

        test("ignores the character while ctrl is held", () {
          expect(type(LogicalKeyboardKey.period, ".", ctrl: true).textToInsert, isNull);
        });

        test("normal mode ignores the character", () {
          final result = VimHandler.handleKey(
            LogicalKeyboardKey.period,
            "Hello",
            const VimState(cursorPosition: 1),
            shift: false,
            ctrl: false,
            meta: false,
            character: ".",
          );

          expect(result.textToInsert, isNull);
          expect(result.mode, equals(VimMode.normal));
        });
      });
    });

    group("change operations", () {
      test("cc sets change line action", () {
        const text = "Hello\nWorld";
        var state = VimState(cursorPosition: 2);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyC,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyC,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.changeLine, isTrue);
        expect(result.mode, equals(VimMode.insert));
      });

      test("cw sets change word action", () {
        const text = "Hello world";
        var state = VimState(cursorPosition: 0);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyC,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyW,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.changeToPosition, equals(6));
        expect(result.mode, equals(VimMode.insert));
      });
    });

    group("yank and put", () {
      test("yy sets yank line action", () {
        const text = "Hello\nWorld";
        var state = VimState(cursorPosition: 2);
        state = VimHandler.handleKey(
          LogicalKeyboardKey.keyY,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        ).toVimState();
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyY,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.yankLine, isTrue);
      });

      test("p sets paste after action", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyP,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.pasteAfter, isTrue);
      });

      test("P sets paste before action", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 2);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyP,
          text,
          state,
          shift: true,
          ctrl: false,
          meta: false,
        );

        expect(result.pasteBefore, isTrue);
      });
    });

    group("undo/redo", () {
      test("u sets undo action", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyU,
          text,
          state,
          shift: false,
          ctrl: false,
          meta: false,
        );

        expect(result.undo, isTrue);
      });

      test("ctrl+r sets redo action", () {
        const text = "Hello";
        final state = VimState(cursorPosition: 0);
        final result = VimHandler.handleKey(
          LogicalKeyboardKey.keyR,
          text,
          state,
          shift: false,
          ctrl: true,
          meta: false,
        );

        expect(result.redo, isTrue);
      });
    });
  });
}
