import "package:diff_match_patch/diff_match_patch.dart";

/// Words (letters in any script, digits, inner apostrophes), runs of
/// whitespace, and single punctuation marks.
final _token = RegExp(r"[\p{L}\p{N}\p{M}_]+(?:['’][\p{L}\p{N}\p{M}_]+)*|\s+|[^\p{L}\p{N}\p{M}_\s]", unicode: true);

/// Diffs on whole words, so "food" to "foods" shows one replaced word
/// instead of an inserted "s". Same trick as diff_match_patch's line mode:
/// map each distinct token to one character, diff those, map back.
List<Diff> wordDiff(String before, String after) {
  final codes = _Codes();
  return codes.decode(_diff(codes.encode(before), codes.encode(after)));
}

/// [wordDiff] of [after] against only the start of [before] it lines up
/// with, for a text that is still being written: the part of [before] it
/// has not reached yet is left out instead of shown as deleted.
///
/// Diffing a short [after] against all of [before] makes diff_match_patch
/// search the whole unreached tail, hundreds of milliseconds per call on a
/// long text. It also lets the newest words line up anywhere in that tail,
/// so text already shown changes from one word to the next. So [after] is
/// aligned in windows of [_window] tokens. Each starts where the one before
/// settled, finds how far into [before] it reaches (dropping the rest is
/// free there), and diffs up to that point. A full window keeps its diff up
/// to its last unchanged text, so it reads the same however much more is
/// written, and the work per window stays small however long the text gets.
/// A dropped passage shows as what follows it being added, until more is
/// written after it than it was long.
List<Diff> wordDiffPrefix(String before, String after) {
  final codes = _Codes();
  final a = codes.encode(before);
  final b = codes.encode(after);
  final dmp = DiffMatchPatch();
  final diffs = <Diff>[];
  var inA = 0;
  var inB = 0;
  while (inB < b.length) {
    final last = inB + _window >= b.length;
    final rest = a.substring(inA);
    final part = b.substring(inB, last ? b.length : inB + _window);
    final reached = _reached(rest, part) ?? (part.length < rest.length ? part.length : rest.length);
    final window = dmp.diff(rest.substring(0, reached), part, false);
    final equal = window.lastIndexWhere((d) => d.operation == DIFF_EQUAL);
    final kept = last || equal < 0 ? window : window.sublist(0, equal + 1);
    for (final diff in kept) {
      if (diff.operation != DIFF_INSERT) inA += diff.text.length;
      if (diff.operation != DIFF_DELETE) inB += diff.text.length;
      // A kept window ends on unchanged text, which the next may start with.
      if (diffs.isNotEmpty && diffs.last.operation == DIFF_EQUAL && diff.operation == DIFF_EQUAL) {
        diffs.last.text += diff.text;
      } else {
        diffs.add(diff);
      }
    }
    if (last) break;
  }
  // Clean up while each character is still a whole token, as in [_diff].
  dmp.diffCleanupSemantic(diffs);
  while (diffs.isNotEmpty && diffs.last.operation == DIFF_DELETE) {
    diffs.removeLast();
  }
  return codes.decode(diffs);
}

/// Tokens of the written text [wordDiffPrefix] aligns at a time: about a
/// hundred words.
const _window = 200;

List<Diff> _diff(String a, String b) {
  final dmp = DiffMatchPatch()..diffTimeout = 1;
  final diffs = dmp.diff(a, b, false);
  // Clean up while each character is still a whole token, so the cleanup
  // can never split a word again.
  dmp.diffCleanupSemantic(diffs);
  return diffs;
}

/// Each distinct token as one UTF-16 code unit.
class _Codes {
  final _codes = <String, int>{};
  final _tokens = <String>[];

  String encode(String text) {
    final buffer = StringBuffer();
    for (final match in _token.allMatches(text)) {
      final token = match[0]!;
      buffer.writeCharCode(
        _codes.putIfAbsent(token, () {
          _tokens.add(token);
          return _charFor(_tokens.length - 1);
        }),
      );
    }
    return buffer.toString();
  }

  List<Diff> decode(List<Diff> diffs) {
    for (final diff in diffs) {
      diff.text = diff.text.codeUnits.map((c) => _tokens[_indexFor(c)]).join();
    }
    return diffs;
  }
}

/// Past this many edits in one window the text is a rewrite, not a
/// correction, and the search would cost more than a guess is worth.
const _maxEdits = 400;

/// How much of [a] all of [b] lines up with at the fewest edits, when
/// dropping the rest of [a] is free. Myers' forward search, stopped at the
/// first path that reaches the end of [b]; it costs about the length times
/// the edits in [b], never the unreached rest of [a]. Null past [_maxEdits].
int? _reached(String a, String b) {
  final n = a.length;
  final m = b.length;
  const offset = _maxEdits + 1;
  // Furthest x reached on each diagonal k = x - y, or -1 for none.
  final far = List.filled(2 * offset + 1, -1)..[offset + 1] = 0;
  for (var d = 0; d <= _maxEdits; d++) {
    for (var k = -d; k <= d; k += 2) {
      final down = k == -d || (k != d && far[offset + k - 1] < far[offset + k + 1]);
      final from = far[offset + k + (down ? 1 : -1)];
      if (from < 0) {
        far[offset + k] = -1;
        continue;
      }
      var x = down ? from : from + 1;
      var y = x - k;
      if (x > n || y > m) {
        far[offset + k] = -1;
        continue;
      }
      while (x < n && y < m && a.codeUnitAt(x) == b.codeUnitAt(y)) {
        x++;
        y++;
      }
      far[offset + k] = x;
      if (y == m) return x;
    }
  }
  return null;
}

// Code units from 0x100, skipping the surrogate range so every token is one
// UTF-16 unit. Room for about 63,000 distinct tokens.
int _charFor(int index) => index < 0xD700 ? index + 0x100 : index + 0x900;
int _indexFor(int unit) => unit < 0xD800 ? unit - 0x100 : unit - 0x900;
