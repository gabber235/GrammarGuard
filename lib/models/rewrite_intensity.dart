import "package:flutter/material.dart";

enum RewriteIntensity {
  fixOnly("Fix Only", "1", Icons.check_circle_outline),
  polish("Polish", "2", Icons.edit_note),
  enhance("Enhance", "3", Icons.auto_awesome),
  rewrite("Rewrite", "4", Icons.refresh);

  const RewriteIntensity(this.label, this.shortcut, this.icon);

  final String label;
  final String shortcut;
  final IconData icon;
}
