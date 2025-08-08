import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/widgets/api_key_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;

class OpenAiProvider extends AiProvider {
  const OpenAiProvider();

  @override
  String get name => "openai";

  @override
  String get displayName => "OpenAI";

  String get apiKeyName => "openai_api_key";
  String get apiKeyUrl => "https://platform.openai.com/api-keys";
  String get apiKeyHint => "Enter your OpenAI API key";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    final apiKey = await ref.read(apiKeyProvider(name).future);

    if (apiKey == null || apiKey.isEmpty) {
      return [];
    }

    return [
      AiModel(
        name: "gpt-5-nano",
        displayName: "GPT-5 Nano",
        provider: this,
        pricePerMillionInputTokens: 0.05,
        pricePerMillionOutputTokens: 0.4,
      ),
      AiModel(
        name: "gpt-5-mini",
        displayName: "GPT-5 Mini",
        provider: this,
        pricePerMillionInputTokens: 0.25,
        pricePerMillionOutputTokens: 2,
      ),
      AiModel(
        name: "gpt-5",
        displayName: "GPT-5",
        provider: this,
        pricePerMillionInputTokens: 1.25,
        pricePerMillionOutputTokens: 10,
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
      yield const ErrorEvent(error: "OpenAI API key not configured");
      return;
    }

    yield const LoadingEvent(message: "Connecting to OpenAI...");

    final provider = await llm
        .ai()
        .openai()
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
            "OpenAI response: ${response.text}, usage: ${response.usage}",
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
