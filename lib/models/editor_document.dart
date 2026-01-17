import "package:diff_match_patch/diff_match_patch.dart";
import "package:grammar_guard/models/pending_change.dart";

enum SegmentType {
  text,
  change,
}

class DocumentSegment {

  const DocumentSegment.text(this.text)
      : type = SegmentType.text,
        changeIndex = null;

  const DocumentSegment.change(this.changeIndex)
      : type = SegmentType.change,
        text = "";
  final SegmentType type;
  final String text;
  final int? changeIndex;

  bool get isText => type == SegmentType.text;
  bool get isChange => type == SegmentType.change;
}

class EditorDocument {

  const EditorDocument({
    required this.segments,
    required this.pendingChanges,
  });

  factory EditorDocument.fromDiffs(List<Diff> diffs) {
    final segments = <DocumentSegment>[];
    final changes = <PendingChange>[];
    var position = 0;

    for (var i = 0; i < diffs.length; i++) {
      final diff = diffs[i];

      if (diff.operation == DIFF_EQUAL) {
        segments.add(DocumentSegment.text(diff.text));
        position += diff.text.length;
        continue;
      }

      if (diff.operation == DIFF_DELETE) {
        final nextDiff = i + 1 < diffs.length ? diffs[i + 1] : null;
        if (nextDiff != null && nextDiff.operation == DIFF_INSERT) {
          final change = PendingChange.replacement(
            originalText: diff.text,
            newText: nextDiff.text,
            position: position,
          );
          changes.add(change);
          segments.add(DocumentSegment.change(changes.length - 1));
          position += diff.text.length + nextDiff.text.length;
          i++;
        } else {
          final change = PendingChange.deletion(
            text: diff.text,
            position: position,
          );
          changes.add(change);
          segments.add(DocumentSegment.change(changes.length - 1));
          position += diff.text.length;
        }
        continue;
      }

      if (diff.operation == DIFF_INSERT) {
        final change = PendingChange.insertion(
          text: diff.text,
          position: position,
        );
        changes.add(change);
        segments.add(DocumentSegment.change(changes.length - 1));
        position += diff.text.length;
      }
    }

    return EditorDocument(segments: segments, pendingChanges: changes);
  }
  final List<DocumentSegment> segments;
  final List<PendingChange> pendingChanges;

  String getText() {
    final sb = StringBuffer();
    for (final segment in segments) {
      if (segment.isText) {
        sb.write(segment.text);
      } else if (segment.isChange) {
        final change = pendingChanges[segment.changeIndex!];
        switch (change.status) {
          case ChangeStatus.pending:
            sb.write(change.originalText);
            sb.write(change.newText);
          case ChangeStatus.accepted:
            sb.write(change.newText);
          case ChangeStatus.rejected:
            sb.write(change.originalText);
        }
      }
    }
    return sb.toString();
  }

  String? getResultText() {
    if (pendingChanges.any((c) => c.isPending)) {
      return null;
    }
    return getText();
  }

  EditorDocument acceptChange(int index) {
    final newChanges = List<PendingChange>.from(pendingChanges);
    newChanges[index] = newChanges[index].accept();
    return EditorDocument(segments: segments, pendingChanges: newChanges);
  }

  EditorDocument rejectChange(int index) {
    final newChanges = List<PendingChange>.from(pendingChanges);
    newChanges[index] = newChanges[index].reject();
    return EditorDocument(segments: segments, pendingChanges: newChanges);
  }

  EditorDocument acceptAll() {
    final newChanges =
        pendingChanges.map((c) => c.isPending ? c.accept() : c).toList();
    return EditorDocument(segments: segments, pendingChanges: newChanges);
  }

  EditorDocument rejectAll() {
    final newChanges =
        pendingChanges.map((c) => c.isPending ? c.reject() : c).toList();
    return EditorDocument(segments: segments, pendingChanges: newChanges);
  }

  int? getChangeAtPosition(int position) {
    var currentPos = 0;
    for (final segment in segments) {
      if (segment.isText) {
        currentPos += segment.text.length;
        continue;
      }

      final change = pendingChanges[segment.changeIndex!];
      final changeLength = change.totalDisplayLength;

      if (position >= currentPos && position < currentPos + changeLength) {
        return segment.changeIndex;
      }
      currentPos += changeLength;
    }
    return null;
  }

  int? getNextPendingChangeIndex(int fromPosition) {
    var currentPos = 0;
    for (final segment in segments) {
      if (segment.isText) {
        currentPos += segment.text.length;
        continue;
      }

      final change = pendingChanges[segment.changeIndex!];
      final changeLength = change.totalDisplayLength;

      if (currentPos >= fromPosition && change.isPending) {
        return segment.changeIndex;
      }
      currentPos += changeLength;
    }
    return null;
  }

  int getPendingChangeCount() {
    return pendingChanges.where((c) => c.isPending).length;
  }

  int getTotalChangeCount() {
    return pendingChanges.length;
  }

  int getChangeStartPosition(int changeIndex) {
    var position = 0;
    for (final segment in segments) {
      if (segment.isText) {
        position += segment.text.length;
        continue;
      }

      if (segment.changeIndex == changeIndex) {
        return position;
      }

      final change = pendingChanges[segment.changeIndex!];
      position += change.totalDisplayLength;
    }
    return position;
  }

  bool isInOriginalRegion(int position) {
    var currentPos = 0;
    for (final segment in segments) {
      if (segment.isText) {
        currentPos += segment.text.length;
        continue;
      }

      final change = pendingChanges[segment.changeIndex!];
      final changeLength = change.totalDisplayLength;

      if (position >= currentPos && position < currentPos + changeLength) {
        final relativePos = position - currentPos;
        return relativePos < change.originalLength;
      }
      currentPos += changeLength;
    }
    return false;
  }

  bool isInNewRegion(int position) {
    var currentPos = 0;
    for (final segment in segments) {
      if (segment.isText) {
        currentPos += segment.text.length;
        continue;
      }

      final change = pendingChanges[segment.changeIndex!];
      final changeLength = change.totalDisplayLength;

      if (position >= currentPos && position < currentPos + changeLength) {
        final relativePos = position - currentPos;
        return relativePos >= change.originalLength;
      }
      currentPos += changeLength;
    }
    return false;
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
      if (text[position] == "\n") {
        currentLine++;
      }
      position++;
    }

    return position + column;
  }

  int getLineCount() {
    final text = getText();
    if (text.isEmpty) return 1;
    return text.split("\n").length;
  }

  int getLineLength(int line) {
    final lines = getText().split("\n");
    if (line < 0 || line >= lines.length) return 0;
    return lines[line].length;
  }
}
