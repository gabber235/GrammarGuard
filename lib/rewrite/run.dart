import "dart:math";

import "package:clock/clock.dart";
import "package:dio/dio.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/prompt.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/rewrite/text_edges.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "run.freezed.dart";
part "run.g.dart";

/// Everything that decides a rewrite. Equal requests share one run, so
/// stepping 2, 3, 2 reuses the first result instead of paying again.
@freezed
abstract class RunRequest with _$RunRequest {
  const factory RunRequest({
    required ModelInfo model,
    required Prompt prompt,
    required ModelOptions options,

    /// The captured text, used to restore its outer whitespace.
    required String input,
  }) = _RunRequest;
}

@freezed
sealed class RunState with _$RunState {
  const RunState._();

  const factory RunState.waiting({required DateTime startedAt}) = Waiting;

  const factory RunState.streaming({
    required DateTime startedAt,
    required String text,
    required String thinking,

    /// Null while the model is still thinking.
    Duration? firstTokenAfter,
  }) = Streaming;

  const factory RunState.done({
    required DateTime startedAt,
    required String text,
    required String thinking,
    required Duration took,
    required llm.UsageInfo usage,

    /// Null when the model's price is unknown.
    required double? cost,
    Duration? firstTokenAfter,
  }) = Done;

  const factory RunState.failed({required DateTime startedAt, required String message}) = Failed;

  bool get isActive => this is Waiting || this is Streaming;
}

extension DoneStats on Done {
  double get tokensPerSecond =>
      took.inMilliseconds == 0 ? 0 : (usage.completionTokens ?? 0) / (took.inMilliseconds / 1000);
}

/// One model call. Auto dispose cancels the request when nobody watches it
/// (another instruction picked, Esc, window closed). A finished run keeps
/// itself alive as the cache until the session invalidates the family.
@riverpod
class Run extends _$Run {
  @override
  Stream<RunState> build(RunRequest request) {
    // Registered before the stream starts: a run can be dropped before its
    // first event when the user switches instructions quickly.
    final cancel = CancelToken();
    ref.onDispose(cancel.cancel);
    return _run(request, cancel);
  }

  Stream<RunState> _run(RunRequest request, CancelToken cancel) async* {
    final startedAt = clock.now();
    final stopwatch = clock.stopwatch()..start();
    yield RunState.waiting(startedAt: startedAt);

    final text = StringBuffer();
    final thinking = StringBuffer();
    Duration? firstToken;
    // Some backends send several completion events (llm_dart's Anthropic
    // stream sends one at the start with the input count and one at the end
    // with the output count), so counts are merged and the run ends when the
    // stream does.
    var completed = false;
    var promptTokens = 0;
    var completionTokens = 0;
    try {
      final connection = (await ref.read(connectionsProvider.future))[request.model.ref.backend]!;
      if (!ref.mounted) return;
      final chat = await ref
          .read(llmGatewayProvider)
          .chat(connection, request.model.ref, system: request.prompt.system, options: request.options);
      await for (final event in chat.chatStream([llm.ChatMessage.user(request.prompt.user)], cancelToken: cancel)) {
        switch (event) {
          case llm.ThinkingDeltaEvent(:final delta):
            thinking.write(delta);
          case llm.TextDeltaEvent(:final delta):
            firstToken ??= stopwatch.elapsed;
            text.write(delta);
          case llm.CompletionEvent(:final response):
            completed = true;
            promptTokens = max(promptTokens, response.usage?.promptTokens ?? 0);
            completionTokens = max(completionTokens, response.usage?.completionTokens ?? 0);
            continue;
          case llm.ErrorEvent(:final error):
            yield RunState.failed(startedAt: startedAt, message: error.message);
            return;
          case llm.ToolCallDeltaEvent():
            continue;
        }
        yield RunState.streaming(
          startedAt: startedAt,
          text: text.toString(),
          thinking: thinking.toString(),
          firstTokenAfter: firstToken,
        );
      }
      if (!completed) {
        yield RunState.failed(startedAt: startedAt, message: "The model stopped without finishing.");
        return;
      }

      final output = restoreEdges(request.input, unwrapText(text.toString()));
      // Ollama and Apple report no tokens: estimate 4 characters a token for
      // whatever is missing.
      final usage = llm.UsageInfo(
        promptTokens: promptTokens > 0
            ? promptTokens
            : (request.prompt.system.length + request.prompt.user.length) ~/ 4,
        completionTokens: completionTokens > 0 ? completionTokens : output.length ~/ 4,
      );
      final cost = request.model.price?.cost(usage);
      if (!ref.mounted) return;
      ref.keepAlive();
      await ref.read(usageTotalsProvider.notifier).add(usage, cost);
      yield RunState.done(
        startedAt: startedAt,
        text: output,
        thinking: thinking.toString(),
        took: stopwatch.elapsed,
        firstTokenAfter: firstToken,
        usage: usage,
        cost: cost,
      );
    } on llm.LLMError catch (error) {
      yield RunState.failed(startedAt: startedAt, message: error.message);
    } on Object catch (error) {
      // Anything else (a bad base URL, a response llm_dart cannot parse)
      // must still end the run, or the window would say "Writing…" forever.
      yield RunState.failed(startedAt: startedAt, message: "$error");
    }
  }
}
