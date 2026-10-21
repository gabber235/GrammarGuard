// In lib so demo mode can use it.
import "dart:async";
import "dart:convert";

import "package:dio/dio.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:llm_dart/llm_dart.dart" as llm;

/// A fake LlmGateway. Each chat call takes the next script, so tests and
/// the demo drive rewrites and the assistant with llm_dart's own types.
class ScriptedLlm implements LlmGateway {
  /// Rewrite scripts in order; `open` ones never close after their events.
  final _streams = <({List<llm.ChatStreamEvent> events, bool open})>[];
  final _replies = <llm.ChatResponse>[];
  final _chatErrors = <Object>[];

  /// The system prompt and messages of every call, for asserting.
  final calls = <({String system, List<llm.ChatMessage> messages})>[];

  /// Calls cancelled before they finished.
  int cancelled = 0;
  Duration delay = Duration.zero;

  /// A rewrite: text chunks, then a completion with token counts.
  void reply(List<String> chunks) => _script([
    for (final chunk in chunks) llm.TextDeltaEvent(chunk),
    llm.CompletionEvent(Reply(chunks.join(), usage: const llm.UsageInfo(promptTokens: 120, completionTokens: 30))),
  ]);

  /// Any event sequence, for backends with unusual streams.
  void events(List<llm.ChatStreamEvent> events) => _script(events);

  void _script(List<llm.ChatStreamEvent> events, {bool open = false}) => _streams.add((events: events, open: open));

  void fail(String message) => _script([llm.ErrorEvent(llm.GenericError(message))]);

  /// The next chat call throws [error] before any stream, like a gateway
  /// that cannot be built (a bad base URL).
  void crash(Object error) => _chatErrors.add(error);

  /// Never finishes; for cancel tests.
  void hang() => _script(const [], open: true);

  /// Sends [chunks] (or [thinking] first), then waits forever: a run caught
  /// mid stream, for screenshots of the streaming view.
  void midStream(List<String> chunks, {String thinking = ""}) {
    _script([
      if (thinking.isNotEmpty) llm.ThinkingDeltaEvent(thinking),
      for (final chunk in chunks) llm.TextDeltaEvent(chunk),
    ], open: true);
  }

  /// The assistant's next answer: plain text, or one tool call.
  void says(String text) => _replies.add(Reply(text));

  void callsTool(String name, Map<String, Object?> arguments) => _replies.add(
    Reply(
      "",
      toolCalls: [
        llm.ToolCall(
          id: "call-${_replies.length}",
          callType: "function",
          function: llm.FunctionCall(name: name, arguments: jsonEncodeArgs(arguments)),
        ),
      ],
    ),
  );

  @override
  Future<llm.ChatCapability> chat(
    Connection connection,
    ModelRef model, {
    required String system,
    ModelOptions options = const ModelOptions(),
    bool webSearch = false,
  }) async {
    // Scripts throw whatever a real backend could, Errors included.
    // ignore: only_throw_errors
    if (_chatErrors.isNotEmpty) throw _chatErrors.removeAt(0);
    return _ScriptedChat(this, system);
  }

  @override
  Future<List<llm.AIModel>> models(Connection connection) =>
      throw const llm.InvalidRequestError("Scripted: use the bundled list.");
}

class _ScriptedChat extends llm.ChatCapability {
  _ScriptedChat(this._llm, this._system);

  final ScriptedLlm _llm;
  final String _system;

  @override
  Stream<llm.ChatStreamEvent> chatStream(
    List<llm.ChatMessage> messages, {
    List<llm.Tool>? tools,
    CancelToken? cancelToken,
  }) {
    _llm.calls.add((system: _system, messages: messages));
    final (:events, :open) = _llm._streams.isEmpty
        ? (events: <llm.ChatStreamEvent>[llm.CompletionEvent(Reply("(no script)"))], open: false)
        : _llm._streams.removeAt(0);
    var finished = false;
    late final StreamController<llm.ChatStreamEvent> controller;
    controller = StreamController(
      onListen: () async {
        for (final event in events) {
          await Future<void>.delayed(_llm.delay);
          if (controller.isClosed) return;
          controller.add(event);
        }
        // An open script hangs until cancelled, like a stalled server.
        if (!open) {
          finished = true;
          await controller.close();
        }
      },
      onCancel: () {
        if (!finished) _llm.cancelled++;
      },
    );
    cancelToken?.whenCancel.then((_) => controller.close());
    return controller.stream;
  }

  @override
  Future<llm.ChatResponse> chatWithTools(
    List<llm.ChatMessage> messages,
    List<llm.Tool>? tools, {
    CancelToken? cancelToken,
  }) async {
    _llm.calls.add((system: _system, messages: [...messages]));
    await Future<void>.delayed(_llm.delay);
    return _llm._replies.isEmpty ? Reply("(no script)") : _llm._replies.removeAt(0);
  }
}

/// A plain ChatResponse for scripts.
class Reply implements llm.ChatResponse {
  Reply(this.text, {this.toolCalls, this.usage});

  @override
  final String text;

  @override
  final List<llm.ToolCall>? toolCalls;

  @override
  final llm.UsageInfo? usage;

  @override
  String? get thinking => null;
}

String jsonEncodeArgs(Map<String, Object?> arguments) => const JsonEncoder().convert(arguments);
