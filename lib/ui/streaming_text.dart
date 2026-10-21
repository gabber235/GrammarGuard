import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:grammar_guard/ui/word_reveal.dart";

/// Text that grows while the model writes, each new word fading in on its
/// own (see [WordReveal]). Used for the model's thinking; the answer itself
/// streams into the review (ReviewPane), already as a diff.
class StreamingText extends HookWidget {
  const StreamingText({required this.text, this.thinking = false, super.key});

  final String text;

  /// Thinking text is shown smaller and muted until the answer starts.
  final bool thinking;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final (:reveal, :now) = useWordReveal(text, animate: !context.reduceMotion);
    // RichText does not inherit the app font; start from the default style.
    final style = DefaultTextStyle.of(context).style.merge(
      thinking
          ? TextStyle(fontSize: gg.textSize * 0.8, color: gg.muted, height: 1.6)
          : TextStyle(fontSize: gg.textSize, color: gg.ink, height: 1.7),
    );
    return RichText(
      text: TextSpan(
        style: style,
        children: [
          for (final (run, alpha) in reveal.runs(text, 0, now))
            TextSpan(
              text: run,
              style: alpha == 1 ? null : TextStyle(color: style.color!.withValues(alpha: style.color!.a * alpha)),
            ),
        ],
      ),
    );
  }
}
