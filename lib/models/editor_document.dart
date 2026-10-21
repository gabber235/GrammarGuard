import "package:diff_match_patch/diff_match_patch.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/pending_change.dart";

part "editor_document.freezed.dart";

/// A run of plain text, or a reference to one of the document's changes.
@freezed
sealed class DocumentSegment with _$DocumentSegment {
  const DocumentSegment._();

  const factory DocumentSegment.text(String text) = TextSegment;
  const factory DocumentSegment.change(int changeIndex) = ChangeSegment;

  bool get isText => this is TextSegment;
  bool get isChange => this is ChangeSegment;
}

/// The reviewed result: plain text with the model's suggestions in between.
/// Positions are in the displayed text, where a pending change shows its
/// original followed by its suggestion.
@freezed
abstract class EditorDocument with _$EditorDocument {
  const EditorDocument._();

  const factory EditorDocument({required List<DocumentSegment> segments, required List<PendingChange> pendingChanges}) =
      _EditorDocument;

  /// A delete followed by an insert becomes one replacement.
  factory EditorDocument.fromDiffs(List<Diff> diffs) {
    final segments = <DocumentSegment>[];
    final changes = <PendingChange>[];
    for (var i = 0; i < diffs.length; i++) {
      final diff = diffs[i];
      final next = i + 1 < diffs.length ? diffs[i + 1] : null;
      final PendingChange change;
      if (diff.operation == DIFF_EQUAL) {
        segments.add(DocumentSegment.text(diff.text));
        continue;
      } else if (diff.operation == DIFF_DELETE && next != null && next.operation == DIFF_INSERT) {
        change = PendingChange.replacement(originalText: diff.text, newText: next.text);
        i++;
      } else if (diff.operation == DIFF_DELETE) {
        change = PendingChange.deletion(diff.text);
      } else {
        change = PendingChange.insertion(diff.text);
      }
      changes.add(change);
      segments.add(DocumentSegment.change(changes.length - 1));
    }
    return EditorDocument(segments: segments, pendingChanges: changes);
  }

  /// The displayed text: pending changes show both versions.
  String getText() {
    final buffer = StringBuffer();
    for (final segment in segments) {
      switch (segment) {
        case TextSegment(:final text):
          buffer.write(text);
        case ChangeSegment(:final changeIndex):
          final change = pendingChanges[changeIndex];
          buffer.write(change.resultText ?? "${change.originalText}${change.newText}");
      }
    }
    return buffer.toString();
  }

  EditorDocument acceptChange(int index) => _update(index, pendingChanges[index].accept());
  EditorDocument rejectChange(int index) => _update(index, pendingChanges[index].reject());

  EditorDocument acceptAll() => copyWith(
    pendingChanges: [
      for (final c in pendingChanges)
        if (c.isPending) c.accept() else c,
    ],
  );
  EditorDocument rejectAll() => copyWith(
    pendingChanges: [
      for (final c in pendingChanges)
        if (c.isPending) c.reject() else c,
    ],
  );

  EditorDocument _update(int index, PendingChange change) =>
      copyWith(pendingChanges: [...pendingChanges.take(index), change, ...pendingChanges.skip(index + 1)]);

  /// Each change with its start in the displayed text, in document order.
  Iterable<(int index, int start)> get _changeStarts sync* {
    var position = 0;
    for (final segment in segments) {
      switch (segment) {
        case TextSegment(:final text):
          position += text.length;
        case ChangeSegment(:final changeIndex):
          yield (changeIndex, position);
          position += pendingChanges[changeIndex].totalDisplayLength;
      }
    }
  }

  int? getChangeAtPosition(int position) {
    for (final (index, start) in _changeStarts) {
      if (position >= start && position < start + pendingChanges[index].totalDisplayLength) return index;
    }
    return null;
  }

  int? getNextPendingChangeIndex(int fromPosition) {
    for (final (index, start) in _changeStarts) {
      if (start >= fromPosition && pendingChanges[index].isPending) return index;
    }
    return null;
  }

  int? getPreviousPendingChangeIndex(int beforePosition) {
    int? found;
    for (final (index, start) in _changeStarts) {
      if (start >= beforePosition) break;
      if (pendingChanges[index].isPending) found = index;
    }
    return found;
  }

  int getPendingChangeCount() => pendingChanges.where((c) => c.isPending).length;
  int getTotalChangeCount() => pendingChanges.length;

  int getChangeStartPosition(int changeIndex) {
    for (final (index, start) in _changeStarts) {
      if (index == changeIndex) return start;
    }
    return getText().length;
  }

  /// Inside a pending change's original text.
  bool isInOriginalRegion(int position) {
    final index = getChangeAtPosition(position);
    if (index == null) return false;
    return position - getChangeStartPosition(index) < pendingChanges[index].originalLength;
  }

  /// Inside a pending change's suggested text.
  bool isInNewRegion(int position) {
    final index = getChangeAtPosition(position);
    if (index == null) return false;
    return position - getChangeStartPosition(index) >= pendingChanges[index].originalLength;
  }

  /// Replaces [start, end) of the displayed text with [insert], keeping every
  /// suggestion the edit does not touch. A touched pending suggestion is
  /// decided first: editing inside the suggested text keeps it, editing
  /// inside the original text undoes it. Fixes B3, where any keystroke
  /// flattened the document and baked "original + suggestion" into the text.
  EditorDocument replaceRange(int start, int end, String insert) {
    var document = this;
    var from = start;
    var to = end;
    while (true) {
      final hit = document._pendingTouching(from, to);
      if (hit == null) break;
      final (index, changeStart) = hit;
      final change = document.pendingChanges[index];
      final split = changeStart + change.originalLength;
      if (from >= split) {
        // Keep the suggestion; the original text before it disappears.
        document = document.acceptChange(index);
        from -= change.originalLength;
        to -= change.originalLength;
      } else {
        // Undo the suggestion; its text after the original disappears.
        document = document.rejectChange(index);
        if (to > split + change.newLength) {
          to -= change.newLength;
        } else if (to > split) {
          to = split;
        }
      }
    }
    return document._splice(from, to, insert);
  }

  /// The first pending change whose displayed text overlaps [from, to). An
  /// empty range touches a change only strictly inside it.
  (int, int)? _pendingTouching(int from, int to) {
    for (final (index, start) in _changeStarts) {
      final change = pendingChanges[index];
      final end = start + change.totalDisplayLength;
      final touches = from == to ? from > start && from < end : from < end && to > start;
      if (change.isPending && touches) return (index, start);
    }
    return null;
  }

  /// Rewrites the segments around [from, to). Decided changes inside the
  /// range become plain text; everything outside keeps its segment.
  EditorDocument _splice(int from, int to, String insert) {
    final out = <DocumentSegment>[];
    final changes = <PendingChange>[];
    var position = 0;
    var inserted = false;

    void addText(String text) {
      if (text.isEmpty) return;
      if (out.lastOrNull case TextSegment(text: final last)) {
        out[out.length - 1] = DocumentSegment.text(last + text);
      } else {
        out.add(DocumentSegment.text(text));
      }
    }

    void addInsert() {
      if (inserted) return;
      inserted = true;
      addText(insert);
    }

    for (final segment in segments) {
      final change = switch (segment) {
        ChangeSegment(:final changeIndex) => pendingChanges[changeIndex],
        TextSegment() => null,
      };
      final shown = switch (segment) {
        TextSegment(:final text) => text,
        ChangeSegment() => change!.resultText ?? "",
      };
      final segmentStart = position;
      final segmentEnd = position + (change?.totalDisplayLength ?? shown.length);
      position = segmentEnd;

      if (segmentEnd <= from || segmentStart >= to) {
        // An insert exactly at a segment boundary goes before the segment.
        if (from == to && from == segmentStart) addInsert();
        if (change == null) {
          addText(shown);
        } else {
          changes.add(change);
          out.add(DocumentSegment.change(changes.length - 1));
        }
        continue;
      }
      // Only text and decided changes reach this point.
      final cutStart = (from - segmentStart).clamp(0, shown.length);
      final cutEnd = (to - segmentStart).clamp(0, shown.length);
      addText(shown.substring(0, cutStart));
      addInsert();
      addText(shown.substring(cutEnd));
    }
    addInsert(); // at the very end, or into an empty document
    return EditorDocument(segments: out, pendingChanges: changes);
  }

  (int line, int column) positionToLineColumn(int position) {
    final text = getText();
    var line = 0;
    var column = 0;
    for (var i = 0; i < position && i < text.length; i++) {
      if (text[i] == "\n") {
        line++;
        column = 0;
      } else {
        column++;
      }
    }
    return (line, column);
  }

  int lineColumnToPosition(int line, int column) {
    final text = getText();
    var currentLine = 0;
    var position = 0;
    while (position < text.length && currentLine < line) {
      if (text[position] == "\n") currentLine++;
      position++;
    }
    return position + column;
  }

  int getLineCount() {
    final text = getText();
    return text.isEmpty ? 1 : text.split("\n").length;
  }

  int getLineLength(int line) {
    final lines = getText().split("\n");
    return line < 0 || line >= lines.length ? 0 : lines[line].length;
  }
}
