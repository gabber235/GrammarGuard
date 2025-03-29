import "package:diff_match_patch/diff_match_patch.dart";
import "package:google_generative_ai/google_generative_ai.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/prompt.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "ai_rewrite.g.dart";

enum Model {
  gemini25ProExp0325(
    "gemini-2.5-pro-exp-03-25",
    displayName: "Gemini 2.5 Pro",
    pricePerMillionInputTokens: 0,
    pricePerMillionOutputTokens: 0,
  ),
  gemini20Flash(
    "gemini-2.0-flash",
    displayName: "Gemini 2.0 Flash",
    pricePerMillionInputTokens: 0.1,
    pricePerMillionOutputTokens: 0.4,
  );

  const Model(
    this.name, {
    required this.displayName,
    required this.pricePerMillionInputTokens,
    required this.pricePerMillionOutputTokens,
  });
  final String name;
  final String displayName;
  final double pricePerMillionInputTokens;
  final double pricePerMillionOutputTokens;
}

@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  Model build() {
    return Model.gemini20Flash;
  }

  // ignore: use_setters_to_change_properties
  void select(Model model) {
    state = model;
  }
}

@riverpod
class AiRewrite extends _$AiRewrite {
  @override
  Stream<String> build() async* {
    final state = ref.watch(grammarStateProvider);
    final apiKey = await ref.read(apiKeyStateProvider.future);
    if (apiKey == null) {
      yield "";
      return;
    }
    final currentModel = ref.watch(selectedModelProvider);
    final model = GenerativeModel(model: currentModel.name, apiKey: apiKey);

    final prompt = generateLlmPrompt(
      selectedText: state.inputText,
      intensity: state.rewriteIntensity,
      stylingOptions: state.enabledStyling,
    );

    final content = [Content.text(prompt)];
    final id = generateId();
    var text = "";
    await for (final data in model.generateContentStream(content)) {
      final usage = data.usageMetadata;
      if (usage != null) {
        ref
            .read(aiUsageProvider.notifier)
            .recordUsage(
              id,
              RequestUsage(
                promptTokenCount: usage.promptTokenCount ?? 0,
                completionTokenCount: usage.candidatesTokenCount ?? 0,
                model: currentModel,
              ),
            );
      }
      final t = data.text;
      if (t != null) {
        text += t;
      }
      yield text;
    }
  }
}

String generateId() {
  return DateTime.now().toIso8601String();
}

@riverpod
List<Diff> diffs(Ref ref) {
  final originalText = ref.watch(
    grammarStateProvider.select((s) => s.inputText),
  );

  final rewrittenText = ref.watch(aiRewriteProvider).valueOrNull;
  if (rewrittenText == null) {
    return [Diff(0, originalText)];
  }
  final diffOption = ref.watch(diffOptionProvider);
  if (diffOption == DiffOptions.none) {
    return [Diff(0, rewrittenText)];
  }

  final dmp = DiffMatchPatch()..diffTimeout = 3.0;
  final diffs = dmp.diff(originalText.trim(), rewrittenText.trim());
  dmp.diffCleanupSemantic(diffs);

  return diffs.where((diff) {
    return switch (diff.operation) {
      DIFF_INSERT => diffOption.showAdditions,
      DIFF_DELETE => diffOption.showDeletions,
      _ => true,
    };
  }).toList();
}

@riverpod
String diffString(Ref ref) {
  final diffs = ref.watch(diffsProvider);

  final sb = StringBuffer();
  for (final diff in diffs) {
    switch (diff.operation) {
      case DIFF_INSERT:
        sb.write("<insert>${diff.text}</insert>");
      case DIFF_DELETE:
        sb.write("<delete>${diff.text}</delete>");
      case DIFF_EQUAL:
        sb.write(diff.text);
    }
  }

  return sb.toString();
}
