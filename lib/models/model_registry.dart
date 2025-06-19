import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/providers/gemini_provider.dart";

class ModelRegistry {
  static final List<AiModel> _models = [
    AiModel(
      name: "gemini-2.5-pro-exp-03-25",
      displayName: "Gemini 2.5 Pro",
      provider: GeminiProvider(),
      pricePerMillionInputTokens: 1.25,
      pricePerMillionOutputTokens: 2.5,
    ),
    AiModel(
      name: "gemini-2.0-flash",
      displayName: "Gemini 2.0 Flash",
      provider: GeminiProvider(),
      pricePerMillionInputTokens: 0.1,
      pricePerMillionOutputTokens: 0.4,
    ),
    AiModel(
      name: "gemini-2.5-flash-preview-04-17",
      displayName: "Gemini 2.5 Flash",
      provider: GeminiProvider(),
      pricePerMillionInputTokens: 0.15,
      pricePerMillionOutputTokens: 0.6,
    ),
  ];

  static List<AiModel> get models => _models;

  static AiModel? getModel(String name) {
    try {
      return _models.firstWhere((model) => model.name == name);
    } on Exception catch (_) {
      return null;
    }
  }

  static AiModel get defaultModel => _models.firstWhere(
        (model) => model.name == "gemini-2.0-flash",
      );

  static List<AiModel> getModelsForProvider(String providerName) {
    return _models
        .where((model) => model.provider.name == providerName)
        .toList();
  }
}
