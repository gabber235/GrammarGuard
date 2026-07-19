import "dart:developer" as developer;

import "package:diff_match_patch/diff_match_patch.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/diff_option.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/models/prompt.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_rewrite_result.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:grammar_guard/state/generation_stats.dart";
import "package:grammar_guard/state/grammar_state.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "ai_rewrite.g.dart";

const _selectedModelKey = "selected_model_name";

@Riverpod(keepAlive: true)
class RewriteGenerationActivity extends _$RewriteGenerationActivity {
  int _activeGenerationCount = 0;

  void _log(String message) {
    developer.log(message, name: "rewrite_activity");
  }

  @override
  bool build() {
    _log("build initial activity false");
    return false;
  }

  void started() {
    _activeGenerationCount += 1;
    state = _activeGenerationCount > 0;
    _log("started count=$_activeGenerationCount state=$state");
  }

  void finished() {
    _activeGenerationCount -= 1;
    if (_activeGenerationCount < 0) {
      _activeGenerationCount = 0;
    }
    state = _activeGenerationCount > 0;
    _log("finished count=$_activeGenerationCount state=$state");
  }
}

@Riverpod(keepAlive: true)
class SelectedModel extends _$SelectedModel {
  @override
  Future<AiModel?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final modelName = prefs.getString(_selectedModelKey);
    if (modelName == null) {
      return ref.watch(defaultModelProvider);
    }

    final selectedModel = await ref.watch(modelProvider(modelName).future);
    if (selectedModel != null) {
      return selectedModel;
    }

    final defaultModel = ref.watch(defaultModelProvider);
    if (defaultModel == null) {
      await prefs.remove(_selectedModelKey);
      return null;
    }

    await prefs.setString(_selectedModelKey, defaultModel.name);
    return defaultModel;
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
    final activity = ref.read(rewriteGenerationActivityProvider.notifier);
    final stats = ref.read(generationStatsProvider.notifier);
    activity.started();
    stats.start();
    final state = ref.watch(grammarStateProvider);
    final currentModel = ref.watch(selectedModelProvider);

    try {
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
                stats.recordTextDelta(delta);
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
                stats.recordUsage(usage);
                final id = generateId();
                await ref
                    .read(aiUsageProvider.notifier)
                    .recordUsage(
                      id,
                      usage.modelName,
                      usage.promptTokenCount,
                      usage.completionTokenCount,
                      usage.providerName,
                    );
              case ErrorEvent(error: final error):
                stats.markError();
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
    } finally {
      stats.finish();
      activity.finished();
    }
  }
}

String generateId() {
  return DateTime.now().toIso8601String();
}

List<Diff> _computeRawDiffs(Ref ref) {
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

  final dmp = DiffMatchPatch()..diffTimeout = 3.0;
  final diffs = dmp.diff(originalText.trim(), rewrittenText.trim());
  dmp.diffCleanupSemantic(diffs);

  return diffs;
}

@riverpod
List<Diff> diffs(Ref ref) {
  final diffOption = ref.watch(diffOptionProvider);

  if (diffOption == DiffOptions.none) {
    final rewriteResult = ref.watch(aiRewriteProvider).value;
    final rewrittenText = switch (rewriteResult) {
      null => "",
      LoadingResult() => "",
      ErrorResult() => "",
      TextResult(text: final text) => text,
      ThinkingTextResult(text: final text) => text,
    };
    return [Diff(0, rewrittenText)];
  }

  if (diffOption == DiffOptions.sideBySide) {
    return _computeRawDiffs(ref);
  }

  final diffs = _computeRawDiffs(ref);

  return diffs.where((diff) {
    return switch (diff.operation) {
      DIFF_INSERT => diffOption.showAdditions,
      DIFF_DELETE => diffOption.showDeletions,
      _ => true,
    };
  }).toList();
}

@riverpod
List<Diff> leftPanelDiffs(Ref ref) {
  final diffs = _computeRawDiffs(ref);

  return diffs.where((diff) {
    return diff.operation != DIFF_INSERT;
  }).toList();
}

@riverpod
List<Diff> rightPanelDiffs(Ref ref) {
  final diffs = _computeRawDiffs(ref);

  return diffs.where((diff) {
    return diff.operation != DIFF_DELETE;
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

@riverpod
String leftPanelDiffString(Ref ref) {
  final diffs = ref.watch(leftPanelDiffsProvider);

  final sb = StringBuffer();
  for (final diff in diffs) {
    switch (diff.operation) {
      case DIFF_DELETE:
        sb.write("<delete>${diff.text}</delete>");
      case DIFF_EQUAL:
        sb.write(diff.text);
      case DIFF_INSERT:
        break;
    }
  }

  return sb.toString();
}

@riverpod
String rightPanelDiffString(Ref ref) {
  final diffs = ref.watch(rightPanelDiffsProvider);

  final sb = StringBuffer();
  for (final diff in diffs) {
    switch (diff.operation) {
      case DIFF_INSERT:
        sb.write("<insert>${diff.text}</insert>");
      case DIFF_EQUAL:
        sb.write(diff.text);
      case DIFF_DELETE:
        break;
    }
  }

  return sb.toString();
}
