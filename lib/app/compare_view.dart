import "package:flutter/material.dart";
import "package:grammar_guard/app/footer.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/streaming_text.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Two models, same prompt. Left or right arrow keeps one and goes on to
/// review it. Both runs are in the run cache, so picking costs nothing.
class CompareView extends ConsumerWidget {
  const CompareView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final first = ref.watch(runRequestProvider);
    final second = ref.watch(compareRequestProvider);

    final gg = context.gg;
    Widget column(RunRequest? request, String key) {
      final run = request == null ? null : ref.watch(runProvider(request)).value;
      final meta = [
        if (run case Done(:final cost?)) costLabel(cost),
        if (run case Done(:final took)) "${(took.inMilliseconds / 1000).toStringAsFixed(1)}s",
      ].join(" · ");
      return Expanded(
        child: Panel(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KeyCap(key),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      request?.model.label ?? "",
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(meta, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: switch (run) {
                    Streaming(:final text) => StreamingText(text: text),
                    Done(:final text) => SelectableText(
                      text,
                      style: TextStyle(fontSize: gg.textSize * 0.9, height: 1.7, color: gg.ink),
                    ),
                    Failed(:final message) => Text(message, style: TextStyle(color: gg.removed)),
                    _ => Text(
                      "Writing…",
                      style: TextStyle(fontSize: gg.textSize * 0.9, color: gg.muted),
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // The arrow keys live in RewriteScreen's key table.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [column(first, "Left"), const SizedBox(width: 12), column(second, "Right")],
    );
  }
}
