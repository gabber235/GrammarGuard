import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/providers/gemini_provider.dart";

class ProviderRegistry {
  static const List<AiProvider> _providers = [
    GeminiProvider(),
  ];

  static List<AiProvider> get providers => _providers;

  static AiProvider? getProvider(String name) {
    try {
      return _providers.firstWhere((provider) => provider.name == name);
    } on StateError catch (_) {
      return null;
    }
  }

  static AiProvider get defaultProvider => _providers.first;
}
