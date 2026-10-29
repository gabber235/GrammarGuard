import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/review/review_spans.dart";
import "package:grammar_guard/ui/review_pane.dart";
import "package:grammar_guard/ui/theme.dart";

void main() {
  testWidgets("a change that wraps is marked per line, not as one box over both lines", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: GgTheme.dark.toThemeData(Brightness.dark),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 500,
              height: 400,
              child: ReviewPane(
                current: 0,
                spans: [
                  ReviewSpan(text: "${"word " * 10}tail ", kind: SpanKind.same),
                  ReviewSpan(text: ("changed " * 6).trim(), kind: SpanKind.added, change: 0),
                  ReviewSpan(text: " ${"rest " * 12}", kind: SpanKind.same),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final marks = <Rect>[];
    expect(
      find.descendant(of: find.byType(Stack), matching: find.byType(CustomPaint)).first,
      paints..everything((method, args) {
        if (method == #drawRRect) marks.add((args.first as RRect).outerRect);
        return true;
      }),
    );
    final text = tester.getRect(find.byType(RichText)).width;
    expect(marks.length, greaterThan(1));
    final (first, last) = (marks.first, marks.last);
    // The first line is marked from where the change starts, the last up to
    // where it ends; neither covers the unchanged words beside it.
    expect(first.left, greaterThan(text / 2));
    expect(last.left, lessThan(0));
    expect(last.right, lessThan(text * 0.8));
    expect(last.top, greaterThan(first.top));
  });
}
