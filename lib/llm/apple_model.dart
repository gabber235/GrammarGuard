import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/services.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "apple_model.g.dart";

const _methods = MethodChannel("grammar_guard/apple_model");

/// Every run's events on one platform subscription, each tagged with its
/// run's id. A new run can start before the old one is disposed; with a
/// listen and cancel per run on one channel, the old cancel would end the
/// new run.
final _events = const EventChannel("grammar_guard/apple_model/stream").receiveBroadcastStream();
var _nextRun = 0;

/// macOS 26 on Apple silicon with Apple Intelligence on. A provider so
/// tests can answer it: an unanswered platform channel never completes.
@Riverpod(keepAlive: true)
Future<bool> appleModelAvailable(Ref ref) async {
  if (!Platform.isMacOS) return false;
  try {
    return await _methods.invokeMethod<bool>("isAvailable") ?? false;
  } on MissingPluginException {
    return false;
  }
}

/// Apple's on-device model as an llm_dart ChatCapability, so Run treats it
/// like any other backend. Free and private: a new user can start without
/// an API key. No tool calls, so it cannot run the assistant.
class AppleChat extends llm.ChatCapability {
  AppleChat({required this.system});

  final String system;

  @override
  Stream<llm.ChatStreamEvent> chatStream(
    List<llm.ChatMessage> messages, {
    List<llm.Tool>? tools,
    CancelToken? cancelToken,
  }) {
    final user = messages.lastWhere((m) => m.role == llm.ChatRole.user).content;
    final id = _nextRun++;
    final text = StringBuffer();
    // A controller rather than async*: an async* body waiting for the next
    // event would only see a cancel once that event arrives.
    final out = StreamController<llm.ChatStreamEvent>();
    StreamSubscription<Object?>? subscription;
    var finished = false;

    void finish(llm.ChatStreamEvent last) {
      finished = true;
      unawaited(subscription?.cancel());
      out.add(last);
      unawaited(out.close());
    }

    Future<void> start() async {
      try {
        await _methods.invokeMethod<void>("start", {"id": id, "system": system, "user": user});
      } on PlatformException catch (error) {
        if (!finished) finish(llm.ErrorEvent(llm.GenericError(error.message ?? "The on-device model failed.")));
      }
    }

    out
      ..onListen = () {
        // Listen before starting, so no event can arrive unheard.
        subscription = _events.listen((event) {
          final run = event as Map<Object?, Object?>;
          if (finished || run["id"] != id) return;
          switch (run) {
            case {"delta": final String delta}:
              text.write(delta);
              out.add(llm.TextDeltaEvent(delta));
            case {"error": final String message}:
              finish(llm.ErrorEvent(llm.GenericError(message)));
            default: // done
              finish(llm.CompletionEvent(_Text(text.toString())));
          }
        });
        unawaited(start());
      }
      ..onCancel = () async {
        if (finished) return;
        finished = true;
        await subscription?.cancel();
        // Cancelled by the caller: stop only this run's Swift task.
        await _methods.invokeMethod<void>("cancel", id);
      };
    return out.stream;
  }

  @override
  Future<llm.ChatResponse> chatWithTools(
    List<llm.ChatMessage> messages,
    List<llm.Tool>? tools, {
    CancelToken? cancelToken,
  }) async {
    if (tools != null && tools.isNotEmpty) {
      throw const llm.InvalidRequestError("The on-device model cannot use tools.");
    }
    final text = StringBuffer();
    await for (final event in chatStream(messages)) {
      switch (event) {
        case llm.TextDeltaEvent(:final delta):
          text.write(delta);
        case llm.ErrorEvent(:final error):
          throw error;
        default:
          break;
      }
    }
    return _Text(text.toString());
  }
}

class _Text implements llm.ChatResponse {
  const _Text(this.text);

  @override
  final String text;

  @override
  List<llm.ToolCall>? get toolCalls => null;

  @override
  String? get thinking => null;

  @override
  llm.UsageInfo? get usage => null;
}
