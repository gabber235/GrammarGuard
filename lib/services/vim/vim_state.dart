enum VimMode {
  normal,
  insert,
  visual;

  String get displayName {
    switch (this) {
      case VimMode.normal:
        return "NORMAL";
      case VimMode.insert:
        return "INSERT";
      case VimMode.visual:
        return "VISUAL";
    }
  }
}

class VimState {

  VimState({
    this.mode = VimMode.normal,
    this.cursorPosition = 0,
    this.visualStart,
    this.pendingOperator,
    this.countBuffer = "",
  });
  final VimMode mode;
  final int cursorPosition;
  final int? visualStart;
  final String? pendingOperator;
  final String countBuffer;

  bool get isNormalMode => mode == VimMode.normal;
  bool get isInsertMode => mode == VimMode.insert;
  bool get isVisualMode => mode == VimMode.visual;
  bool get hasPendingOperator => pendingOperator != null;

  VimState enterInsertMode() {
    return copyWith(mode: VimMode.insert);
  }

  VimState enterNormalMode() {
    return copyWith(mode: VimMode.normal);
  }

  VimState enterVisualMode() {
    return copyWith(
      mode: VimMode.visual,
      visualStart: cursorPosition,
    );
  }

  VimState exitVisualMode() {
    return VimState(
      mode: VimMode.normal,
      cursorPosition: cursorPosition,
      pendingOperator: pendingOperator,
      countBuffer: countBuffer,
    );
  }

  VimState moveCursor(int position) {
    return copyWith(cursorPosition: position < 0 ? 0 : position);
  }

  (int, int)? getSelectionRange() {
    if (mode != VimMode.visual || visualStart == null) {
      return null;
    }
    final start = visualStart! < cursorPosition ? visualStart! : cursorPosition;
    final end = visualStart! < cursorPosition ? cursorPosition : visualStart!;
    return (start, end);
  }

  VimState setPendingOperator(String operator) {
    return copyWith(pendingOperator: operator);
  }

  VimState clearPendingOperator() {
    return VimState(
      mode: mode,
      cursorPosition: cursorPosition,
      visualStart: visualStart,
      countBuffer: countBuffer,
    );
  }

  VimState appendToCountBuffer(String digit) {
    return copyWith(countBuffer: countBuffer + digit);
  }

  VimState clearCountBuffer() {
    return copyWith(countBuffer: "");
  }

  int getCount() {
    if (countBuffer.isEmpty) return 1;
    return int.tryParse(countBuffer) ?? 1;
  }

  VimState copyWith({
    VimMode? mode,
    int? cursorPosition,
    int? visualStart,
    String? pendingOperator,
    String? countBuffer,
  }) {
    return VimState(
      mode: mode ?? this.mode,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      visualStart: visualStart ?? this.visualStart,
      pendingOperator: pendingOperator ?? this.pendingOperator,
      countBuffer: countBuffer ?? this.countBuffer,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VimState &&
        other.mode == mode &&
        other.cursorPosition == cursorPosition &&
        other.visualStart == visualStart &&
        other.pendingOperator == pendingOperator &&
        other.countBuffer == countBuffer;
  }

  @override
  int get hashCode {
    return Object.hash(
      mode,
      cursorPosition,
      visualStart,
      pendingOperator,
      countBuffer,
    );
  }

  @override
  String toString() {
    return "VimState(mode: $mode, cursor: $cursorPosition, visualStart: $visualStart, pending: $pendingOperator, count: $countBuffer)";
  }
}
