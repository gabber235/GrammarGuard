import "package:diff_match_patch/diff_match_patch.dart";

/// Words (letters in any script, digits, inner apostrophes), runs of
/// whitespace, and single punctuation marks.
final _token = RegExp(r"[\p{L}\p{N}\p{M}_]+(?:['’][\p{L}\p{N}\p{M}_]+)*|\s+|[^\p{L}\p{N}\p{M}_\s]", unicode: true);

/// Diffs on whole words, so "food" to "foods" shows one replaced word
/// instead of an inserted "s". Same trick as diff_match_patch's line mode:
/// map each distinct token to one character, diff those, map back.
List<Diff> wordDiff(String before, String after) {
  final codes = <String, int>{};
  final tokens = <String>[];

  String encode(String text) {
    final buffer = StringBuffer();
    for (final match in _token.allMatches(text)) {
      final token = match[0]!;
      buffer.writeCharCode(
        codes.putIfAbsent(token, () {
          tokens.add(token);
          return _charFor(tokens.length - 1);
        }),
      );
    }
    return buffer.toString();
  }

  final dmp = DiffMatchPatch()..diffTimeout = 1;
  final diffs = dmp.diff(encode(before), encode(after), false);
  // Clean up while each character is still a whole token, so the cleanup
  // can never split a word again.
  dmp.diffCleanupSemantic(diffs);
  for (final diff in diffs) {
    diff.text = diff.text.codeUnits.map((c) => tokens[_indexFor(c)]).join();
  }
  return diffs;
}

// Code units from 0x100, skipping the surrogate range so every token is one
// UTF-16 unit. Room for about 63,000 distinct tokens.
int _charFor(int index) => index < 0xD700 ? index + 0x100 : index + 0x900;
int _indexFor(int unit) => unit < 0xD800 ? unit - 0x100 : unit - 0x900;
