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

  test("input the model has not reached never flashes in as removed", () {
    // A changed word last made all the unread input show as removed for that
    // one word. The input the review shows may only grow as words arrive.
    String original(List<ReviewSpan> spans) => [
      for (final s in spans)
        if (s.kind != SpanKind.added) s.text,
    ].join();
    var shown = "";
    for (final word in RegExp(r"\S+\s+").allMatches(output)) {
      final now = original(liveSpans(input, output.substring(0, word.end)));
      expect(now, startsWith(shown), reason: "at \"${output.substring(0, word.end)}\"");
      shown = now;
    }
  });

  test("what is shown stays put as a long text is written", () {
    // About 1,000 words with a few fixes in every paragraph, some dropping
    // words: past where the edits of the whole text once overran the search.
    const sentences = [
      ("i think we should of shipped the release on friday", "I think we should have shipped the release on Friday."),
      ("their going to to review the changes tomorrow", "They're going to review the changes tomorrow."),
      ("the new settings page look really very great to me", "The new settings page looks great to me."),
      (
        "we has to make sure every user can find the export button",
        "We have to make sure every user can find the export button.",
      ),
    ];
    final long = [for (var i = 0; i < 70; i++) "${sentences[i % 4].$1} (note $i)"].join("\n\n");
    final fixed = [for (var i = 0; i < 70; i++) "${sentences[i % 4].$2} (note $i)"].join("\n\n");
    // Each step may change only its last two spans: the newest words, and
    // the change they may still turn out to be part of.
    var before = <ReviewSpan>[];
    for (final word in RegExp(r"\S+\s+").allMatches(fixed)) {
      final now = liveSpans(long, fixed.substring(0, word.end));
      final settled = before.length < 2 ? 0 : before.length - 2;
      expect(now.take(settled), before.take(settled), reason: "at word ending ${word.end}");
      before = now;
    }
    expect(written(before), "$fixed ".replaceFirst(RegExp(r"\S+ $"), ""));
  });

  test("once every word is written it is the finished review", () {
    final live = liveSpans(input, "$output ");
    final done = inlineSpans(EditorDocument.fromDiffs(wordDiff(input, output)));
    expect(written(live), "$output ");
    expect({for (final s in live) s.change}, {for (final s in done) s.change});
  });
}
