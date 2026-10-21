import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/review/review_spans.dart";
import "package:grammar_guard/review/word_diff.dart";

void main() {
  const input = "hey team, i think we should of shipped this friday but the tests wasnt ready";
  const output = "Hey team, I think we should have shipped this Friday, but the tests weren't ready.";

  String written(List<ReviewSpan> spans) => [
    for (final s in spans)
      if (s.kind != SpanKind.removed) s.text,
  ].join();

  test("the word being written is held back", () {
    expect(written(liveSpans(input, "Hey team, I thi")), "Hey team, I ");
    expect(liveSpans(input, "Hey"), isEmpty);
  });

  test("input the model has not reached yet is not shown as removed", () {
    for (var end = 1; end <= output.length; end++) {
      final spans = liveSpans(input, output.substring(0, end));
      if (spans.isEmpty) continue;
      expect(spans.last.kind, isNot(SpanKind.removed), reason: "at \"${output.substring(0, end)}\"");
    }
  });

  test("once every word is written it is the finished review", () {
    final live = liveSpans(input, "$output ");
    final done = inlineSpans(EditorDocument.fromDiffs(wordDiff(input, output)));
    expect(written(live), "$output ");
    expect({for (final s in live) s.change}, {for (final s in done) s.change});
  });
}
