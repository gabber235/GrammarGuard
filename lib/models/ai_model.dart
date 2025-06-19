import "package:grammar_guard/services/ai_provider.dart";

class AiModel {
  const AiModel({
    required this.name,
    required this.displayName,
    required this.provider,
    required this.pricePerMillionInputTokens,
    required this.pricePerMillionOutputTokens,
  });

  final String name;
  final String displayName;
  final AiProvider provider;
  final double pricePerMillionInputTokens;
  final double pricePerMillionOutputTokens;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiModel &&
        other.name == name &&
        other.provider.name == provider.name;
  }

  @override
  int get hashCode => Object.hash(name, provider.name);

  @override
  String toString() => "AiModel(name: $name, provider: ${provider.name})";
}
