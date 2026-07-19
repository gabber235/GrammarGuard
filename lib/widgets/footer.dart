import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/hooks/timer.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/generation_stats.dart";
import "package:grammar_guard/widgets/model_selector.dart";
import "package:grammar_guard/widgets/provider_configuration.dart";
import "package:grammar_guard/widgets/toggle_option.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class Footer extends HookConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffOption = ref.watch(diffOptionProvider);
    final renderingMode = ref.watch(renderingModeProvider);
    final totalTokens = ref.watch(totalTokenCountProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final selectedModel = ref.watch(selectedModelProvider);
    final generationStats = ref.watch(generationStatsProvider);
    final now = useState(DateTime.now());

    useTimer(
      const Duration(milliseconds: 500),
      (_) {
        if (generationStats.isActive) {
          now.value = DateTime.now();
        }
      },
      keys: [generationStats.isActive],
    );

    final elapsed = generationStats.elapsedAt(now.value);
    final elapsedText = _formatDuration(elapsed);
    final activeSpeed = generationStats.liveEstimatedTokensPerSecond(elapsed);
    final finalSpeed = generationStats.finalTokensPerSecond;
    final speedText = _formatTokensPerSecond(
      generationStats.isActive ? activeSpeed : (finalSpeed ?? activeSpeed),
      estimated: generationStats.isActive,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _UsageInfo(
              icon: Icons.token,
              value: totalTokens.toString(),
            ),
            const SizedBox(width: 12),
            _UsageInfo(
              icon: Icons.attach_money_rounded,
              value: "\$${totalPrice.toStringAsFixed(3)}",
            ),
            const SizedBox(width: 12),
            _UsageInfo(
              icon: Icons.schedule,
              value: elapsedText,
            ),
            const SizedBox(width: 12),
            Tooltip(
              message: generationStats.loadingTimeTooltipText(),
              child: _UsageInfo(
                icon: Icons.speed,
                value: speedText,
              ),
            ),
          ],
        ),
        Row(
          children: [
            ToggleOption(
              icon: Icons.settings,
              label: "Settings",
              shortcut: "C",
              onToggle: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProviderConfiguration(),
                ),
              ),
            ),
            ToggleOption(
              icon: Icons.smart_toy,
              label: selectedModel.when(
                data: (model) => model?.displayName ?? "Select Model",
                error: (error, stack) => "Error",
                loading: () => "Loading...",
              ),
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
    required this.value,
  });

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
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

String _formatDuration(Duration duration) {
  final seconds = duration.inMilliseconds / 1000;
  if (seconds < 100) {
    return "${seconds.toStringAsFixed(1)}s";
  }

  final minutes = duration.inMinutes;
  final remainingSeconds = duration.inSeconds.remainder(60);
  if (minutes > 0) {
    return "${minutes}m ${remainingSeconds}s";
  }

  return "${duration.inSeconds}s";
}

String _formatTokensPerSecond(double value, {required bool estimated}) {
  final prefix = estimated ? "~" : "";
  if (value <= 0) {
    return "${prefix}0 tok/s";
  }

  if (value < 10) {
    return "$prefix${value.toStringAsFixed(1)} tok/s";
  }

  return "$prefix${value.round()} tok/s";
}
