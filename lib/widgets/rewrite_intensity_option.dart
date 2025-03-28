import 'package:flutter/material.dart';
import 'package:grammar_guard/models/rewrite_intensity.dart';

class RewriteIntensityOption extends StatelessWidget {
  final RewriteIntensity intensity;
  final bool isSelected;
  final VoidCallback onSelect;

  const RewriteIntensityOption({
    super.key,
    required this.intensity,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.linearToEaseOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(
                    context,
                  ).colorScheme.tertiary.withValues(alpha: 0.4)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.white54,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              intensity.icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 4),
            Text(
              intensity.label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${intensity.shortcut})',
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white38 : Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
