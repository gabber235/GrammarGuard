import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "rendering_mode.g.dart";

enum RenderingModeOption {
  markdown("Rendering", "R", Icons.code),
  raw("Raw", "R", Icons.code_off);

  const RenderingModeOption(this.label, this.shortcut, this.icon);

  final String label;
  final String shortcut;
  final IconData icon;

  RenderingModeOption next() {
    switch (this) {
      case markdown:
        return raw;
      case raw:
        return markdown;
    }
  }
}

@riverpod
class RenderingMode extends _$RenderingMode {
  @override
  RenderingModeOption build() {
    return RenderingModeOption.markdown;
  }

  void toggle() {
    state = state.next();
  }
}
