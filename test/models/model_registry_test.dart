import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class MockAiProvider extends AiProvider {
  const MockAiProvider({required this.providerName, this.displayNameOverride});

  final String providerName;
  final String? displayNameOverride;

  @override
  String get name => providerName;

  @override
  String get displayName => displayNameOverride ?? providerName;

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async => [];

  @override
  Widget buildConfigurationWidget({required WidgetRef ref}) {
    return const SizedBox();
  }

  @override
  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  }) async* {}
}

void main() {
  group("AiModel", () {
    late MockAiProvider mockProvider;

    setUp(() {
      mockProvider = const MockAiProvider(providerName: "test-provider");
    });

    group("creation", () {
      test("creates with all required fields", () {
        final model = AiModel(
          name: "gpt-4",
          displayName: "GPT-4",
          provider: mockProvider,
          pricePerMillionInputTokens: 10.0,
          pricePerMillionOutputTokens: 30.0,
        );

        expect(model.name, equals("gpt-4"));
        expect(model.displayName, equals("GPT-4"));
        expect(model.provider, equals(mockProvider));
        expect(model.pricePerMillionInputTokens, equals(10.0));
        expect(model.pricePerMillionOutputTokens, equals(30.0));
      });

      test("creates with zero pricing", () {
        final model = AiModel(
          name: "free-model",
          displayName: "Free Model",
          provider: mockProvider,
          pricePerMillionInputTokens: 0.0,
          pricePerMillionOutputTokens: 0.0,
        );

        expect(model.pricePerMillionInputTokens, equals(0.0));
        expect(model.pricePerMillionOutputTokens, equals(0.0));
      });
    });

    group("equality", () {
      test("models with same name and provider are equal", () {
        final model1 = AiModel(
          name: "gpt-4",
          displayName: "GPT-4",
          provider: mockProvider,
          pricePerMillionInputTokens: 10.0,
          pricePerMillionOutputTokens: 30.0,
        );

        final model2 = AiModel(
          name: "gpt-4",
          displayName: "GPT-4 Turbo",
          provider: mockProvider,
          pricePerMillionInputTokens: 5.0,
          pricePerMillionOutputTokens: 15.0,
        );

        expect(model1, equals(model2));
      });

      test("models with different names are not equal", () {
        final model1 = AiModel(
          name: "gpt-4",
          displayName: "GPT-4",
          provider: mockProvider,
          pricePerMillionInputTokens: 10.0,
          pricePerMillionOutputTokens: 30.0,
        );

        final model2 = AiModel(
          name: "gpt-3.5-turbo",
          displayName: "GPT-3.5 Turbo",
          provider: mockProvider,
          pricePerMillionInputTokens: 0.5,
          pricePerMillionOutputTokens: 1.5,
        );

        expect(model1, isNot(equals(model2)));
      });

      test("models with different providers are not equal", () {
        const otherProvider = MockAiProvider(providerName: "other-provider");

        final model1 = AiModel(
          name: "model",
          displayName: "Model",
          provider: mockProvider,
          pricePerMillionInputTokens: 1.0,
          pricePerMillionOutputTokens: 2.0,
        );

        final model2 = AiModel(
          name: "model",
          displayName: "Model",
          provider: otherProvider,
          pricePerMillionInputTokens: 1.0,
          pricePerMillionOutputTokens: 2.0,
        );

        expect(model1, isNot(equals(model2)));
      });
    });

    group("hashCode", () {
      test("equal models have same hashCode", () {
        final model1 = AiModel(
          name: "test",
          displayName: "Test",
          provider: mockProvider,
          pricePerMillionInputTokens: 1.0,
          pricePerMillionOutputTokens: 2.0,
        );

        final model2 = AiModel(
          name: "test",
          displayName: "Test Different",
          provider: mockProvider,
          pricePerMillionInputTokens: 3.0,
          pricePerMillionOutputTokens: 4.0,
        );

        expect(model1.hashCode, equals(model2.hashCode));
      });
    });

    group("toString", () {
      test("produces readable string representation", () {
        final model = AiModel(
          name: "gemini-pro",
          displayName: "Gemini Pro",
          provider: mockProvider,
          pricePerMillionInputTokens: 1.25,
          pricePerMillionOutputTokens: 2.5,
        );

        final str = model.toString();

        expect(str, contains("gemini-pro"));
        expect(str, contains("test-provider"));
      });
    });
  });

  group("Model filtering", () {
    test("filter models by provider name", () {
      const provider1 = MockAiProvider(providerName: "openai");
      const provider2 = MockAiProvider(providerName: "anthropic");

      final models = [
        AiModel(
          name: "gpt-4",
          displayName: "GPT-4",
          provider: provider1,
          pricePerMillionInputTokens: 10.0,
          pricePerMillionOutputTokens: 30.0,
        ),
        AiModel(
          name: "gpt-3.5",
          displayName: "GPT-3.5",
          provider: provider1,
          pricePerMillionInputTokens: 0.5,
          pricePerMillionOutputTokens: 1.5,
        ),
        AiModel(
          name: "claude-3",
          displayName: "Claude 3",
          provider: provider2,
          pricePerMillionInputTokens: 15.0,
          pricePerMillionOutputTokens: 75.0,
        ),
      ];

      final openaiModels = models
          .where((m) => m.provider.name == "openai")
          .toList();

      expect(openaiModels.length, equals(2));
      expect(openaiModels.every((m) => m.provider.name == "openai"), isTrue);
    });

    test("filter models by configured providers", () {
      const provider1 = MockAiProvider(providerName: "openai");
      const provider2 = MockAiProvider(providerName: "anthropic");
      const provider3 = MockAiProvider(providerName: "google");

      final models = [
        AiModel(
          name: "gpt-4",
          displayName: "GPT-4",
          provider: provider1,
          pricePerMillionInputTokens: 10.0,
          pricePerMillionOutputTokens: 30.0,
        ),
        AiModel(
          name: "claude-3",
          displayName: "Claude 3",
          provider: provider2,
          pricePerMillionInputTokens: 15.0,
          pricePerMillionOutputTokens: 75.0,
        ),
        AiModel(
          name: "gemini-pro",
          displayName: "Gemini Pro",
          provider: provider3,
          pricePerMillionInputTokens: 1.25,
          pricePerMillionOutputTokens: 2.5,
        ),
      ];

      final configuredProviders = {"openai", "google"};

      final configuredModels = models
          .where((m) => configuredProviders.contains(m.provider.name))
          .toList();

      expect(configuredModels.length, equals(2));
      expect(configuredModels.any((m) => m.name == "gpt-4"), isTrue);
      expect(configuredModels.any((m) => m.name == "gemini-pro"), isTrue);
      expect(configuredModels.any((m) => m.name == "claude-3"), isFalse);
    });

    test("find model by name", () {
      const provider = MockAiProvider(providerName: "test");

      final models = [
        AiModel(
          name: "model-a",
          displayName: "Model A",
          provider: provider,
          pricePerMillionInputTokens: 1.0,
          pricePerMillionOutputTokens: 2.0,
        ),
        AiModel(
          name: "model-b",
          displayName: "Model B",
          provider: provider,
          pricePerMillionInputTokens: 3.0,
          pricePerMillionOutputTokens: 4.0,
        ),
      ];

      final found = models.where((m) => m.name == "model-b").firstOrNull;

      expect(found, isNotNull);
      expect(found!.name, equals("model-b"));
    });

    test("find model by name returns null when not found", () {
      const provider = MockAiProvider(providerName: "test");

      final models = [
        AiModel(
          name: "model-a",
          displayName: "Model A",
          provider: provider,
          pricePerMillionInputTokens: 1.0,
          pricePerMillionOutputTokens: 2.0,
        ),
      ];

      final found = models.where((m) => m.name == "nonexistent").firstOrNull;

      expect(found, isNull);
    });
  });

  group("AiProvider", () {
    test("mock provider returns correct name", () {
      const provider = MockAiProvider(providerName: "gemini");

      expect(provider.name, equals("gemini"));
    });

    test("mock provider returns correct display name", () {
      const provider = MockAiProvider(
        providerName: "gemini",
        displayNameOverride: "Google Gemini",
      );

      expect(provider.displayName, equals("Google Gemini"));
    });

    test("mock provider defaults display name to provider name", () {
      const provider = MockAiProvider(providerName: "openai");

      expect(provider.displayName, equals("openai"));
    });
  });
}
