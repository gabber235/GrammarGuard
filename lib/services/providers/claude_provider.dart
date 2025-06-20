import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/widgets/api_key_configuration.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;

class ClaudeProvider extends AiProvider {
  const ClaudeProvider();

  @override
  String get name => "claude";

  @override
  String get displayName => "Anthropic Claude";

  String get apiKeyName => "claude_api_key";
  String get apiKeyUrl => "https://console.anthropic.com/";
  String get apiKeyHint => "Enter your Anthropic API key";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    final apiKey = await ref.read(apiKeyProvider(name).future);

    if (apiKey == null || apiKey.isEmpty) {
      return [];
    }

    return [
      AiModel(
        name: "claude-3-5-haiku-20241022",
        displayName: "Claude 3.5 Haiku",
        provider: this,
        pricePerMillionInputTokens: 0.8,
        pricePerMillionOutputTokens: 4,
      ),
      AiModel(
        name: "claude-sonnet-4-20250514",
        displayName: "Claude 4 Sonnet",
        provider: this,
        pricePerMillionInputTokens: 3,
        pricePerMillionOutputTokens: 15,
      ),
      AiModel(
        name: "claude-opus-4-20250514",
        displayName: "Claude 4 Opus",
        provider: this,
        pricePerMillionInputTokens: 15,
        pricePerMillionOutputTokens: 75,
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
      yield const ErrorEvent(error: "Claude API key not configured");
      return;
    }

    yield const LoadingEvent(message: "Connecting to Claude...");

    final provider = await llm
        .ai()
        .anthropic()
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
        // TODO: Wait for fix in llm_dart that fixes usage parsing
        // case llm.CompletionEvent(response: final response):
        // debugPrint("Claude usage: ${response.usage}");
        // if (response.usage != null) {
        //   final usage = response.usage!;
        //   final promptTokenCount = usage.promptTokens ?? 0;
        //   final completionTokenCount = usage.completionTokens ?? 0;

        //   final cost = (promptTokenCount /
        //           1000000 *
        //           model.pricePerMillionInputTokens) +
        //       (completionTokenCount /
        //           1000000 *
        //           model.pricePerMillionOutputTokens);

        //   yield UsageEvent(
        //     usage: RequestUsage(
        //       promptTokenCount: promptTokenCount,
        //       completionTokenCount: completionTokenCount,
        //       modelName: model.name,
        //       providerName: model.provider.name,
        //       cost: cost,
        //     ),
        //   );
        // }
        case llm.ErrorEvent(error: final error):
          yield ErrorEvent(error: error.message);
        default:
          break;
      }
    }
  }
}
