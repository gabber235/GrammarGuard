import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/state/ai_usage.dart";

abstract class AiProvider {
  const AiProvider();

  String get name;
  String get displayName;
  String get apiKeyName;
  String get apiKeyUrl;
  String get apiKeyHint;

  Future<Stream<String>> generateContent({
    required String prompt,
    required String inputText,
    required String apiKey,
    required AiModel model,
  });

  Future<RequestUsage?> getUsageMetadata(dynamic response, AiModel model);
}

class AiResponse {
  const AiResponse({
    required this.text,
    this.usageMetadata,
  });

  final String text;
  final RequestUsage? usageMetadata;
}
