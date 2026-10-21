import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/review/word_diff.dart";

/// The diff as (operation, text) pairs, easy to compare.
List<(int, String)> parts(String before, String after) => [
  for (final d in wordDiff(before, after)) (d.operation, d.text),
];

/// Joins the parts a side of the diff is made of.
String side(List<Diff> diffs, int changed) =>
    diffs.where((d) => d.operation == DIFF_EQUAL || d.operation == changed).map((d) => d.text).join();

/// wordDiff runs diffCleanupSemantic after mapping tokens back to text, so
/// the cleanup works on characters again and splits words ("food" to
/// "foods" becomes an empty delete, an equal "food" and an inserted "s").
/// Running the cleanup before the mapping fixes it. Unskip then.

void main() {
  group("wordDiff", () {
    test("replaces a whole word, not its tail", () {
      expect(
        parts("I like food", "I like foods"),
        equals([(DIFF_EQUAL, "I like "), (DIFF_DELETE, "food"), (DIFF_INSERT, "foods")]),
      );
    });

    test("keeps accented words whole", () {
      expect(
        parts("Ik heb een cafe bezocht", "Ik heb een café bezocht"),
        equals([(DIFF_EQUAL, "Ik heb een "), (DIFF_DELETE, "cafe"), (DIFF_INSERT, "café"), (DIFF_EQUAL, " bezocht")]),
      );
    });

    test("keeps Dutch words with diaeresis and apostrophes whole", () {
      expect(
        parts("De zeeen zijn geinteresseerd in autos", "De zeeën zijn geïnteresseerd in auto's"),
        equals([
          (DIFF_EQUAL, "De "),
          (DIFF_DELETE, "zeeen"),
          (DIFF_INSERT, "zeeën"),
          (DIFF_EQUAL, " zijn "),
          (DIFF_DELETE, "geinteresseerd"),
          (DIFF_INSERT, "geïnteresseerd"),
          (DIFF_EQUAL, " in "),
          (DIFF_DELETE, "autos"),
          (DIFF_INSERT, "auto's"),
        ]),
      );
    });

    test("keeps a combining accent with its letter", () {
      const combined = "cafe\u0301";
      expect(
        parts("een cafe", "een $combined"),
        equals([(DIFF_EQUAL, "een "), (DIFF_DELETE, "cafe"), (DIFF_INSERT, combined)]),
      );
    });

    test("treats punctuation as its own token", () {
      expect(
        parts("Hello, world.", "Hello world!"),
        equals([
          (DIFF_EQUAL, "Hello"),
          (DIFF_DELETE, ","),
          (DIFF_EQUAL, " world"),
          (DIFF_DELETE, "."),
          (DIFF_INSERT, "!"),
        ]),
      );
    });

    test("an unchanged text is one equal part", () {
      expect(parts("Same text.", "Same text."), equals([(DIFF_EQUAL, "Same text.")]));
    });

    test("handles empty input and output", () {
      expect(parts("", "New"), equals([(DIFF_INSERT, "New")]));
      expect(parts("Old", ""), equals([(DIFF_DELETE, "Old")]));
      expect(parts("", ""), isEmpty);
    });

    group("joining the parts gives back both texts exactly", () {
      const cases = [
        ("I like food", "I like foods"),
        ("  leading and trailing spaces  ", " leading and trailing space "),
        ("Twee  spaties\nen een nieuwe regel.\n", "Twee spaties\n\nen een nieuwe regel!\n"),
        ("Ik heb  de café's gezien, maar teh rest niet.", "Ik heb de cafés gezien maar de rest niet!"),
        ("tabs\tand\r\nwindows lines", "tabs and\nunix lines"),
        ("emoji 👍 and 한국어 text", "emoji 🎉 and 한국어 words"),
        ("Dit is één zin.", "Dit is een zin, of twee."),
        ("", "only output"),
        ("only input", ""),
      ];

      for (final (before, after) in cases) {
        test(before.replaceAll("\n", r"\n"), () {
          final diffs = wordDiff(before, after);

          expect(side(diffs, DIFF_DELETE), equals(before));
          expect(side(diffs, DIFF_INSERT), equals(after));
        });
      }
    });
  });
}
