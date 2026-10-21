import "package:diff_match_patch/diff_match_patch.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/word_diff.dart";

part "review_spans.freezed.dart";

enum SpanKind { same, added, removed }

/// One run of text in the review view. [change] links it to its change for
/// the highlighter, the rail and the reason.
@freezed
abstract class ReviewSpan with _$ReviewSpan {
  const factory ReviewSpan({required String text, required SpanKind kind, int? change}) = _ReviewSpan;
}

enum DiffView { inline, sideBySide }

/// Pure views of one document. Replaces the six diff providers and the
/// `<insert>` and `<delete>` markdown tags.
List<ReviewSpan> inlineSpans(EditorDocument document) => [
  for (final segment in document.segments)
    ...switch (segment) {
      TextSegment(:final text) => [ReviewSpan(text: text, kind: SpanKind.same)],
      ChangeSegment(:final changeIndex) => _changeSpans(document, changeIndex),
    },
];

/// The review of a result that is still being written: [input] against
/// the [written] part, numbered like the finished review will be, so the
/// view does not change shape when writing ends. The word being written is
/// held back until it is complete, and the input the model has not reached
/// yet is left out instead of shown as removed.
List<ReviewSpan> liveSpans(String input, String written) {
  final complete = completeWords(written);
  if (complete.isEmpty) return const [];
  final diffs = wordDiff(input, complete);
  while (diffs.isNotEmpty && diffs.last.operation == DIFF_DELETE) {
    diffs.removeLast();
  }
  return inlineSpans(EditorDocument.fromDiffs(diffs));
}

/// [written] up to its last whitespace: the words the model has finished.
String completeWords(String written) => written.substring(0, written.lastIndexOf(RegExp(r"\s")) + 1);

/// Left column: the original. Right column: the result.
(List<ReviewSpan>, List<ReviewSpan>) sideBySideSpans(EditorDocument document) {
  final spans = inlineSpans(document);
  return (
    [
      for (final s in spans)
        if (s.kind != SpanKind.added) s,
    ],
    [
      for (final s in spans)
        if (s.kind != SpanKind.removed) s,
    ],
  );
}

Iterable<ReviewSpan> _changeSpans(EditorDocument document, int index) sync* {
  final change = document.pendingChanges[index];
  switch (change.status) {
    case ChangeStatus.pending:
      if (change.originalText.isNotEmpty) {
        yield ReviewSpan(text: change.originalText, kind: SpanKind.removed, change: index);
      }
      if (change.newText.isNotEmpty) {
        yield ReviewSpan(text: change.newText, kind: SpanKind.added, change: index);
      }
    case ChangeStatus.accepted:
      yield ReviewSpan(text: change.newText, kind: SpanKind.same);
    case ChangeStatus.rejected:
      yield ReviewSpan(text: change.originalText, kind: SpanKind.same);
  }
}
