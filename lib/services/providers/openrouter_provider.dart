import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/widgets/api_key_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;

class OpenRouterProvider extends AiProvider {
  const OpenRouterProvider();

  @override
  String get name => "openrouter";

  @override
  String get displayName => "OpenRouter";

  String get apiKeyUrl => "https://openrouter.ai/keys";
  String get apiKeyHint => "Enter your OpenRouter API key";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    final apiKey = await ref.read(apiKeyProvider(name).future);

    if (apiKey == null || apiKey.isEmpty) {
      return [];
    }

    return [
      AiModel(
        name: "openai/gpt-oss-120b",
        displayName: "OpenRouter GPT-oss-120B",
        provider: this,
        pricePerMillionInputTokens: 0.35,
        pricePerMillionOutputTokens: 0.75,
      ),
    ];
  }

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
    yield const LoadingEvent(message: "Reading API key...");
    final apiKey = await ref.read(apiKeyProvider(name).future);

    if (apiKey == null || apiKey.isEmpty) {
      yield const ErrorEvent(error: "OpenRouter API key not configured");
      return;
    }

    yield const LoadingEvent(message: "Connecting to OpenRouter...");

    final provider = await llm
        .ai()
        .openRouter()
        .apiKey(apiKey)
        .model(model.name)
        .systemPrompt(prompt)
        .build();

    yield const LoadingEvent(message: "Generating content...");

    final messages = [
      llm.ChatMessage.user(inputText),
    ];

    final stream = provider.chatStream(messages);

    await for (final event in stream) {
      switch (event) {
        case llm.ThinkingDeltaEvent(delta: final delta):
          yield ThinkingDeltaEvent(delta: delta);
        case llm.TextDeltaEvent(delta: final delta):
          yield TextDeltaEvent(delta: delta);
        case llm.CompletionEvent(response: final response):
          debugPrint(
            "OpenRouter response: ${response.text}, usage: ${response.usage}",
          );
          if (response.usage != null) {
            final usage = response.usage!;
            final promptTokenCount = usage.promptTokens ?? 0;
            final completionTokenCount = usage.completionTokens ?? 0;

            final cost = (promptTokenCount /
                    1000000 *
                    model.pricePerMillionInputTokens) +
                (completionTokenCount /
                    1000000 *
                    model.pricePerMillionOutputTokens);

            yield UsageEvent(
              usage: RequestUsage(
                promptTokenCount: promptTokenCount,
                completionTokenCount: completionTokenCount,
                modelName: model.name,
                providerName: model.provider.name,
                cost: cost,
              ),
            );
          }
        case llm.ErrorEvent(error: final error):
          yield ErrorEvent(error: error.message);
        default:
          break;
      }
    }
  }
}
