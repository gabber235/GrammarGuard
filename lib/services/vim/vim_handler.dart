import "package:flutter/services.dart";
import "package:grammar_guard/services/vim/vim_motions.dart";
import "package:grammar_guard/services/vim/vim_state.dart";

class VimHandlerResult {

  const VimHandlerResult({
    required this.mode,
    required this.cursorPosition,
    this.visualStart,
    this.pendingOperator,
    this.countBuffer = "",
    this.textToInsert,
    this.deleteAtCursor = false,
    this.deleteBeforeCursor = false,
    this.deleteToPosition,
    this.deleteLine = false,
    this.deleteSelection = false,
    this.changeToPosition,
    this.changeLine = false,
    this.yankLine = false,
    this.yankSelection = false,
    this.pasteAfter = false,
    this.pasteBefore = false,
    this.undo = false,
    this.redo = false,
    this.insertNewLineBelow = false,
    this.insertNewLineAbove = false,
  });

  factory VimHandlerResult.fromState(VimState state) {
    return VimHandlerResult(
      mode: state.mode,
      cursorPosition: state.cursorPosition,
      visualStart: state.visualStart,
      pendingOperator: state.pendingOperator,
      countBuffer: state.countBuffer,
    );
  }
  final VimMode mode;
  final int cursorPosition;
  final int? visualStart;
  final String? pendingOperator;
  final String countBuffer;

  final String? textToInsert;
  final bool deleteAtCursor;
  final bool deleteBeforeCursor;
  final int? deleteToPosition;
  final bool deleteLine;
  final bool deleteSelection;
  final int? changeToPosition;
  final bool changeLine;
  final bool yankLine;
  final bool yankSelection;
  final bool pasteAfter;
  final bool pasteBefore;
  final bool undo;
  final bool redo;
  final bool insertNewLineBelow;
  final bool insertNewLineAbove;

  VimHandlerResult copyWith({
    VimMode? mode,
    int? cursorPosition,
    int? visualStart,
    String? pendingOperator,
    String? countBuffer,
    String? textToInsert,
    bool? deleteAtCursor,
    bool? deleteBeforeCursor,
    int? deleteToPosition,
    bool? deleteLine,
    bool? deleteSelection,
    int? changeToPosition,
    bool? changeLine,
    bool? yankLine,
    bool? yankSelection,
    bool? pasteAfter,
    bool? pasteBefore,
    bool? undo,
    bool? redo,
    bool? insertNewLineBelow,
    bool? insertNewLineAbove,
    bool clearVisualStart = false,
    bool clearPendingOperator = false,
  }) {
    return VimHandlerResult(
      mode: mode ?? this.mode,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      visualStart: clearVisualStart ? null : (visualStart ?? this.visualStart),
      pendingOperator: clearPendingOperator
          ? null
          : (pendingOperator ?? this.pendingOperator),
      countBuffer: countBuffer ?? this.countBuffer,
      textToInsert: textToInsert ?? this.textToInsert,
      deleteAtCursor: deleteAtCursor ?? this.deleteAtCursor,
      deleteBeforeCursor: deleteBeforeCursor ?? this.deleteBeforeCursor,
      deleteToPosition: deleteToPosition ?? this.deleteToPosition,
      deleteLine: deleteLine ?? this.deleteLine,
      deleteSelection: deleteSelection ?? this.deleteSelection,
      changeToPosition: changeToPosition ?? this.changeToPosition,
      changeLine: changeLine ?? this.changeLine,
      yankLine: yankLine ?? this.yankLine,
      yankSelection: yankSelection ?? this.yankSelection,
      pasteAfter: pasteAfter ?? this.pasteAfter,
      pasteBefore: pasteBefore ?? this.pasteBefore,
      undo: undo ?? this.undo,
      redo: redo ?? this.redo,
      insertNewLineBelow: insertNewLineBelow ?? this.insertNewLineBelow,
      insertNewLineAbove: insertNewLineAbove ?? this.insertNewLineAbove,
    );
  }

  VimState toVimState() {
    return VimState(
      mode: mode,
      cursorPosition: cursorPosition,
      visualStart: visualStart,
      pendingOperator: pendingOperator,
      countBuffer: countBuffer,
    );
  }
}

class VimHandler {
  VimHandler._();

  static VimHandlerResult handleKey(
    LogicalKeyboardKey key,
    String text,
    VimState state, {
    required bool shift,
    required bool ctrl,
    required bool meta,
  }) {
    if (state.mode == VimMode.insert) {
      return _handleInsertMode(key, text, state, shift: shift, ctrl: ctrl);
    }

    if (state.mode == VimMode.visual) {
      return _handleVisualMode(key, text, state, shift: shift, ctrl: ctrl);
    }

    return _handleNormalMode(key, text, state, shift: shift, ctrl: ctrl);
  }

  static VimHandlerResult _handleNormalMode(
    LogicalKeyboardKey key,
    String text,
    VimState state, {
    required bool shift,
    required bool ctrl,
  }) {
    final result = VimHandlerResult.fromState(state);
    final count = state.getCount();

    if (key == LogicalKeyboardKey.escape) {
      return result.copyWith(
        countBuffer: "",
        clearPendingOperator: true,
      );
    }

    if (ctrl && key == LogicalKeyboardKey.keyR) {
      return result.copyWith(redo: true, countBuffer: "");
    }

    if (_isDigit(key) &&
        !shift &&
        !(key == LogicalKeyboardKey.digit0 && state.countBuffer.isEmpty)) {
      final digit = _keyToDigit(key);
      if (digit != null) {
        return result.copyWith(countBuffer: state.countBuffer + digit);
      }
    }

    if (state.hasPendingOperator) {
      return _handlePendingOperator(key, text, state, result, shift: shift);
    }

    if (key == LogicalKeyboardKey.keyH || key == LogicalKeyboardKey.arrowLeft) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveLeft(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyL ||
        key == LogicalKeyboardKey.arrowRight) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveRight(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyJ || key == LogicalKeyboardKey.arrowDown) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveDown(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyK || key == LogicalKeyboardKey.arrowUp) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveUp(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyW) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveWordForward(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyB) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveWordBackward(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyE) {
      var pos = state.cursorPosition;
      for (var i = 0; i < count; i++) {
        pos = VimMotions.moveWordEnd(text, pos);
      }
      return result.copyWith(cursorPosition: pos, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.digit0 && state.countBuffer.isEmpty) {
      return result.copyWith(
        cursorPosition: VimMotions.moveToLineStart(text, state.cursorPosition),
        countBuffer: "",
      );
    }

    if ((key == LogicalKeyboardKey.digit4 && shift) ||
        key == LogicalKeyboardKey.dollar) {
      return result.copyWith(
        cursorPosition: VimMotions.moveToLineEnd(text, state.cursorPosition),
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyG && shift) {
      return result.copyWith(
        cursorPosition:
            VimMotions.moveToDocumentEnd(text, state.cursorPosition),
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyG && !shift) {
      return result.copyWith(
        pendingOperator: "g",
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyI && !shift) {
      return result.copyWith(
        mode: VimMode.insert,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyI && shift) {
      return result.copyWith(
        mode: VimMode.insert,
        cursorPosition: VimMotions.moveToLineStart(text, state.cursorPosition),
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyA && !shift) {
      final newPos = (state.cursorPosition + 1).clamp(0, text.length);
      return result.copyWith(
        mode: VimMode.insert,
        cursorPosition: newPos,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyA && shift) {
      final lineEnd = VimMotions.getLineEndPosition(
        text,
        VimMotions.getLineNumber(text, state.cursorPosition),
      );
      return result.copyWith(
        mode: VimMode.insert,
        cursorPosition: lineEnd,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyO && !shift) {
      return result.copyWith(
        mode: VimMode.insert,
        insertNewLineBelow: true,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyO && shift) {
      return result.copyWith(
        mode: VimMode.insert,
        insertNewLineAbove: true,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyV && !shift) {
      return result.copyWith(
        mode: VimMode.visual,
        visualStart: state.cursorPosition,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyX) {
      return result.copyWith(deleteAtCursor: true, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyD) {
      return result.copyWith(pendingOperator: "d");
    }

    if (key == LogicalKeyboardKey.keyC) {
      return result.copyWith(pendingOperator: "c");
    }

    if (key == LogicalKeyboardKey.keyY) {
      return result.copyWith(pendingOperator: "y");
    }

    if (key == LogicalKeyboardKey.keyP && !shift) {
      return result.copyWith(pasteAfter: true, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyP && shift) {
      return result.copyWith(pasteBefore: true, countBuffer: "");
    }

    if (key == LogicalKeyboardKey.keyU && !ctrl) {
      return result.copyWith(undo: true, countBuffer: "");
    }

    return result;
  }

  static VimHandlerResult _handlePendingOperator(
    LogicalKeyboardKey key,
    String text,
    VimState state,
    VimHandlerResult result, {
    required bool shift,
  }) {
    final operator = state.pendingOperator;

    if (operator == "g" && key == LogicalKeyboardKey.keyG) {
      return result.copyWith(
        cursorPosition:
            VimMotions.moveToDocumentStart(text, state.cursorPosition),
        countBuffer: "",
        clearPendingOperator: true,
      );
    }

    if (operator == "d") {
      if (key == LogicalKeyboardKey.keyD) {
        return result.copyWith(
          deleteLine: true,
          countBuffer: "",
          clearPendingOperator: true,
        );
      }
      if (key == LogicalKeyboardKey.keyW) {
        final targetPos =
            VimMotions.moveWordForward(text, state.cursorPosition);
        return result.copyWith(
          deleteToPosition: targetPos,
          countBuffer: "",
          clearPendingOperator: true,
        );
      }
    }

    if (operator == "c") {
      if (key == LogicalKeyboardKey.keyC) {
        return result.copyWith(
          changeLine: true,
          mode: VimMode.insert,
          countBuffer: "",
          clearPendingOperator: true,
        );
      }
      if (key == LogicalKeyboardKey.keyW) {
        final targetPos =
            VimMotions.moveWordForward(text, state.cursorPosition);
        return result.copyWith(
          changeToPosition: targetPos,
          mode: VimMode.insert,
          countBuffer: "",
          clearPendingOperator: true,
        );
      }
    }

    if (operator == "y") {
      if (key == LogicalKeyboardKey.keyY) {
        return result.copyWith(
          yankLine: true,
          countBuffer: "",
          clearPendingOperator: true,
        );
      }
    }

    return result.copyWith(
      countBuffer: "",
      clearPendingOperator: true,
    );
  }

  static VimHandlerResult _handleVisualMode(
    LogicalKeyboardKey key,
    String text,
    VimState state, {
    required bool shift,
    required bool ctrl,
  }) {
    final result = VimHandlerResult.fromState(state);

    if (key == LogicalKeyboardKey.escape) {
      return result.copyWith(
        mode: VimMode.normal,
        clearVisualStart: true,
        countBuffer: "",
      );
    }

    if (key == LogicalKeyboardKey.keyH || key == LogicalKeyboardKey.arrowLeft) {
      return result.copyWith(
        cursorPosition: VimMotions.moveLeft(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyL ||
        key == LogicalKeyboardKey.arrowRight) {
      return result.copyWith(
        cursorPosition: VimMotions.moveRight(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyJ || key == LogicalKeyboardKey.arrowDown) {
      return result.copyWith(
        cursorPosition: VimMotions.moveDown(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyK || key == LogicalKeyboardKey.arrowUp) {
      return result.copyWith(
        cursorPosition: VimMotions.moveUp(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyW) {
      return result.copyWith(
        cursorPosition: VimMotions.moveWordForward(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyB) {
      return result.copyWith(
        cursorPosition: VimMotions.moveWordBackward(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyE) {
      return result.copyWith(
        cursorPosition: VimMotions.moveWordEnd(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.keyD) {
      return result.copyWith(
        deleteSelection: true,
        mode: VimMode.normal,
        clearVisualStart: true,
      );
    }

    if (key == LogicalKeyboardKey.keyY) {
      return result.copyWith(
        yankSelection: true,
        mode: VimMode.normal,
        clearVisualStart: true,
      );
    }

    if (key == LogicalKeyboardKey.keyC) {
      return result.copyWith(
        deleteSelection: true,
        mode: VimMode.insert,
        clearVisualStart: true,
      );
    }

    return result;
  }

  static VimHandlerResult _handleInsertMode(
    LogicalKeyboardKey key,
    String text,
    VimState state, {
    required bool shift,
    required bool ctrl,
  }) {
    final result = VimHandlerResult.fromState(state);

    if (key == LogicalKeyboardKey.escape) {
      final newPos = (state.cursorPosition - 1).clamp(0, text.length - 1);
      return result.copyWith(
        mode: VimMode.normal,
        cursorPosition: text.isEmpty ? 0 : newPos,
      );
    }

    if (key == LogicalKeyboardKey.arrowLeft) {
      return result.copyWith(
        cursorPosition: VimMotions.moveLeft(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.arrowRight) {
      final newPos = (state.cursorPosition + 1).clamp(0, text.length);
      return result.copyWith(cursorPosition: newPos);
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      return result.copyWith(
        cursorPosition: VimMotions.moveDown(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      return result.copyWith(
        cursorPosition: VimMotions.moveUp(text, state.cursorPosition),
      );
    }

    if (key == LogicalKeyboardKey.backspace) {
      return result.copyWith(deleteBeforeCursor: true);
    }

    if (key == LogicalKeyboardKey.enter) {
      return result.copyWith(textToInsert: "\n");
    }

    if (key == LogicalKeyboardKey.tab) {
      return result.copyWith(textToInsert: "\t");
    }

    if (key == LogicalKeyboardKey.space) {
      return result.copyWith(textToInsert: " ");
    }

    final char = _keyToChar(key, shift);
    if (char != null) {
      return result.copyWith(textToInsert: char);
    }

    return result;
  }

  static bool _isDigit(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.digit0 ||
        key == LogicalKeyboardKey.digit1 ||
        key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.digit4 ||
        key == LogicalKeyboardKey.digit5 ||
        key == LogicalKeyboardKey.digit6 ||
        key == LogicalKeyboardKey.digit7 ||
        key == LogicalKeyboardKey.digit8 ||
        key == LogicalKeyboardKey.digit9;
  }

  static String? _keyToDigit(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.digit0) return "0";
    if (key == LogicalKeyboardKey.digit1) return "1";
    if (key == LogicalKeyboardKey.digit2) return "2";
    if (key == LogicalKeyboardKey.digit3) return "3";
    if (key == LogicalKeyboardKey.digit4) return "4";
    if (key == LogicalKeyboardKey.digit5) return "5";
    if (key == LogicalKeyboardKey.digit6) return "6";
    if (key == LogicalKeyboardKey.digit7) return "7";
    if (key == LogicalKeyboardKey.digit8) return "8";
    if (key == LogicalKeyboardKey.digit9) return "9";
    return null;
  }

  static String? _keyToChar(LogicalKeyboardKey key, bool shift) {
    final keyLabel = key.keyLabel;
    if (keyLabel.length == 1) {
      final char = keyLabel.toLowerCase();
      if (RegExp("[a-z0-9]").hasMatch(char)) {
        return shift ? char.toUpperCase() : char;
      }
    }
    return null;
  }
}
