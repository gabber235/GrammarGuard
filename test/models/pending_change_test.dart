import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/pending_change.dart";

void main() {
  group("PendingChange", () {
    group("creation", () {
      test("creates an insertion change", () {
        final change = PendingChange.insertion(
          text: "inserted text",
          position: 10,
        );

        expect(change.originalText, isEmpty);
        expect(change.newText, equals("inserted text"));
        expect(change.position, equals(10));
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isTrue);
        expect(change.isDeletion, isFalse);
        expect(change.isReplacement, isFalse);
      });

      test("creates a deletion change", () {
        final change = PendingChange.deletion(
          text: "deleted text",
          position: 5,
        );

        expect(change.originalText, equals("deleted text"));
        expect(change.newText, isEmpty);
        expect(change.position, equals(5));
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isFalse);
        expect(change.isDeletion, isTrue);
        expect(change.isReplacement, isFalse);
      });

      test("creates a replacement change", () {
        final change = PendingChange.replacement(
          originalText: "old text",
          newText: "new text",
          position: 0,
        );

        expect(change.originalText, equals("old text"));
        expect(change.newText, equals("new text"));
        expect(change.position, equals(0));
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isFalse);
        expect(change.isDeletion, isFalse);
        expect(change.isReplacement, isTrue);
      });
    });

    group("length calculations", () {
      test("originalLength returns length of original text", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 0,
        );

        expect(change.originalLength, equals(5));
      });

      test("newLength returns length of new text", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 0,
        );

        expect(change.newLength, equals(2));
      });

      test("totalDisplayLength returns sum of both lengths for pending", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 0,
        );

        expect(change.totalDisplayLength, equals(7));
      });

      test("totalDisplayLength returns newLength for accepted", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 0,
        ).accept();

        expect(change.totalDisplayLength, equals(2));
      });

      test("totalDisplayLength returns originalLength for rejected", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 0,
        ).reject();

        expect(change.totalDisplayLength, equals(5));
      });
    });

    group("status transitions", () {
      test("accept changes status to accepted", () {
        final change = PendingChange.insertion(
          text: "new",
          position: 0,
        );

        final accepted = change.accept();

        expect(accepted.status, equals(ChangeStatus.accepted));
        expect(change.status, equals(ChangeStatus.pending));
      });

      test("reject changes status to rejected", () {
        final change = PendingChange.insertion(
          text: "new",
          position: 0,
        );

        final rejected = change.reject();

        expect(rejected.status, equals(ChangeStatus.rejected));
        expect(change.status, equals(ChangeStatus.pending));
      });

      test("isPending returns true only for pending status", () {
        final pending = PendingChange.insertion(text: "a", position: 0);
        final accepted = pending.accept();
        final rejected = pending.reject();

        expect(pending.isPending, isTrue);
        expect(accepted.isPending, isFalse);
        expect(rejected.isPending, isFalse);
      });
    });

    group("end position", () {
      test("endPosition for pending change includes both texts", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.endPosition, equals(17));
      });

      test("endPosition for accepted change includes only new text", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        ).accept();

        expect(change.endPosition, equals(12));
      });

      test("endPosition for rejected change includes only original text", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        ).reject();

        expect(change.endPosition, equals(15));
      });
    });

    group("containsPosition", () {
      test("returns true when position is within change bounds", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.containsPosition(10), isTrue);
        expect(change.containsPosition(15), isTrue);
        expect(change.containsPosition(16), isTrue);
      });

      test("returns false when position is outside change bounds", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.containsPosition(9), isFalse);
        expect(change.containsPosition(17), isFalse);
      });

      test("returns true at exact start position", () {
        final change = PendingChange.insertion(
          text: "new",
          position: 5,
        );

        expect(change.containsPosition(5), isTrue);
      });
    });

    group("isInOriginalRegion", () {
      test("returns true when position is in original text region", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.isInOriginalRegion(10), isTrue);
        expect(change.isInOriginalRegion(14), isTrue);
      });

      test("returns false when position is in new text region", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.isInOriginalRegion(15), isFalse);
        expect(change.isInOriginalRegion(16), isFalse);
      });

      test("returns false for insertion (no original region)", () {
        final change = PendingChange.insertion(
          text: "new",
          position: 10,
        );

        expect(change.isInOriginalRegion(10), isFalse);
        expect(change.isInOriginalRegion(11), isFalse);
      });
    });

    group("isInNewRegion", () {
      test("returns true when position is in new text region", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.isInNewRegion(15), isTrue);
        expect(change.isInNewRegion(16), isTrue);
      });

      test("returns false when position is in original text region", () {
        final change = PendingChange.replacement(
          originalText: "hello",
          newText: "hi",
          position: 10,
        );

        expect(change.isInNewRegion(10), isFalse);
        expect(change.isInNewRegion(14), isFalse);
      });

      test("returns false for deletion (no new region)", () {
        final change = PendingChange.deletion(
          text: "old",
          position: 10,
        );

        expect(change.isInNewRegion(10), isFalse);
        expect(change.isInNewRegion(12), isFalse);
      });
    });

    group("resultText", () {
      test("returns new text when accepted", () {
        final change = PendingChange.replacement(
          originalText: "old",
          newText: "new",
          position: 0,
        ).accept();

        expect(change.resultText, equals("new"));
      });

      test("returns original text when rejected", () {
        final change = PendingChange.replacement(
          originalText: "old",
          newText: "new",
          position: 0,
        ).reject();

        expect(change.resultText, equals("old"));
      });

      test("returns null when pending", () {
        final change = PendingChange.replacement(
          originalText: "old",
          newText: "new",
          position: 0,
        );

        expect(change.resultText, isNull);
      });
    });

    group("copyWith", () {
      test("copies with new position", () {
        final change = PendingChange.insertion(text: "test", position: 0);
        final copied = change.copyWith(position: 10);

        expect(copied.position, equals(10));
        expect(copied.newText, equals("test"));
        expect(copied.status, equals(ChangeStatus.pending));
      });

      test("copies with new status", () {
        final change = PendingChange.insertion(text: "test", position: 0);
        final copied = change.copyWith(status: ChangeStatus.accepted);

        expect(copied.status, equals(ChangeStatus.accepted));
        expect(copied.position, equals(0));
      });
    });
  });
}
