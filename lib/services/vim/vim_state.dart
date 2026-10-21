import "package:freezed_annotation/freezed_annotation.dart";

part "vim_state.freezed.dart";

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

/// The editor's Vim mode, cursor and pending input.
@freezed
abstract class VimState with _$VimState {
  const VimState._();

  const factory VimState({
    @Default(VimMode.normal) VimMode mode,
    @Default(0) int cursorPosition,
    int? visualStart,
    String? pendingOperator,
    @Default("") String countBuffer,
  }) = _VimState;

  bool get isNormalMode => mode == VimMode.normal;
  bool get isInsertMode => mode == VimMode.insert;
  bool get isVisualMode => mode == VimMode.visual;
  bool get hasPendingOperator => pendingOperator != null;

  VimState enterInsertMode() => copyWith(mode: VimMode.insert);
  VimState enterNormalMode() => copyWith(mode: VimMode.normal);
  VimState enterVisualMode() => copyWith(mode: VimMode.visual, visualStart: cursorPosition);
  VimState exitVisualMode() => copyWith(mode: VimMode.normal, visualStart: null);
  VimState moveCursor(int position) => copyWith(cursorPosition: position < 0 ? 0 : position);

  (int, int)? getSelectionRange() {
    final start = visualStart;
    if (mode != VimMode.visual || start == null) return null;
    return start < cursorPosition ? (start, cursorPosition) : (cursorPosition, start);
  }

  VimState setPendingOperator(String operator) => copyWith(pendingOperator: operator);
  VimState clearPendingOperator() => copyWith(pendingOperator: null);
  VimState appendToCountBuffer(String digit) => copyWith(countBuffer: countBuffer + digit);
  VimState clearCountBuffer() => copyWith(countBuffer: "");

  int getCount() => countBuffer.isEmpty ? 1 : int.tryParse(countBuffer) ?? 1;
}
