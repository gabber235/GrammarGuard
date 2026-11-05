import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/bar/bar_items.dart";
import "package:grammar_guard/llm/llm.dart";

import "../support/library.dart";

void main() {
  const models = [
    ModelInfo(ref: ModelRef(Backend.openrouter, "inception/mercury-3"), label: "Mercury 3"),
    ModelInfo(ref: ModelRef(Backend.deepseek, "deepseek-flash"), label: "DeepSeek Flash"),
    ModelInfo(ref: ModelRef(Backend.anthropic, "pro-writer"), label: "Pro Writer"),
    ModelInfo(ref: ModelRef(Backend.anthropic, "claude-opus-5"), label: "Claude Opus 5"),
  ];

  List<String> search(String query) => [
    for (final item in barItems(
      query: query,
      library: bundled(),
      active: const {},
      words: "",
      models: models,
      history: const [],
      source: null,
    ))
      if (item is ModelItem) item.label,
  ];

  test("listing models, the connection and the maker find them", () {
    expect(search("@openrouter"), ["Mercury 3"]);
    expect(search("@inception"), ["Mercury 3"]);
    expect(search("@anthropic"), ["Pro Writer", "Claude Opus 5"]);
  });

  test("a provider's letters inside a word do not find its models", () {
    expect(search("@pro"), ["Pro Writer"]);
    expect(search("@en"), isEmpty);
  });

  test("a name beats a provider, because Enter takes the top row", () {
    expect(search("@op").first, "Claude Opus 5");
  });

  test("the plain search stays on names, so one provider cannot fill it", () {
    expect(search("openrouter"), isEmpty);
    expect(search("mercury"), ["Mercury 3"]);
  });
}
