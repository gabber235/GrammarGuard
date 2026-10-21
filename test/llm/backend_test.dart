import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:llm_dart/llm_dart.dart" as llm;

void main() {
  test("every llm_dart chat provider has a Backend", () {
    // Audio only, or a second route to a backend we already have.
    const notChat = {"elevenlabs"};
    final covered = {for (final backend in Backend.values) backend.name};
    final registered = llm.LLMProviderRegistry.getRegisteredProviders().where(
      (id) => !notChat.contains(id) && !id.endsWith("-openai"),
    );
    expect(
      registered.toSet().difference(covered),
      isEmpty,
      reason: "llm_dart gained a provider: add it to Backend and LlmDartGateway._builder.",
    );
  });
}
