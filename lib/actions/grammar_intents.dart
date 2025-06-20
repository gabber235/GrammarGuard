import "package:flutter/material.dart";
import "package:grammar_guard/models/rewrite_intensity.dart";
import "package:grammar_guard/models/styling_option.dart";

class ToggleStylingIntent extends Intent {
  const ToggleStylingIntent(this.option);
  final StylingOption option;
}

class SetIntensityIntent extends Intent {
  const SetIntensityIntent(this.intensity);
  final RewriteIntensity intensity;
}

class SelectOptionIntent extends Intent {
  const SelectOptionIntent(this.index);
  final int index;
}

class ToggleSelectedOptionIntent extends Intent {
  const ToggleSelectedOptionIntent();
}

class HideIntent extends Intent {
  const HideIntent();
}

class ToggleDiffOptionIntent extends Intent {
  const ToggleDiffOptionIntent();
}

class ToggleRenderingIntent extends Intent {
  const ToggleRenderingIntent();
}

enum TextScrollDirection { up, down }

class TextScrollIntent extends Intent {
  const TextScrollIntent(this.direction, {this.amount = 0.1});

  final TextScrollDirection direction;
  final double amount;
}

class ShowModelSelectorIntent extends Intent {
  const ShowModelSelectorIntent();
}

class ShowProviderConfigurationIntent extends Intent {
  const ShowProviderConfigurationIntent();
}
