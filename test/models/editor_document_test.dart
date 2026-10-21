import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";

void main() {
  group("EditorDocument", () {
    group("creation from diffs", () {
      test("creates document from simple text with no changes", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello world")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getText(), equals("Hello world"));
        expect(doc.pendingChanges, isEmpty);
      });

      test("creates document with insertion", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "beautiful "), Diff(DIFF_EQUAL, "world")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.segments.length, equals(3));
        expect(doc.pendingChanges.length, equals(1));
        expect(doc.pendingChanges.first.isInsertion, isTrue);
        expect(doc.pendingChanges.first.newText, equals("beautiful "));
      });

      test("creates document with deletion", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_DELETE, "ugly "), Diff(DIFF_EQUAL, "world")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.pendingChanges.length, equals(1));
        expect(doc.pendingChanges.first.isDeletion, isTrue);
        expect(doc.pendingChanges.first.originalText, equals("ugly "));
      });

      test("creates document with replacement (delete + insert)", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "ugly"),
          Diff(DIFF_INSERT, "beautiful"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.pendingChanges.length, equals(1));
        expect(doc.pendingChanges.first.isReplacement, isTrue);
        expect(doc.pendingChanges.first.originalText, equals("ugly"));
        expect(doc.pendingChanges.first.newText, equals("beautiful"));
      });

      test("creates document with multiple changes", () {
        final diffs = [
          Diff(DIFF_DELETE, "Hi"),
          Diff(DIFF_INSERT, "Hello"),
          Diff(DIFF_EQUAL, " "),
          Diff(DIFF_INSERT, "beautiful "),
          Diff(DIFF_EQUAL, "world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.pendingChanges.length, equals(2));
      });
    });

    group("getText", () {
      test("returns display text with all pending changes shown", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getText(), equals("Hello oldnew world"));
      });

      test("returns text with accepted changes applied", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptChange(0);

        expect(doc.getText(), equals("Hello new world"));
      });

      test("returns text with rejected changes applied", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.rejectChange(0);

        expect(doc.getText(), equals("Hello old world"));
      });
    });

    group("acceptChange", () {
      test("accepts change by index", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "beautiful "), Diff(DIFF_EQUAL, "world")];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptChange(0);

        expect(doc.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });

      test("does not modify original document", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "beautiful "), Diff(DIFF_EQUAL, "world")];
        final doc = EditorDocument.fromDiffs(diffs);
        final newDoc = doc.acceptChange(0);

        expect(doc.pendingChanges.first.isPending, isTrue);
        expect(newDoc.pendingChanges.first.status, equals(ChangeStatus.accepted));
      });
    });

    group("rejectChange", () {
      test("rejects change by index", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "unwanted "), Diff(DIFF_EQUAL, "world")];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.rejectChange(0);

        expect(doc.pendingChanges.first.status, equals(ChangeStatus.rejected));
      });
    });

    group("acceptAll", () {
      test("accepts all pending changes", () {
        final diffs = [
          Diff(DIFF_DELETE, "Hi"),
          Diff(DIFF_INSERT, "Hello"),
          Diff(DIFF_EQUAL, " "),
          Diff(DIFF_INSERT, "beautiful "),
          Diff(DIFF_EQUAL, "world"),
        ];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptAll();

        expect(doc.pendingChanges.every((c) => c.status == ChangeStatus.accepted), isTrue);
        expect(doc.getText(), equals("Hello beautiful world"));
      });
    });

    group("rejectAll", () {
      test("rejects all pending changes", () {
        final diffs = [
          Diff(DIFF_DELETE, "Hi"),
          Diff(DIFF_INSERT, "Hello"),
          Diff(DIFF_EQUAL, " "),
          Diff(DIFF_INSERT, "beautiful "),
          Diff(DIFF_EQUAL, "world"),
        ];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.rejectAll();

        expect(doc.pendingChanges.every((c) => c.status == ChangeStatus.rejected), isTrue);
        expect(doc.getText(), equals("Hi world"));
      });
    });

    group("getChangeAtPosition", () {
      test("returns change index when position is inside a change", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getChangeAtPosition(6), equals(0));
        expect(doc.getChangeAtPosition(9), equals(0));
        expect(doc.getChangeAtPosition(11), equals(0));
      });

      test("returns null when position is not inside a change", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "new"), Diff(DIFF_EQUAL, " world")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getChangeAtPosition(0), isNull);
        expect(doc.getChangeAtPosition(5), isNull);
        expect(doc.getChangeAtPosition(9), isNull);
      });
    });

    group("getNextPendingChangeIndex", () {
      test("returns index of next pending change after position", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "and "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getNextPendingChangeIndex(0), equals(0));
        expect(doc.getNextPendingChangeIndex(12), equals(1));
      });

      test("returns null when no more pending changes", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "new"), Diff(DIFF_EQUAL, " world")];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptChange(0);

        expect(doc.getNextPendingChangeIndex(0), isNull);
      });

      test("skips accepted and rejected changes", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptChange(0);

        expect(doc.getNextPendingChangeIndex(0), equals(1));
      });
    });

    group("getPendingChangeCount", () {
      test("returns count of pending changes", () {
        final diffs = [
          Diff(DIFF_DELETE, "Hi"),
          Diff(DIFF_INSERT, "Hello"),
          Diff(DIFF_EQUAL, " "),
          Diff(DIFF_INSERT, "beautiful "),
          Diff(DIFF_EQUAL, "world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getPendingChangeCount(), equals(2));
      });

      test("decreases when changes are accepted or rejected", () {
        final diffs = [Diff(DIFF_INSERT, "first "), Diff(DIFF_EQUAL, "and "), Diff(DIFF_INSERT, "second")];
        var doc = EditorDocument.fromDiffs(diffs);
        expect(doc.getPendingChangeCount(), equals(2));

        doc = doc.acceptChange(0);
        expect(doc.getPendingChangeCount(), equals(1));

        doc = doc.rejectChange(1);
        expect(doc.getPendingChangeCount(), equals(0));
      });
    });

    group("getTotalChangeCount", () {
      test("returns total number of changes", () {
        final diffs = [Diff(DIFF_INSERT, "first "), Diff(DIFF_EQUAL, "and "), Diff(DIFF_INSERT, "second")];
        var doc = EditorDocument.fromDiffs(diffs);
        doc = doc.acceptChange(0);

        expect(doc.getTotalChangeCount(), equals(2));
      });
    });

    group("getChangeStartPosition", () {
      test("returns the start position of a change by index", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_INSERT, "beautiful "), Diff(DIFF_EQUAL, "world")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getChangeStartPosition(0), equals(6));
      });

      test("returns correct position for multiple changes", () {
        final diffs = [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second "),
          Diff(DIFF_EQUAL, "C"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getChangeStartPosition(0), equals(2));
        expect(doc.getChangeStartPosition(1), equals(10));
      });
    });

    group("isInOriginalRegion", () {
      test("returns true when cursor is in deleted text", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.isInOriginalRegion(6), isTrue);
        expect(doc.isInOriginalRegion(8), isTrue);
      });

      test("returns false when cursor is in inserted text", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.isInOriginalRegion(9), isFalse);
        expect(doc.isInOriginalRegion(11), isFalse);
      });
    });

    group("isInNewRegion", () {
      test("returns true when cursor is in inserted text", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.isInNewRegion(9), isTrue);
        expect(doc.isInNewRegion(11), isTrue);
      });

      test("returns false when cursor is in deleted text", () {
        final diffs = [
          Diff(DIFF_EQUAL, "Hello "),
          Diff(DIFF_DELETE, "old"),
          Diff(DIFF_INSERT, "new"),
          Diff(DIFF_EQUAL, " world"),
        ];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.isInNewRegion(6), isFalse);
        expect(doc.isInNewRegion(8), isFalse);
      });
    });

    group("line and column calculations", () {
      test("positionToLineColumn converts position to line and column", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello\nWorld\nTest")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.positionToLineColumn(0), equals((0, 0)));
        expect(doc.positionToLineColumn(5), equals((0, 5)));
        expect(doc.positionToLineColumn(6), equals((1, 0)));
        expect(doc.positionToLineColumn(11), equals((1, 5)));
        expect(doc.positionToLineColumn(12), equals((2, 0)));
      });

      test("lineColumnToPosition converts line and column to position", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello\nWorld\nTest")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.lineColumnToPosition(0, 0), equals(0));
        expect(doc.lineColumnToPosition(0, 5), equals(5));
        expect(doc.lineColumnToPosition(1, 0), equals(6));
        expect(doc.lineColumnToPosition(1, 5), equals(11));
        expect(doc.lineColumnToPosition(2, 0), equals(12));
      });

      test("getLineCount returns number of lines", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello\nWorld\nTest")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getLineCount(), equals(3));
      });

      test("getLineLength returns length of specific line", () {
        final diffs = [Diff(DIFF_EQUAL, "Hello\nWorld\nTest")];
        final doc = EditorDocument.fromDiffs(diffs);

        expect(doc.getLineLength(0), equals(5));
        expect(doc.getLineLength(1), equals(5));
        expect(doc.getLineLength(2), equals(4));
      });
    });

    group("getPreviousPendingChangeIndex", () {
      final doc = EditorDocument.fromDiffs([
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_INSERT, "first "),
        Diff(DIFF_EQUAL, "B "),
        Diff(DIFF_INSERT, "second "),
        Diff(DIFF_EQUAL, "C"),
      ]);

      test("returns the last pending change starting before the position", () {
        expect(doc.getPreviousPendingChangeIndex(10), equals(0));
        expect(doc.getPreviousPendingChangeIndex(11), equals(1));
        expect(doc.getPreviousPendingChangeIndex(100), equals(1));
      });

      test("returns null before the first change", () {
        expect(doc.getPreviousPendingChangeIndex(2), isNull);
        expect(doc.getPreviousPendingChangeIndex(0), isNull);
      });

      test("skips decided changes", () {
        expect(doc.acceptChange(1).getPreviousPendingChangeIndex(100), equals(0));
      });
    });

    group("replaceRange", () {
      // "A tehthe x katcat B": change 0 spans [2, 8) with its suggestion
      // from 5, change 1 spans [11, 17) with its suggestion from 14.
      final twoChanges = EditorDocument.fromDiffs([
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_DELETE, "teh"),
        Diff(DIFF_INSERT, "the"),
        Diff(DIFF_EQUAL, " x "),
        Diff(DIFF_DELETE, "kat"),
        Diff(DIFF_INSERT, "cat"),
        Diff(DIFF_EQUAL, " B"),
      ]);

      test("edits plain text and keeps every pending change", () {
        final doc = twoChanges.replaceRange(9, 10, "y");

        expect(doc.getText(), equals("A tehthe y katcat B"));
        expect(doc.getPendingChangeCount(), equals(2));
        expect(doc.acceptAll().getText(), equals("A the y cat B"));
        expect(doc.rejectAll().getText(), equals("A teh y kat B"));
      });

      test("inserts at the start of a change before it, keeping it pending", () {
        final doc = twoChanges.replaceRange(2, 2, "X");

        expect(doc.getText(), equals("A Xtehthe x katcat B"));
        expect(doc.getPendingChangeCount(), equals(2));
        expect(doc.getChangeStartPosition(0), equals(3));
      });

      test("inserts at the end of a change after it, keeping it pending", () {
        final doc = twoChanges.replaceRange(8, 8, "X");

        expect(doc.getText(), equals("A tehtheX x katcat B"));
        expect(doc.getPendingChangeCount(), equals(2));
        expect(doc.acceptAll().getText(), equals("A theX x cat B"));
      });

      test("inserts between original and suggestion by keeping the suggestion", () {
        final doc = twoChanges.replaceRange(5, 5, "X");

        expect(doc.getText(), equals("A Xthe x katcat B"));
        expect(doc.pendingChanges[0].status, equals(ChangeStatus.accepted));
        expect(doc.getPendingChangeCount(), equals(1));
      });

      test("deleting across two changes undoes both and removes the range", () {
        final doc = twoChanges.replaceRange(1, 18, "");

        expect(doc.getText(), equals("AB"));
        expect(doc.getPendingChangeCount(), equals(0));
      });

      test("deleting from one suggestion into the next original keeps one, undoes the other", () {
        final doc = twoChanges.replaceRange(6, 13, "");

        // Change 0 kept ("the"), change 1 undone ("kat"); the cut runs
        // from after "t" in "the" to after "ka" in "kat".
        expect(doc.getText(), equals("A tt B"));
        expect(doc.getPendingChangeCount(), equals(0));
      });

      test("leaves the original document untouched", () {
        twoChanges.replaceRange(1, 18, "");

        expect(twoChanges.getText(), equals("A tehthe x katcat B"));
        expect(twoChanges.getPendingChangeCount(), equals(2));
      });

      test("inserts into an empty document", () {
        final empty = EditorDocument.fromDiffs([]);

        expect(empty.getText(), isEmpty);
        expect(empty.replaceRange(0, 0, "Hi").getText(), equals("Hi"));
        expect(empty.replaceRange(0, 0, "").getText(), isEmpty);
      });

      test("deleting all text leaves an empty document", () {
        final doc = EditorDocument.fromDiffs([Diff(DIFF_EQUAL, "Hello")]).replaceRange(0, 5, "");

        expect(doc.getText(), isEmpty);
        expect(doc.getLineCount(), equals(1));
      });

      test("keeps decided changes outside the range as changes", () {
        final doc = twoChanges.acceptChange(0).replaceRange(14, 16, "");

        expect(doc.getText(), equals("A the x katcat"));
        expect(doc.pendingChanges.map((c) => c.status), equals([ChangeStatus.accepted, ChangeStatus.pending]));
      });
    });
  });
}
