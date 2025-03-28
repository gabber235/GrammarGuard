import "package:flutter/material.dart";
import "package:grammar_guard/models/styling_option.dart";

class StylingOptionWidget extends StatelessWidget {
  const StylingOptionWidget({
    required this.option,
    required this.isEnabled,
    required this.onToggle,
    super.key,
  });
  final StylingOption option;
  final bool isEnabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.linearToEaseOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)
                  : Colors.transparent,
          border: Border.all(
            color:
                isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              option.icon,
              size: 16,
              color: isEnabled ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 14,
                color: isEnabled ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "(${option.shortcut})",
              style: TextStyle(
                fontSize: 14,
                color: isEnabled ? Colors.white38 : Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
