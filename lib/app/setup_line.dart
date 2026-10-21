import "package:flutter/material.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// What this rewrite uses, in one quiet line above the text, grouped by why
/// it is on: "Discord profile  Casual, Discord markdown   Default  Polish".
/// The model ends the line. Clicking it opens the bar (Space), which lists
/// the same things and changes them.
class SetupLine extends ConsumerWidget {
  const SetupLine({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolved = ref.watch(resolvedProvider);
    final model = ref.watch(runRequestProvider)?.model;
    if (resolved == null) return const SizedBox.shrink();
    final gg = context.gg;

    // Profiles first (in file order), then picks for now, then defaults.
    final groups = <Origin, List<String>>{};
    for (final active in resolved.active) {
      groups.putIfAbsent(active.origin, () => []).add(active.instruction.name);
    }
    if (resolved.words.isNotEmpty) groups.putIfAbsent(const Origin.you(), () => []).add("“${resolved.words}”");
    int rank(Origin origin) => switch (origin) {
      FromProfile() => 0,
      FromYou() => 1,
      FromDefaults() => 2,
    };
    final ordered = groups.entries.toList()..sort((a, b) => rank(a.key).compareTo(rank(b.key)));

    final names = TextStyle(color: gg.ink.withValues(alpha: 0.85));
    TextSpan label(String text, Color color) => TextSpan(
      text: "$text  ",
      style: TextStyle(color: color, fontWeight: FontWeight.w700),
    );
    const gap = TextSpan(text: "      ");

    return Tooltip(
      message: "Space to change",
      waitDuration: const Duration(milliseconds: 600),
      child: InkWell(
        onTap: ref.read(sessionActionsProvider).openBar,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text.rich(
            TextSpan(
              children: [
                for (final (i, MapEntry(key: origin, value: list)) in ordered.indexed) ...[
                  if (i > 0) gap,
                  switch (origin) {
                    FromProfile(:final name) => label("$name profile", gg.profile),
                    FromYou() => label("For now", gg.you),
                    FromDefaults() => label("Default", gg.muted),
                  },
                  TextSpan(text: list.join(", "), style: names),
                ],
                if (ordered.isEmpty)
                  TextSpan(
                    text: "No instructions",
                    style: TextStyle(color: gg.muted),
                  ),
                if (model != null) ...[
                  gap,
                  TextSpan(
                    text: model.label,
                    style: TextStyle(color: gg.model, fontWeight: FontWeight.w700),
                  ),
                  if (resolved.model?.origin case FromYou())
                    TextSpan(
                      text: "  for now",
                      style: TextStyle(color: gg.you),
                    ),
                ],
              ],
            ),
            style: const TextStyle(fontSize: 14, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
