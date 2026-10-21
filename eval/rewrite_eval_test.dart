// Real models, on demand: `just eval anthropic/claude-haiku-4-5`.
// Tagged so a plain `flutter test` skips it (dart_test.yaml).
@Tags(["eval"])
library;

import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/prompt.dart";
import "package:grammar_guard/instructions/resolve.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/review/word_diff.dart";
import "package:grammar_guard/rewrite/text_edges.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:yaml/yaml.dart";

/// One test per case in eval/cases.yaml; the file explains the fields.
void main() {
  final model = ModelRef.tryParse(Platform.environment["EVAL_MODEL"] ?? "");
  if (model == null) {
    test("eval", () {}, skip: "Set EVAL_MODEL, for example anthropic/claude-haiku-4-5.");
    return;
  }
  final connection = Connection(backend: model.backend, enabled: true, apiKey: Platform.environment["EVAL_API_KEY"]);
  final library = parseLibrary(File("assets/library.yaml").readAsStringSync());
  const gateway = LlmDartGateway();
  final cases = loadYaml(File("eval/cases.yaml").readAsStringSync()) as YamlList;

  for (final c in cases.cast<YamlMap>()) {
    test(c["name"] as String, () async {
      final source = c["app"] == null
          ? null
          : SourceApp(id: c["app"] as String, name: c["app"] as String, processId: 0);
      final choices =
          (c["use"] as YamlList?)?.fold(const RunChoices(), (r, id) => r.turnOn(InstructionId(id as String))) ??
          const RunChoices();
      final input = c["text"] as String;
      final prompt = compose(resolve(library, source, input, choices), input);
      final chat = await gateway.chat(connection, model, system: prompt.system);
      // The same clean up the app applies before showing a result.
      final raw = (await chat.chat([llm.ChatMessage.user(prompt.user)])).text ?? "";
      final output = restoreEdges(input, unwrapText(raw));
      final expected = c["expect"] as YamlMap;

      expect(output, isNot(contains("—")), reason: "em dash");
      expect(output, isNot(matches(RegExp(r"^(Sure|Here)\b"))), reason: "preamble");
      if (expected["unchanged"] == true) expect(output, input);
      if (expected["max_changed"] case final num limit) {
        expect(changedShare(input, output), lessThanOrEqualTo(limit));
      }
      for (final banned in (expected["no"] as YamlList?) ?? YamlList()) {
        expect(output, isNot(contains(banned)));
      }
      if (expected["language"] case final String language) {
        expect(guessLanguage(output), language);
      }
    });
  }
}

/// Share of words that changed, from the same word diff the app uses.
double changedShare(String before, String after) {
  final diffs = wordDiff(before, after);
  final changed = diffs.where((d) => d.operation != 0).fold(0, (n, d) => n + d.text.split(" ").length);
  return changed / before.split(" ").length.clamp(1, 1 << 30);
}

/// Stop-word vote between the languages in the case file. Good enough to
/// catch "answered in English" without another model call.
String guessLanguage(String text) {
  const stopWords = {
    "en": ["the", "and", "is", "of", "to", "it"],
    "nl": ["de", "het", "een", "en", "is", "niet"],
    "de": ["der", "die", "und", "ist", "nicht", "ein"],
  };
  final words = text.toLowerCase().split(RegExp(r"\W+"));
  return stopWords.entries
      .map((e) => (e.key, words.where(e.value.contains).length))
      .reduce((a, b) => a.$2 >= b.$2 ? a : b)
      .$1;
}
