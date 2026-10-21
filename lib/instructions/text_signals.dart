import "package:freezed_annotation/freezed_annotation.dart";

part "text_signals.freezed.dart";

enum Content { code, markdown, latex, link, list }

/// Cheap facts about the captured text that profiles can match on.
/// Pure and local: computed on every capture, never sent anywhere.
@freezed
abstract class TextSignals with _$TextSignals {
  const factory TextSignals({
    required int words,
    required Set<Content> contains,

    /// ISO 639-1 code, or null when too short or unclear to tell.
    String? language,
  }) = _TextSignals;

  factory TextSignals.of(String text) => TextSignals(
    words: RegExp(r"[\p{L}\p{N}]+", unicode: true).allMatches(text).length,
    contains: {
      for (final MapEntry(:key, :value) in _content.entries)
        if (value.hasMatch(text)) key,
    },
    language: detectLanguage(text),
  );
}

final _content = {
  Content.code: RegExp(r"```|`[^`\n]+`|^( {4}|\t)\S", multiLine: true),
  Content.markdown: RegExp(r"^#{1,6} |\*\*[^*]+\*\*|^\s*> ", multiLine: true),
  Content.latex: RegExp(r"\\[a-zA-Z]+\{|\$[^$\n]+\$"),
  Content.link: RegExp(r"https?://\S+"),
  Content.list: RegExp(r"^\s*([-*] |\d+\. )", multiLine: true),
};

/// The most common short words per language. Good enough to tell Dutch from
/// English in a chat message; the model handles the rest.
const _stopWords = {
  "en": ["the", "and", "is", "to", "of", "it", "that", "you", "for", "with"],
  "nl": ["de", "het", "een", "en", "is", "niet", "dat", "ik", "je", "van"],
  "de": ["der", "die", "und", "ist", "nicht", "das", "ich", "zu", "ein", "mit"],
  "fr": ["le", "la", "et", "est", "les", "des", "pas", "je", "une", "que"],
  "es": ["el", "la", "y", "es", "que", "los", "una", "no", "por", "con"],
  "it": ["il", "la", "e", "che", "non", "di", "una", "per", "sono", "con"],
  "pt": ["o", "a", "e", "que", "não", "de", "um", "uma", "para", "com"],
  "sv": ["och", "att", "det", "är", "en", "jag", "inte", "som", "på", "med"],
  "pl": ["i", "nie", "się", "jest", "to", "na", "że", "w", "z", "do"],
};

String? detectLanguage(String text) {
  final words = text.toLowerCase().split(RegExp(r"[^\p{L}]+", unicode: true));
  if (words.length < 4) return null;
  final scores = {for (final MapEntry(:key, :value) in _stopWords.entries) key: words.where(value.contains).length};
  final best = scores.entries.reduce((a, b) => a.value >= b.value ? a : b);
  final second = scores.values.where((v) => v != best.value).fold(0, (m, v) => v > m ? v : m);
  // Needs a clear winner, or it guesses wrong on short mixed text.
  return best.value >= 2 && best.value > second * 1.5 ? best.key : null;
}
