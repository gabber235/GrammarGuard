import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/services/vim/vim_motions.dart";

void main() {
  group("VimMotions", () {
    group("character motions", () {
      test("moveLeft moves cursor one position left", () {
        const text = "Hello world";
        final result = VimMotions.moveLeft(text, 5);
        expect(result, equals(4));
      });

      test("moveLeft stops at position 0", () {
        const text = "Hello world";
        final result = VimMotions.moveLeft(text, 0);
        expect(result, equals(0));
      });

      test("moveRight moves cursor one position right", () {
        const text = "Hello world";
        final result = VimMotions.moveRight(text, 5);
        expect(result, equals(6));
      });

      test("moveRight stops at end of text", () {
        const text = "Hello";
        final result = VimMotions.moveRight(text, 4);
        expect(result, equals(4));
      });

      test("moveRight allows moving to last character", () {
        const text = "Hello";
        final result = VimMotions.moveRight(text, 3);
        expect(result, equals(4));
      });
    });

    group("line motions", () {
      test("moveUp moves to same column on previous line", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveUp(text, 8);
        expect(result, equals(2));
      });

      test("moveUp stays on first line when already there", () {
        const text = "Hello\nWorld";
        final result = VimMotions.moveUp(text, 3);
        expect(result, equals(3));
      });

      test("moveUp adjusts column if previous line is shorter", () {
        const text = "Hi\nWorld";
        final result = VimMotions.moveUp(text, 7);
        expect(result, equals(1));
      });

      test("moveDown moves to same column on next line", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveDown(text, 2);
        expect(result, equals(8));
      });

      test("moveDown stays on last line when already there", () {
        const text = "Hello\nWorld";
        final result = VimMotions.moveDown(text, 8);
        expect(result, equals(8));
      });

      test("moveDown adjusts column if next line is shorter", () {
        const text = "Hello\nHi";
        final result = VimMotions.moveDown(text, 4);
        expect(result, equals(7));
      });
    });

    group("word motions", () {
      test("moveWordForward moves to start of next word", () {
        const text = "Hello world test";
        final result = VimMotions.moveWordForward(text, 0);
        expect(result, equals(6));
      });

      test("moveWordForward from middle of word goes to next word", () {
        const text = "Hello world test";
        final result = VimMotions.moveWordForward(text, 2);
        expect(result, equals(6));
      });

      test("moveWordForward at last word goes to end", () {
        const text = "Hello world";
        final result = VimMotions.moveWordForward(text, 6);
        expect(result, equals(10));
      });

      test("moveWordForward handles punctuation as word boundary", () {
        const text = "Hello, world";
        final result = VimMotions.moveWordForward(text, 0);
        expect(result, equals(5));
      });

      test("moveWordBackward moves to start of previous word", () {
        const text = "Hello world test";
        final result = VimMotions.moveWordBackward(text, 12);
        expect(result, equals(6));
      });

      test("moveWordBackward from middle of word goes to start", () {
        const text = "Hello world";
        final result = VimMotions.moveWordBackward(text, 8);
        expect(result, equals(6));
      });

      test("moveWordBackward at first word goes to position 0", () {
        const text = "Hello world";
        final result = VimMotions.moveWordBackward(text, 3);
        expect(result, equals(0));
      });

      test("moveWordEnd moves to end of current word", () {
        const text = "Hello world";
        final result = VimMotions.moveWordEnd(text, 0);
        expect(result, equals(4));
      });

      test("moveWordEnd at end of word moves to end of next word", () {
        const text = "Hello world";
        final result = VimMotions.moveWordEnd(text, 4);
        expect(result, equals(10));
      });

      test("moveWordEnd from space moves to end of next word", () {
        const text = "Hello world";
        final result = VimMotions.moveWordEnd(text, 5);
        expect(result, equals(10));
      });
    });

    group("line position motions", () {
      test("moveToLineStart moves to beginning of current line", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveToLineStart(text, 8);
        expect(result, equals(6));
      });

      test("moveToLineStart on first line moves to 0", () {
        const text = "Hello\nWorld";
        final result = VimMotions.moveToLineStart(text, 3);
        expect(result, equals(0));
      });

      test("moveToLineEnd moves to end of current line", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveToLineEnd(text, 8);
        expect(result, equals(10));
      });

      test("moveToLineEnd on last line moves to end of text", () {
        const text = "Hello\nWorld";
        final result = VimMotions.moveToLineEnd(text, 7);
        expect(result, equals(10));
      });
    });

    group("document motions", () {
      test("moveToDocumentStart moves to position 0", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveToDocumentStart(text, 10);
        expect(result, equals(0));
      });

      test("moveToDocumentEnd moves to last character", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveToDocumentEnd(text, 0);
        expect(result, equals(15));
      });

      test("moveToLine moves to specific line", () {
        const text = "Hello\nWorld\nTest";
        final result = VimMotions.moveToLine(text, 1);
        expect(result, equals(6));
      });

      test("moveToLine clamps to last line if out of bounds", () {
        const text = "Hello\nWorld";
        final result = VimMotions.moveToLine(text, 10);
        expect(result, equals(6));
      });
    });

    group("helper functions", () {
      test("getLineNumber returns correct line for position", () {
        const text = "Hello\nWorld\nTest";
        expect(VimMotions.getLineNumber(text, 0), equals(0));
        expect(VimMotions.getLineNumber(text, 5), equals(0));
        expect(VimMotions.getLineNumber(text, 6), equals(1));
        expect(VimMotions.getLineNumber(text, 12), equals(2));
      });

      test("getColumnNumber returns correct column for position", () {
        const text = "Hello\nWorld\nTest";
        expect(VimMotions.getColumnNumber(text, 0), equals(0));
        expect(VimMotions.getColumnNumber(text, 3), equals(3));
        expect(VimMotions.getColumnNumber(text, 6), equals(0));
        expect(VimMotions.getColumnNumber(text, 8), equals(2));
      });

      test("getLineStartPosition returns start of line", () {
        const text = "Hello\nWorld\nTest";
        expect(VimMotions.getLineStartPosition(text, 0), equals(0));
        expect(VimMotions.getLineStartPosition(text, 1), equals(6));
        expect(VimMotions.getLineStartPosition(text, 2), equals(12));
      });

      test("getLineEndPosition returns end of line", () {
        const text = "Hello\nWorld\nTest";
        expect(VimMotions.getLineEndPosition(text, 0), equals(5));
        expect(VimMotions.getLineEndPosition(text, 1), equals(11));
        expect(VimMotions.getLineEndPosition(text, 2), equals(16));
      });

      test("getLineLength returns length of line", () {
        const text = "Hello\nWorld\nTest";
        expect(VimMotions.getLineLength(text, 0), equals(5));
        expect(VimMotions.getLineLength(text, 1), equals(5));
        expect(VimMotions.getLineLength(text, 2), equals(4));
      });

      test("getLineCount returns number of lines", () {
        expect(VimMotions.getLineCount("Hello"), equals(1));
        expect(VimMotions.getLineCount("Hello\nWorld"), equals(2));
        expect(VimMotions.getLineCount("Hello\nWorld\nTest"), equals(3));
      });
    });
  });
}
