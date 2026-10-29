// The Rail: change map on the left, the text on
// the right, a highlighter that glides to the current change.

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/review/review_spans.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:grammar_guard/ui/word_reveal.dart";

/// The rail column and the gap after it. Every view of the text (writing,
/// streaming, review, preview) starts its text at the same x, so nothing
/// jumps sideways when the review takes over from the stream.
const railWidth = 34.0;
const railGap = 20.0;

/// The rail column with [child] in the text column. [rail] defaults to an
/// empty rail; [WritingPill] while the model writes.
class RailColumn extends StatelessWidget {
  const RailColumn({required this.child, this.rail, super.key});

  final Widget child;
  final Widget? rail;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Loose, so a pill keeps its own size instead of filling the column.
      SizedBox(
        width: railWidth,
        child: Align(alignment: Alignment.topLeft, child: rail),
      ),
      const SizedBox(width: railGap),
      Expanded(child: child),
    ],
  );
}

/// The rail's pill, breathing while the model writes: the same mark that
/// will sit on the first change once the review is ready.
class WritingPill extends HookWidget {
  const WritingPill({super.key});

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final pulse = useAnimationController(duration: const Duration(milliseconds: 900));
    final reduce = context.reduceMotion;
    useEffect(() {
      if (!reduce) pulse.repeat(reverse: true);
      return pulse.stop;
    }, [reduce]);
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 6),
      child: FadeTransition(
        opacity: reduce ? const AlwaysStoppedAnimation(1) : Tween(begin: 0.35, end: 1.0).animate(pulse),
        child: Container(
          width: 14,
          height: 24,
          decoration: BoxDecoration(color: gg.highlighter, borderRadius: BorderRadius.circular(7)),
        ),
      ),
    );
  }
}

/// The text with its changes, from the first written word to the end of
/// the review. While the model writes, the diff grows word by word and the
/// rail's pill breathes where the review will start; when it is done, the
/// same view gains its highlighter and the pill settles on the first change.
/// Nothing is swapped, so nothing jumps.
class ReviewPane extends HookWidget {
  const ReviewPane({
    required this.spans,
    required this.current,
    this.output = "",
    this.writing = false,
    this.scroll,
    this.note,
    super.key,
  });

  final List<ReviewSpan> spans;

  /// The model's text as far as [spans] show it. Words new since the last
  /// build fade in.
  final String output;

  /// The model is still writing.
  final bool writing;

  /// Index of the change n, p, y and x act on. Null when none is left.
  final int? current;
  final ScrollController? scroll;

  /// A short line shown right under the current change (the ? reason).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    // RichText does not inherit the app font; start from the default style.
    final style = DefaultTextStyle.of(context).style
        .merge(TextStyle(fontSize: gg.textSize, height: 1.7, color: gg.ink, letterSpacing: 0.1));
    final (:reveal, :now) = useWordReveal(output, animate: !context.reduceMotion);
    final shown = _shown(spans);
    // Where each span sits in the model's text: removed text takes no room
    // there and fades in with the word after it.
    final children = <TextSpan>[];
    var at = 0;
    for (final (i, span) in spans.indexed) {
      if (span.kind == SpanKind.removed) {
        children.add(_styled(span, gg, [(shown[i], reveal.alpha(at, now))]));
      } else {
        children.add(_styled(span, gg, reveal.runs(shown[i], at, now)));
        at += shown[i].length;
      }
    }
    // Until the first word is complete.
    if (writing && spans.isEmpty)
      children.add(
        TextSpan(
          text: "Writing…",
          style: TextStyle(color: gg.muted),
        ),
      );
    final text = TextSpan(style: style, children: children);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - railWidth - railGap;
        // Laid out once per build to find where each change sits. The same
        // TextSpan is painted below, so the rects line up exactly.
        final painter = TextPainter(text: text, textDirection: TextDirection.ltr)..layout(maxWidth: width);
        final lines = _changeLines(painter, shown);
        final rects = {for (final MapEntry(:key, :value) in lines.entries) key: _bounds(value)};
        final textHeight = painter.height;
        painter.dispose();
        final at = current == null ? null : rects[current];
        // Room under the last line, so a note there is never cut off.
        final height = textHeight + (note == null ? 0 : 56);

        return SingleChildScrollView(
          controller: scroll,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: railWidth,
                height: height,
                child: _Rail(
                  tops: {for (final e in rects.entries) e.key: e.value.top / height},
                  current: current,
                  // While writing, the pill waits where the review will
                  // start (the first change, else the first line), so it
                  // does not travel down with the text and back up after.
                  writingAt: !writing || height == 0 ? null : (rects[0]?.top ?? 0) / height,
                ),
              ),
              const SizedBox(width: railGap),
              SizedBox(
                width: width,
                height: height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _Highlighter(lines: current == null ? null : lines[current], color: gg.highlighter),
                    RichText(text: text),
                    if ((note, at) case (final note?, final at?))
                      Positioned(
                        left: at.left.clamp(0, (width - 380).clamp(0, width)),
                        top: at.bottom + 8,
                        child: _Note(key: ValueKey(note), text: note),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// The text each span shows. A removed word directly followed by its
  /// replacement gets a thin space, so "heyHey" reads as "hey Hey".
  static List<String> _shown(List<ReviewSpan> spans) => [
    for (final (i, span) in spans.indexed)
      if (span.kind == SpanKind.removed && spans.elementAtOrNull(i + 1)?.kind == SpanKind.added)
        "${span.text}\u2009"
      else
        span.text,
  ];

  /// One span in its kind's style, as [runs] of text and opacity.
  TextSpan _styled(ReviewSpan span, GgTheme gg, List<(String, double)> runs) {
    TextStyle style(double alpha) => switch (span.kind) {
      SpanKind.same => TextStyle(color: gg.ink.withValues(alpha: gg.ink.a * alpha)),
      SpanKind.added => TextStyle(color: gg.added.withValues(alpha: alpha)),
      // Dimmer than the new text: what is going away should not compete.
      SpanKind.removed => TextStyle(
        color: gg.removed.withValues(alpha: 0.8 * alpha),
        decoration: TextDecoration.lineThrough,
        decorationColor: gg.removed.withValues(alpha: alpha),
        decorationThickness: 2,
      ),
    };
    return switch (runs) {
      [(final text, final alpha)] => TextSpan(text: text, style: style(alpha)),
      _ => TextSpan(
        children: [for (final (text, alpha) in runs) TextSpan(text: text, style: style(alpha))],
      ),
    };
  }

  /// The lines each change covers, top to bottom: per visual line, the
  /// union of its removed and added text boxes on that line. A change that
  /// wraps from the end of one line to the start of the next is two short
  /// rects, not one box over both full lines.
  Map<int, List<Rect>> _changeLines(TextPainter painter, List<String> shown) {
    final lines = <int, List<Rect>>{};
    var offset = 0;
    for (final (i, span) in spans.indexed) {
      final end = offset + shown[i].length;
      if (span.change case final change?) {
        final rects = lines.putIfAbsent(change, () => []);
        for (final box in painter.getBoxesForSelection(TextSelection(baseOffset: offset, extentOffset: end))) {
          final rect = box.toRect();
          final line = rects.indexWhere((r) => r.top < rect.bottom && rect.top < r.bottom);
          if (line == -1) {
            rects.add(rect);
          } else {
            rects[line] = rects[line].expandToInclude(rect);
          }
        }
      }
      offset = end;
    }
    // A removed line break is an empty box on an otherwise empty line; it
    // has nothing to mark. Keep it only when the change is nothing else.
    return {
      for (final MapEntry(:key, :value) in lines.entries)
        if (value.isNotEmpty)
          key: switch (value.where((r) => r.width > 0).toList()) {
            [] => value,
            final wide => wide..sort((a, b) => a.top.compareTo(b.top)),
          },
    };
  }

  static Rect _bounds(List<Rect> lines) => lines.reduce((a, b) => a.expandToInclude(b));
}

/// Glides from the last change to the new one, then sweeps over its lines
/// from the left, one line after the other, like running a highlighter pen
/// over the words.
class _Highlighter extends StatelessWidget {
  const _Highlighter({required this.lines, required this.color});

  /// The current change's lines, top to bottom.
  final List<Rect>? lines;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final target = lines?.map((line) => line.inflate(3)).toList();
    if (target == null) return const SizedBox.shrink();
    final bounds = ReviewPane._bounds(target);
    // The glide moves the change's bounds; its lines ride along inside them
    // and land exactly on the text when the bounds arrive.
    return TweenAnimationBuilder<Rect?>(
      tween: RectTween(end: bounds),
      duration: context.motion(Motion.slow),
      curve: Motion.glide,
      builder: (context, value, _) => TweenAnimationBuilder<double>(
        key: ValueKey(bounds), // restart the sweep for each new change
        tween: Tween(begin: context.reduceMotion ? 1 : 0, end: 1),
        duration: context.motion(Motion.medium),
        curve: Motion.out,
        builder: (context, sweep, _) => CustomPaint(
          painter: _HighlightPainter(
            lines: [for (final line in target) _within(line, bounds, value!)],
            sweep: sweep,
            color: color.withValues(alpha: 0.32),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }

  /// [line], placed in [to] as it sits in [from].
  static Rect _within(Rect line, Rect from, Rect to) {
    final sx = from.width == 0 ? 1.0 : to.width / from.width;
    final sy = from.height == 0 ? 1.0 : to.height / from.height;
    return Rect.fromLTRB(
      to.left + (line.left - from.left) * sx,
      to.top + (line.top - from.top) * sy,
      to.left + (line.right - from.left) * sx,
      to.top + (line.bottom - from.top) * sy,
    );
  }
}

class _HighlightPainter extends CustomPainter {
  const _HighlightPainter({required this.lines, required this.sweep, required this.color});

  final List<Rect> lines;
  final double sweep;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // The sweep runs over the lines in reading order, as one long stroke.
    var left = sweep * lines.fold(0.0, (total, line) => total + line.width);
    for (final line in lines) {
      if (left <= 0) break;
      final width = left < line.width ? left : line.width;
      final swept = Rect.fromLTWH(line.left, line.top, width, line.height);
      canvas.drawRRect(RRect.fromRectAndRadius(swept, const Radius.circular(5)), paint);
      left -= line.width;
    }
  }

  @override
  bool shouldRepaint(_HighlightPainter old) =>
      !listEquals(old.lines, lines) || old.sweep != sweep || old.color != color;
}

/// One dot per change at its height in the text; the current one is a
/// pill that slides between them. Shows how many changes there are and
/// where you are, without reading. While the model writes, the pill
/// breathes where the review will start.
class _Rail extends HookWidget {
  const _Rail({required this.tops, required this.current, this.writingAt});

  /// Change index to its top, as a fraction of the text height.
  final Map<int, double> tops;
  final int? current;

  /// Where the pill breathes while the model writes, as a fraction of the
  /// text height; null when done.
  final double? writingAt;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final pulse = useAnimationController(duration: const Duration(milliseconds: 900));
    final breathing = writingAt != null && !context.reduceMotion;
    useEffect(() {
      if (breathing) {
        pulse.repeat(reverse: true);
      } else {
        pulse.animateTo(1, duration: context.motion(Motion.fast));
      }
      return null;
    }, [breathing]);
    return LayoutBuilder(
      builder: (context, box) {
        final at = writingAt ?? (current == null ? null : tops[current]);
        return Stack(
          children: [
            Positioned(right: 0, top: 0, bottom: 0, child: Container(width: 1, color: gg.hairline)),
            for (final top in tops.values)
              Positioned(left: 13, top: top * box.maxHeight + 8, child: _dot(gg.pin, 8, 8)),
            if (at != null)
              AnimatedPositioned(
                duration: context.motion(Motion.slow),
                curve: Motion.glide,
                left: 10,
                top: at * box.maxHeight + 2,
                child: FadeTransition(
                  opacity: breathing ? Tween(begin: 0.35, end: 1.0).animate(pulse) : const AlwaysStoppedAnimation(1),
                  child: _dot(gg.highlighter, 14, 24),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _dot(Color color, double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(width / 2)),
  );
}

/// The reason for the current change, pinned under it: a small floating
/// label, so the eye does not leave the word to read why it changed.
class _Note extends StatelessWidget {
  const _Note({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: gg.floating,
        borderRadius: BorderRadius.circular(GgTheme.smallRadius),
        border: Border.all(color: gg.hairline),
        boxShadow: [BoxShadow(color: gg.shadow, blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Why  ",
              style: TextStyle(color: gg.highlighter, fontWeight: FontWeight.w800),
            ),
            TextSpan(text: text),
          ],
        ),
        style: TextStyle(fontSize: 14, color: gg.ink, height: 1.4),
      ),
    ).appear(context);
  }
}
