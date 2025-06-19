import "package:diff_match_patch/diff_match_patch.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/models/prompt.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "ai_rewrite.g.dart";

@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  AiModel build() {
    return ModelRegistry.defaultModel;
  }

  // ignore: use_setters_to_change_properties
  void select(AiModel model) {
    state = model;
  }
}

@riverpod
class AiRewrite extends _$AiRewrite {
  @override
  Stream<String> build() async* {
    final state = ref.watch(grammarStateProvider);
    final currentModel = ref.watch(selectedModelProvider);
    final apiKeys = await ref.read(apiKeyStateProvider.future);

    final apiKey = apiKeys[currentModel.provider.name];
    if (apiKey == null) {
      yield "";
      return;
    }

    final prompt = generateLlmPrompt(
      intensity: state.rewriteIntensity,
      stylingOptions: state.enabledStyling,
    );

    final sb = StringBuffer();

    final stream = await currentModel.provider.generateContent(
      prompt: prompt,
      inputText: state.inputText,
      apiKey: apiKey,
      model: currentModel,
    );

    await for (final chunk in stream) {
      sb.write(chunk);
      yield sb.toString().trim();
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
