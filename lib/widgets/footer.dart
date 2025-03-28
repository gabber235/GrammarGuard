import "package:flutter/material.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/widgets/toggle_option.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class Footer extends ConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffOption = ref.watch(diffOptionProvider);
    final renderingMode = ref.watch(renderingModeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Use M/L to toggle Markdown/LaTeX, 1-4 for intensity, ESC to hide",
          style: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        Row(
          children: [
            ToggleOption(
              icon: diffOption.icon,
              label: diffOption.label,
              shortcut: diffOption.shortcut,
              onToggle: () => ref.read(diffOptionProvider.notifier).toggle(),
            ),
            ToggleOption(
              icon: renderingMode.icon,
              label: renderingMode.label,
              shortcut: renderingMode.shortcut,
              onToggle: () => ref.read(renderingModeProvider.notifier).toggle(),
            ),
          ],
        ),
      ],
    );
  }
}
