import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ToggleOption extends ConsumerWidget {
  const ToggleOption({
    required this.icon,
    required this.label,
    required this.shortcut,
    required this.onToggle,
    super.key,
  });

  final IconData icon;
  final String label;
  final String shortcut;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(width: 4),
              Text(
                "($shortcut)",
                style: TextStyle(fontSize: 14, color: Colors.white24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
