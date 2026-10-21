class VimMotions {
  VimMotions._();

  static int moveLeft(String text, int position) {
    if (position <= 0) return 0;
    return position - 1;
  }

  static int moveRight(String text, int position) {
    if (position >= text.length - 1) return text.length - 1;
    return position + 1;
  }

  static int moveUp(String text, int position) {
    final currentLine = getLineNumber(text, position);
    if (currentLine == 0) return position;

    final currentColumn = getColumnNumber(text, position);
    final prevLineStart = getLineStartPosition(text, currentLine - 1);
    final prevLineLength = getLineLength(text, currentLine - 1);

    final targetColumn = currentColumn.clamp(0, prevLineLength - 1);
    return prevLineStart + (prevLineLength > 0 ? targetColumn : 0);
  }

  static int moveDown(String text, int position) {
    final currentLine = getLineNumber(text, position);
    final lineCount = getLineCount(text);
    if (currentLine >= lineCount - 1) return position;

    final currentColumn = getColumnNumber(text, position);
    final nextLineStart = getLineStartPosition(text, currentLine + 1);
    final nextLineLength = getLineLength(text, currentLine + 1);

    final targetColumn = currentColumn.clamp(0, nextLineLength - 1);
    return nextLineStart + (nextLineLength > 0 ? targetColumn : 0);
  }

  static int moveWordForward(String text, int position) {
    if (position >= text.length - 1) return text.length - 1;

    var pos = position;

    if (pos < text.length && _isWordChar(text[pos])) {
      while (pos < text.length && _isWordChar(text[pos])) {
        pos++;
      }
    } else if (pos < text.length && _isPunctuation(text[pos])) {
      while (pos < text.length && _isPunctuation(text[pos])) {
        pos++;
      }
    }

    while (pos < text.length && _isWhitespace(text[pos])) {
      pos++;
    }

    if (pos >= text.length) return text.length - 1;
    return pos;
  }

  static int moveWordBackward(String text, int position) {
    if (position <= 0) return 0;

    var pos = position;

    while (pos > 0 && !_isWordChar(text[pos - 1])) {
      pos--;
    }

    while (pos > 0 && _isWordChar(text[pos - 1])) {
      pos--;
    }

    return pos;
  }

  static int moveWordEnd(String text, int position) {
    if (position >= text.length - 1) return text.length - 1;

    var pos = position;

    if (pos < text.length - 1 && _isWordChar(text[pos])) {
      pos++;
    }

    while (pos < text.length && !_isWordChar(text[pos])) {
      pos++;
    }

    while (pos < text.length - 1 && _isWordChar(text[pos + 1])) {
      pos++;
    }

    return pos.clamp(0, text.length - 1);
  }

  static int moveToLineStart(String text, int position) {
    final currentLine = getLineNumber(text, position);
    return getLineStartPosition(text, currentLine);
  }

  static int moveToLineEnd(String text, int position) {
    final currentLine = getLineNumber(text, position);
    final lineEnd = getLineEndPosition(text, currentLine);
    return (lineEnd - 1).clamp(0, text.length - 1);
  }

  static int moveToDocumentStart(String text, int position) {
    return 0;
  }

  static int moveToDocumentEnd(String text, int position) {
    return text.isEmpty ? 0 : text.length - 1;
  }

  static int moveToLine(String text, int lineNumber) {
    final lineCount = getLineCount(text);
    final targetLine = lineNumber.clamp(0, lineCount - 1);
    return getLineStartPosition(text, targetLine);
  }

  static int getLineNumber(String text, int position) {
    var line = 0;
    for (var i = 0; i < position && i < text.length; i++) {
      if (text[i] == "\n") {
        line++;
      }
    }
    return line;
  }

  static int getColumnNumber(String text, int position) {
    var column = 0;
    for (var i = position - 1; i >= 0; i--) {
      if (text[i] == "\n") {
        break;
      }
      column++;
    }
    return column;
  }

  static int getLineStartPosition(String text, int lineNumber) {
    if (lineNumber == 0) return 0;

    var currentLine = 0;
    for (var i = 0; i < text.length; i++) {
      if (text[i] == "\n") {
        currentLine++;
        if (currentLine == lineNumber) {
          return i + 1;
        }
      }
    }
    return text.length;
  }

  static int getLineEndPosition(String text, int lineNumber) {
    final lineStart = getLineStartPosition(text, lineNumber);
    for (var i = lineStart; i < text.length; i++) {
      if (text[i] == "\n") {
        return i;
      }
    }
    return text.length;
  }

  static int getLineLength(String text, int lineNumber) {
    final start = getLineStartPosition(text, lineNumber);
    final end = getLineEndPosition(text, lineNumber);
    return end - start;
  }

  static int getLineCount(String text) {
    if (text.isEmpty) return 1;
    var count = 1;
    for (var i = 0; i < text.length; i++) {
      if (text[i] == "\n") {
        count++;
      }
    }
    return count;
  }

  static bool _isWordChar(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122) || (code >= 48 && code <= 57) || code == 95;
  }

  static bool _isWhitespace(String char) {
    if (char.isEmpty) return false;
    return char == " " || char == "\t" || char == "\n" || char == "\r";
  }

  static bool _isPunctuation(String char) {
    if (char.isEmpty) return false;
    return !_isWordChar(char) && !_isWhitespace(char);
  }
}
