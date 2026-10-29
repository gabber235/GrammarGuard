// Replaces text_display.dart (611 lines)
import "package:animations/animations.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:grammar_guard/app/setup_line.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/explain.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/review/review_spans.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/review_pane.dart";
import "package:grammar_guard/ui/streaming_text.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "result_view.g.dart";

/// V toggles the rendered preview of the final text.
@riverpod
class Preview extends _$Preview {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

/// ? toggles the reason under the current change.
@riverpod
class ShowReason extends _$ShowReason {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

class ResultView extends ConsumerWidget {
  const ResultView({required this.view, required this.preview, required this.scroll, super.key});

  final DiffView view;

  /// V: the final text rendered as Markdown, instead of the diff.
  final bool preview;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final run = ref.watch(currentRunProvider);
    final gg = context.gg;
    final primary = defaultTargetPlatform == TargetPlatform.macOS ? "Cmd" : "Ctrl";

    final body = switch ((session.input, run?.value)) {
      // Notices ("Copied", "Cancelled") appear as a toast; the empty view
      // keeps its own hint so nothing is said twice.
      (null, _) => const _Empty(),
      (_, null) when session.cancelled => const _Status(
        message: "Cancelled.",
        hints: [
          KeyHint(["R"], "try again"),
        ],
      ),
      (_, null) => _Status(
        message: "No model is set up yet.",
        hints: [
          KeyHint([primary, ","], "open Settings"),
        ],
      ),
      // Writing, streaming and the finished review are one view: the
      // diff grows as the model writes, then gains its highlighter.
      (_, Waiting()) => _ReviewText(scroll: scroll, writing: ""),
      (_, Streaming(:final text, :final thinking)) when text.isEmpty && thinking.isNotEmpty => RailColumn(
        rail: const WritingPill(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const SectionLabel("Thinking"),
              StreamingText(text: thinking, thinking: true),
            ],
          ),
        ),
      ),
      (_, Streaming(:final text)) => _ReviewText(scroll: scroll, writing: text),
      (_, Failed(:final message)) => _Status(
        message: message,
        failed: true,
        hints: const [
          KeyHint(["R"], "try again"),
        ],
      ),
      (_, Done()) when preview => RailColumn(
        child: SingleChildScrollView(
          child: GptMarkdown(
            ref.watch(reviewProvider)?.finalText ?? "",
            style: TextStyle(fontSize: gg.textSize, height: 1.6, color: gg.ink),
          ),
        ),
      ),
      (_, Done()) => _ReviewText(scroll: scroll),
    };

    // Between hint, thinking, review, preview and side by side: a small
    // lift. Writing and the review are the same view, so that one stays.
    final switcher = PageTransitionSwitcher(
      duration: context.motion(Motion.lift),
      layoutBuilder: (entries) => Stack(fit: StackFit.expand, children: entries),
      transitionBuilder: (child, animation, secondary) =>
          LiftTransition(animation: animation, secondaryAnimation: secondary, lift: Lift.sideways, child: child),
      child: view == DiffView.sideBySide && run?.value is Done
          ? const _SideBySide()
          : KeyedSubtree(key: ValueKey(body.runtimeType), child: body),
    );
    if (session.input == null) return switcher;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const RailColumn(child: SetupLine()),
        const SizedBox(height: 14),
        Expanded(child: switcher),
      ],
    );
  }
}

/// The review, from the first word written to the end. Always the same
/// [ReviewPane], so its rail, highlighter and reveal carry over from
/// writing to reviewing.
class _ReviewText extends ConsumerWidget {
  const _ReviewText({required this.scroll, this.writing});

  final ScrollController scroll;

  /// The model's text so far while it writes; null once it is done.
  final String? writing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (writing case final written?) {
      final input = ref.watch(sessionProvider.select((s) => s.input?.text)) ?? "";
      return ReviewPane(
        spans: liveSpans(input, written),
        current: null,
        output: completeWords(written),
        writing: true,
        scroll: scroll,
      );
    }
    final review = ref.watch(reviewProvider);
    final run = ref.watch(currentRunProvider)?.value;
    if (review == null || run is! Done) return const SizedBox.shrink();
    final document = review.document;
    final current = document.getChangeAtPosition(review.vimState.cursorPosition);
    return ReviewPane(
      spans: inlineSpans(document),
      current: current,
      output: run.text,
      scroll: scroll,
      // elementAtOrNull throws on a negative index, so no current change
      // must not become -1.
      note: _reason(ref, current == null ? null : document.pendingChanges.elementAtOrNull(current)),
    );
  }

  String? _reason(WidgetRef ref, PendingChange? change) {
    final request = ref.watch(runRequestProvider);
    if (change == null || request == null || !ref.watch(showReasonProvider)) return null;
    return switch (ref.watch(explanationsProvider(request))) {
      AsyncData(:final value) => value[ChangeKey.of(change)] ?? "No reason given.",
      AsyncError() => "Could not get a reason.",
      _ => "Asking the model…",
    };
  }
}

class _SideBySide extends ConsumerWidget {
  const _SideBySide();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final review = ref.watch(reviewProvider);
    if (review == null) return const SizedBox.shrink();
    final gg = context.gg;
    final (before, after) = sideBySideSpans(review.document);
    Widget column(String label, List<ReviewSpan> spans) => Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(label),
            Text.rich(
              TextSpan(children: [for (final span in spans) spanFor(context, span)]),
              style: TextStyle(fontSize: gg.textSize * 0.9, height: 1.7, color: gg.ink),
            ),
          ],
        ),
      ),
    );
    return RailColumn(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          column("Original", before),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 1,
              height: double.infinity,
              child: ColoredBox(color: gg.hairline),
            ),
          ),
          column("Result", after),
        ],
      ),
    );
  }
}

/// Side by side uses the same colors as the Rail, from GgTheme.
TextSpan spanFor(BuildContext context, ReviewSpan span) {
  final gg = context.gg;
  return TextSpan(
    text: span.text,
    style: switch (span.kind) {
      SpanKind.same => null,
      SpanKind.added => TextStyle(color: gg.added),
      SpanKind.removed => TextStyle(
        color: gg.removed,
        decoration: TextDecoration.lineThrough,
        decorationColor: gg.removed,
      ),
    },
  );
}

/// Nothing captured yet: the two ways in, drawn as the keys to press.
class _Empty extends ConsumerWidget {
  const _Empty();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final mac = defaultTargetPlatform == TargetPlatform.macOS;
    final hotkey = ref.watch(hotkeySettingProvider).value;
    final popup = ref.watch(isPopupProvider);
    final quiet = TextStyle(fontSize: 15, color: gg.muted);
    Widget keys(List<String> labels) =>
        Wrap(spacing: 6, children: [for (final label in labels) KeyCap(label, size: 18)]);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (popup && hotkey != null) ...[
            Text("Select text in any app, then press", style: quiet),
            const SizedBox(height: 12),
            keys(hotkeyLabels(hotkey, mac: mac)),
            const SizedBox(height: 28),
            Text("or copy it and press", style: quiet),
          ] else
            Text("Copy some text, then press", style: quiet),
          const SizedBox(height: 12),
          keys([if (mac) "Cmd" else "Ctrl", "V"]),
        ],
      ),
    );
  }
}

/// A run that is not there: cancelled, failed, or no model. One line in
/// the text column and the key that moves on.
class _Status extends StatelessWidget {
  const _Status({required this.message, required this.hints, this.failed = false});

  final String message;
  final List<KeyHint> hints;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return RailColumn(
      rail: failed
          ? Padding(
              padding: const EdgeInsets.only(left: 10, top: 6),
              child: Container(
                width: 14,
                height: 24,
                decoration: BoxDecoration(color: gg.removed, borderRadius: BorderRadius.circular(7)),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              message,
              style: TextStyle(fontSize: gg.textSize, height: 1.6, color: gg.ink),
            ),
          ),
          const SizedBox(height: 14),
          KeyHints(hints),
        ],
      ),
    );
  }
}
