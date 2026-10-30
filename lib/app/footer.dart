import "package:animations/animations.dart";
import "package:clock/clock.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/hooks/timer.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// What this run cost, how long it took, and the keys that work right now: the review's, the bar's, the
/// comparison's or the assistant's.
class Footer extends HookConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final totals = ref.watch(usageTotalsProvider).value;
    final run = ref.watch(currentRunProvider)?.value;
    final comparing = ref.watch(sessionProvider.select((s) => s.compare != null));
    final bar = ref.watch(sessionProvider.select((s) => s.bar?.mode));
    final session = ref.read(sessionActionsProvider);
    final assistant = ref.watch(assistantProvider.select((a) => (open: a.open, proposal: a.proposal.isNotEmpty)));
    // Ticks redraw the running time; the time itself is read now, so a run
    // that starts after a quiet while does not count from the last tick.
    final ticks = useState(0);
    final active = run?.isActive ?? false;
    useTimer(const Duration(milliseconds: 500), (_) {
      if (active) ticks.value++;
    }, keys: [active]);

    final timing = switch (run) {
      Done(:final took) => _duration(took),
      Waiting(:final startedAt) || Streaming(:final startedAt) => _duration(clock.now().difference(startedAt)),
      _ => "",
    };
    final speed = switch (run) {
      Done(:final tokensPerSecond) => "${tokensPerSecond.round()} tokens per second",
      _ => "",
    };
    // This run first: the question users ask is "what did that cost?"
    final cost = switch (run) {
      Done(cost: final c?) => costLabel(c),
      Done() => "price unknown",
      _ => "",
    };
    final hints = switch ((assistant, bar, comparing, run)) {
      ((open: true, proposal: true), _, _, _) => const [
        KeyHint(["n", "p"], "step"),
        KeyHint(["y", "x"], "keep, drop"),
        KeyHint(["Enter"], "apply"),
        KeyHint(["Tab"], "reply"),
      ],
      ((open: true, proposal: false), _, _, _) => const [
        KeyHint(["Enter"], "send"),
        KeyHint(["Esc"], "back to the text"),
      ],
      (_, BarMode.compare, _, _) => [
        const KeyHint(["Enter"], "compare"),
        KeyHint(const ["Esc"], "back", onTap: session.closeBar),
      ],
      (_, BarMode.act, _, _) => [
        const KeyHint(["Enter"], "for now"),
        const KeyHint(["Shift", "Enter"], "for this app"),
        KeyHint([primaryKey, "Enter"], "always"),
        const KeyHint(["Tab"], "ask"),
        KeyHint(const ["Esc"], "back", onTap: session.closeBar),
      ],
      (_, _, true, _) => const [
        KeyHint(["Left"], "keep left"),
        KeyHint(["Right"], "keep right"),
        KeyHint(["Esc"], "back"),
      ],
      (_, _, _, Done()) => const [
        KeyHint(["n", "p"], "next"),
        KeyHint(["y", "x"], "keep, undo"),
        KeyHint(["?"], "why"),
        KeyHint(["Enter"], "paste back"),
      ],
      _ => const <KeyHint>[],
    };
    final quiet = TextStyle(fontSize: 13, color: gg.muted);

    return DefaultTextStyle.merge(
      style: quiet,
      // The keys keep their size; the left side gives way first (the setup
      // summary ellipsizes), and only on a narrow window do the keys shrink.
      child: LayoutBuilder(
        builder: (context, box) => Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  // The model and the setup sit in the line above the text.
                  if (cost.isNotEmpty)
                    Flexible(
                      flex: 2,
                      child: Tooltip(
                        message: "${totals?.tokens ?? 0} tokens, ${costLabel(totals?.cost ?? 0)} in total",
                        child: Text(cost, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  if (timing.isNotEmpty) ...[
                    if (cost.isNotEmpty) const SizedBox(width: 14),
                    Flexible(
                      child: Tooltip(
                        message: speed,
                        child: Text(timing, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hints.isNotEmpty) ...[
              const SizedBox(width: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: box.maxWidth * 0.62),
                // The keys change with the view, in the same motion.
                child: PageTransitionSwitcher(
                  duration: context.motion(Motion.lift),
                  layoutBuilder: (entries) => Stack(alignment: Alignment.centerRight, children: entries),
                  transitionBuilder: (child, animation, secondary) => LiftTransition(
                    animation: animation,
                    secondaryAnimation: secondary,
                    lift: Lift.nudge,
                    child: child,
                  ),
                  child: FittedBox(
                    key: ValueKey(hints.map((h) => "${h.keys} ${h.what}").join(",")),
                    fit: BoxFit.scaleDown,
                    child: KeyHints(hints),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Money the way people say it: "free", "under 1 cent", "3 cents", "$1.20".
String costLabel(double dollars) => switch (dollars) {
  0 => "free",
  < 0.01 => "under 1 cent",
  < 0.015 => "1 cent",
  < 1 => "${(dollars * 100).round()} cents",
  _ => "\$${dollars.toStringAsFixed(2)}",
};

String _duration(Duration duration) {
  final seconds = duration.inMilliseconds / 1000;
  return seconds < 100
      ? "${seconds.toStringAsFixed(1)}s"
      : "${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s";
}
