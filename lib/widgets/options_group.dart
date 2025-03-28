import 'package:flutter/material.dart';
import 'package:grammar_guard/models/rewrite_intensity.dart';
import 'package:grammar_guard/models/styling_option.dart';
import 'package:grammar_guard/state/grammar_state.dart';
import 'package:grammar_guard/widgets/rewrite_intensity_option.dart';
import 'package:grammar_guard/widgets/styling_option.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OptionsGroup extends ConsumerWidget {
  final Set<StylingOption> enabledStyling;
  final RewriteIntensity selectedIntensity;

  const OptionsGroup({
    super.key,
    required this.enabledStyling,
    required this.selectedIntensity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Style:',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(width: 8),
              ...StylingOption.values.map(
                (option) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: StylingOptionWidget(
                    option: option,
                    isEnabled: enabledStyling.contains(option),
                    onToggle:
                        () => ref
                            .read(grammarStateProvider.notifier)
                            .toggleStyling(option),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Intensity:',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(width: 8),
              ...RewriteIntensity.values.map(
                (intensity) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: RewriteIntensityOption(
                    intensity: intensity,
                    isSelected: selectedIntensity == intensity,
                    onSelect:
                        () => ref
                            .read(grammarStateProvider.notifier)
                            .setRewriteIntensity(intensity),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
