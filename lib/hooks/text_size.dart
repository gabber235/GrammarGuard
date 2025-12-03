import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// Returns the size of the text with the given [style] in the given [context].
Size useTextSize(
  BuildContext context,
  String text, {
  TextStyle? style,
  int? maxLines = 1,
  double minWidth = 0,
  double maxWidth = double.infinity,
}) {
  return useMemoized(
    () {
      final defaultTextStyle = DefaultTextStyle.of(context).style;

      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: defaultTextStyle.merge(style),
        ),
        maxLines: maxLines,
        textScaler: MediaQuery.of(context).textScaler,
        textDirection: TextDirection.ltr,
      )..layout(minWidth: minWidth, maxWidth: maxWidth);

      return textPainter.size;
    },
    [text, style, maxLines, minWidth, maxWidth],
  );
}
