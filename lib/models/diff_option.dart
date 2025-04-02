import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "diff_option.g.dart";

enum DiffOptions {
  additions(
    showAdditions: true,
    showDeletions: false,
    label: "Additions",
    shortcut: "H",
    icon: Icons.add_circle_outline,
  ),
  both(
    showAdditions: true,
    showDeletions: true,
    label: "Both",
    shortcut: "H",
    icon: Icons.compare_arrows,
  ),
  none(
    showAdditions: false,
    showDeletions: false,
    label: "None",
    shortcut: "H",
    icon: Icons.remove_circle_outline,
  );

  const DiffOptions({
    required this.showAdditions,
    required this.showDeletions,
    required this.label,
    required this.shortcut,
    required this.icon,
  });

  final bool showAdditions;
  final bool showDeletions;
  final String label;
  final String shortcut;
  final IconData icon;

  DiffOptions next() {
    switch (this) {
      case additions:
        return both;
      case both:
        return none;
      case none:
        return additions;
    }
  }
}

@riverpod
class DiffOption extends _$DiffOption {
  @override
  DiffOptions build() {
    return DiffOptions.additions;
  }

  void toggle() {
    state = state.next();
  }
}
