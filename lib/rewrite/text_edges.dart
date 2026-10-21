/// Removes the `<text>` wrapper some models echo back.
String unwrapText(String output) {
  final match = RegExp(r"^\s*<text>\n?([\s\S]*?)\n?</text>\s*$").firstMatch(output);
  return match == null ? output : match[1]!;
}

/// Gives [output] the leading and trailing whitespace of [input]. Models trim
/// freely, and pasting back must not eat the space or newline around a
/// selection. Replaces the trim() in ai_rewrite.dart:197 that also hid
/// whitespace changes from the diff.
String restoreEdges(String input, String output) {
  final lead = RegExp(r"^\s*").stringMatch(input)!;
  final trail = RegExp(r"\s*$").stringMatch(input)!;
  return "$lead${output.trim()}$trail";
}
