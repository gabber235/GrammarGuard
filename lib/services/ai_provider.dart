import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

abstract class AiProvider {
  const AiProvider();

  String get name;
  String get displayName;

  Future<List<AiModel>> fetchAvailableModels(Ref ref);

  Widget buildConfigurationWidget({
    required WidgetRef ref,
  });

  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  });
}
