import "package:google_generative_ai/google_generative_ai.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/state/ai_usage.dart";

class GeminiProvider extends AiProvider {
  const GeminiProvider();

  @override
  String get name => "gemini";

  @override
  String get displayName => "Google Gemini";

  @override
  String get apiKeyName => "gemini_api_key";

  @override
  String get apiKeyUrl => "https://makersuite.google.com/app/apikey";

  @override
  String get apiKeyHint => "Enter your Gemini API key";

  @override
  Future<Stream<String>> generateContent({
    required String prompt,
    required String inputText,
    required String apiKey,
    required AiModel model,
  }) async {
    final generativeModel = GenerativeModel(model: model.name, apiKey: apiKey);
    final content = [Content.text(prompt), Content.text(inputText)];

    return generativeModel.generateContentStream(content).map((data) {
      return data.text ?? "";
    });
  }

  @override
  Future<RequestUsage?> getUsageMetadata(
    dynamic response,
    AiModel model,
  ) async {
    if (response is GenerateContentResponse) {
      final usage = response.usageMetadata;
      if (usage != null) {
        final promptTokenCount = usage.promptTokenCount ?? 0;
        final completionTokenCount = usage.candidatesTokenCount ?? 0;

        final cost =
            (promptTokenCount / 1000000 * model.pricePerMillionInputTokens) +
                (completionTokenCount /
                    1000000 *
                    model.pricePerMillionOutputTokens);

        return RequestUsage(
          promptTokenCount: promptTokenCount,
          completionTokenCount: completionTokenCount,
          modelName: model.name,
          providerName: model.provider.name,
          cost: cost,
        );
      }
    }
    return null;
  }
}
