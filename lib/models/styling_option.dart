import 'package:flutter/material.dart';

enum StylingOption {
  markdown('Markdown', 'M', Icons.code),
  latex('LaTeX', 'L', Icons.functions);

  final String label;
  final String shortcut;
  final IconData icon;

  const StylingOption(this.label, this.shortcut, this.icon);
}
