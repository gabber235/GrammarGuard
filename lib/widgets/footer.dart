import "package:flutter/material.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/widgets/model_selector.dart";
import "package:grammar_guard/widgets/toggle_option.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class Footer extends ConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffOption = ref.watch(diffOptionProvider);
    final renderingMode = ref.watch(renderingModeProvider);
    final totalTokens = ref.watch(totalTokenCountProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _UsageInfo(
              icon: Icons.token,
              label: "Tokens",
              value: totalTokens.toString(),
            ),
            const SizedBox(width: 16),
            _UsageInfo(
              icon: Icons.attach_money_rounded,
              label: "Cost",
              value: "\$${totalPrice.toStringAsFixed(3)}",
            ),
          ],
        ),
        Row(
          children: [
            ToggleOption(
              icon: Icons.smart_toy,
              label: selectedModel.displayName,
              shortcut: "S",
              onToggle: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const ModelSelector(),
                );
              },
            ),
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

class _UsageInfo extends StatelessWidget {
  const _UsageInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }
}
