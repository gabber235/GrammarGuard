import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/pending_change.dart";

void main() {
  group("PendingChange", () {
    group("creation", () {
      test("creates an insertion change", () {
        final change = PendingChange.insertion("inserted text");

        expect(change.originalText, isEmpty);
        expect(change.newText, equals("inserted text"));
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isTrue);
        expect(change.isDeletion, isFalse);
        expect(change.isReplacement, isFalse);
      });

      test("creates a deletion change", () {
        final change = PendingChange.deletion("deleted text");

        expect(change.originalText, equals("deleted text"));
        expect(change.newText, isEmpty);
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isFalse);
        expect(change.isDeletion, isTrue);
        expect(change.isReplacement, isFalse);
      });

      test("creates a replacement change", () {
        final change = PendingChange.replacement(originalText: "old text", newText: "new text");

        expect(change.originalText, equals("old text"));
        expect(change.newText, equals("new text"));
        expect(change.status, equals(ChangeStatus.pending));
        expect(change.isInsertion, isFalse);
        expect(change.isDeletion, isFalse);
        expect(change.isReplacement, isTrue);
      });
    });

    group("length calculations", () {
      final change = PendingChange.replacement(originalText: "hello", newText: "hi");

      test("originalLength returns length of original text", () {
        expect(change.originalLength, equals(5));
      });

      test("newLength returns length of new text", () {
        expect(change.newLength, equals(2));
      });

      test("totalDisplayLength returns sum of both lengths for pending", () {
        expect(change.totalDisplayLength, equals(7));
      });

      test("totalDisplayLength returns newLength for accepted", () {
        expect(change.accept().totalDisplayLength, equals(2));
      });

      test("totalDisplayLength returns originalLength for rejected", () {
        expect(change.reject().totalDisplayLength, equals(5));
      });
    });

    group("status transitions", () {
      test("accept changes status to accepted", () {
        final change = PendingChange.insertion("new");

        final accepted = change.accept();

        expect(accepted.status, equals(ChangeStatus.accepted));
        expect(change.status, equals(ChangeStatus.pending));
      });

      test("reject changes status to rejected", () {
        final change = PendingChange.insertion("new");

        final rejected = change.reject();

        expect(rejected.status, equals(ChangeStatus.rejected));
        expect(change.status, equals(ChangeStatus.pending));
      });

      test("isPending returns true only for pending status", () {
        final pending = PendingChange.insertion("a");

        expect(pending.isPending, isTrue);
        expect(pending.accept().isPending, isFalse);
        expect(pending.reject().isPending, isFalse);
      });
    });

    group("resultText", () {
      final change = PendingChange.replacement(originalText: "old", newText: "new");

      test("returns new text when accepted", () {
        expect(change.accept().resultText, equals("new"));
      });

      test("returns original text when rejected", () {
        expect(change.reject().resultText, equals("old"));
      });

      test("returns null when pending", () {
        expect(change.resultText, isNull);
      });
    });

    group("value semantics", () {
      test("copyWith changes only the status", () {
        final change = PendingChange.insertion("test");
        final copied = change.copyWith(status: ChangeStatus.accepted);

        expect(copied.status, equals(ChangeStatus.accepted));
        expect(copied.newText, equals("test"));
        expect(copied.originalText, isEmpty);
      });

      test("equal fields make equal changes", () {
        expect(
          PendingChange.replacement(originalText: "a", newText: "b"),
          equals(const PendingChange(originalText: "a", newText: "b")),
        );
        expect(PendingChange.insertion("a"), isNot(equals(PendingChange.insertion("a").accept())));
      });
    });
  });
}
