import "package:diff_match_patch/diff_match_patch.dart";
import "package:google_generative_ai/google_generative_ai.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/prompt.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "ai_rewrite.g.dart";

enum Models {
  gemini25ProExp0325("gemini-2.5-pro-exp-03-25"),
  gemini20Flash("gemini-2.0-flash");

  const Models(this.name);
  final String name;
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
    final model = GenerativeModel(
      model: Models.gemini20Flash.name,
      apiKey: apiKey,
    );

    final prompt = generateLlmPrompt(
      selectedText: state.inputText,
      intensity: state.rewriteIntensity,
      stylingOptions: state.enabledStyling,
    );

    final content = [Content.text(prompt)];
    var text = "";
    await for (final data in model.generateContentStream(content)) {
      final t = data.text;
      if (t != null) {
        text += t;
      }
      yield text;
    }
  }
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
