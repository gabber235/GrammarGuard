import "package:flutter/material.dart";

enum StylingOption {
  markdown("Markdown", "M", Icons.code),
  latex("LaTeX", "L", Icons.functions);

  const StylingOption(this.label, this.shortcut, this.icon);

  final String label;
  final String shortcut;
  final IconData icon;
}
