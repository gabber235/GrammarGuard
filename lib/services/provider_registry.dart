import "package:collection/collection.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/providers/claude_provider.dart";
import "package:grammar_guard/services/providers/gemini_provider.dart";
import "package:grammar_guard/services/providers/ollama_provider.dart";
import "package:grammar_guard/services/providers/openai_provider.dart";
import "package:grammar_guard/services/providers/openrouter_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "provider_registry.g.dart";

@Riverpod(keepAlive: true)
class ProviderRegistry extends _$ProviderRegistry {
  @override
  List<AiProvider> build() {
    return [
      GeminiProvider(),
      OpenAiProvider(),
      ClaudeProvider(),
      OpenRouterProvider(),
      OllamaProvider(),
    ];
  }
}

@Riverpod(keepAlive: true)
AiProvider? provider(Ref ref, String name) {
  final providers = ref.watch(providerRegistryProvider);
  return providers.firstWhereOrNull((provider) => provider.name == name);
}
