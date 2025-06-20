import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/widgets/api_key_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class OllamaProvider extends AiProvider {
  const OllamaProvider();

  @override
  String get name => "ollama";

  @override
  String get displayName => "Ollama";

  String get apiKeyName => "ollama_url";
  String get apiKeyUrl => "https://ollama.ai";
  String get apiKeyHint => "Enter your Ollama server URL";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async => [];

  @override
  Widget buildConfigurationWidget({
    required WidgetRef ref,
  }) {
    return ApiKeyConfiguration(
      providerName: name,
      providerDisplayName: displayName,
      apiKeyUrl: apiKeyUrl,
      apiKeyHint: apiKeyHint,
    );
  }

  @override
  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  }) async* {
    yield const ErrorEvent(error: "Ollama provider not yet implemented");
  }
}
