import "package:diff_match_patch/diff_match_patch.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/models/prompt.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_rewrite_result.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "ai_rewrite.g.dart";

const _selectedModelKey = "selected_model_name";

@Riverpod(keepAlive: true)
class SelectedModel extends _$SelectedModel {
  @override
  Future<AiModel?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final modelName = prefs.getString(_selectedModelKey);
    if (modelName == null) {
      return ref.watch(defaultModelProvider);
    }

    return ref.watch(modelProvider(modelName).future);
  }

  Future<void> select(AiModel model) async {
    state = AsyncValue.data(model);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedModelKey, model.name);
  }
}

@riverpod
class AiRewrite extends _$AiRewrite {
  @override
  Stream<AiRewriteResult> build() async* {
    final state = ref.watch(grammarStateProvider);
    final currentModel = ref.watch(selectedModelProvider);

    yield* currentModel.when(
      data: (model) async* {
        if (model == null) {
          yield const TextResult(text: "");
          return;
        }

        final prompt = generateLlmPrompt(
          intensity: state.rewriteIntensity,
          stylingOptions: state.enabledStyling,
        );

        final stream = model.provider.generateContent(
          prompt: prompt,
          inputText: state.inputText,
          model: model,
          ref: ref,
        );

        final sb = StringBuffer();
        final thinkingSb = StringBuffer();

        await for (final event in stream) {
          switch (event) {
            case LoadingEvent(message: final message):
              yield LoadingResult(message: message);
            case ThinkingDeltaEvent(delta: final delta):
              thinkingSb.write(delta);
              yield ThinkingTextResult(
                thinking: thinkingSb.toString(),
                text: sb.toString(),
              );
            case TextDeltaEvent(delta: final delta):
              sb.write(delta);
              if (thinkingSb.isNotEmpty) {
                yield ThinkingTextResult(
                  thinking: thinkingSb.toString(),
                  text: sb.toString(),
                );
              } else {
                yield TextResult(text: sb.toString());
              }
            case UsageEvent(usage: final usage):
              final id = generateId();
              await ref.read(aiUsageProvider.notifier).recordUsage(
                    id,
                    usage.modelName,
                    usage.promptTokenCount,
                    usage.completionTokenCount,
                    usage.providerName,
                  );
            case ErrorEvent(error: final error):
              yield ErrorResult(message: error);
          }
        }
      },
      loading: () async* {
        yield const LoadingResult(message: "Loading model...");
      },
      error: (err, stack) async* {
        yield ErrorResult(message: "Failed to load model: $err");
      },
    );
  }
}

String generateId() {
  return DateTime.now().toIso8601String();
}

@riverpod
List<Diff> diffs(Ref ref) {
  final originalText = ref.watch(grammarStateProvider).inputText;

  final rewriteResult = ref.watch(aiRewriteProvider).value;
  if (rewriteResult == null) {
    return [Diff(0, originalText)];
  }

  final rewrittenText = switch (rewriteResult) {
    LoadingResult() => null,
    ErrorResult() => null,
    TextResult(text: final text) => text,
    ThinkingTextResult(text: final text) => text,
  };

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
