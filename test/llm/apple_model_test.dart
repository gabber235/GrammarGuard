import "dart:async";

import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/apple_model.dart";
import "package:llm_dart/llm_dart.dart" as llm;

/// Stands in for AppleModelChannel.swift: records start and cancel and lets
/// the test send tagged events.
class _FakeSwift {
  _FakeSwift() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(const MethodChannel("grammar_guard/apple_model"), (call) async {
        switch (call.method) {
          case "start":
            started.add((call.arguments as Map)["id"] as int);
          case "cancel":
            cancelled.add(call.arguments as int);
        }
        return null;
      })
      ..setMockStreamHandler(
        const EventChannel("grammar_guard/apple_model/stream"),
        MockStreamHandler.inline(onListen: (_, events) => sink = events, onCancel: (_) => sink = null),
      );
  }

  final started = <int>[];
  final cancelled = <int>[];
  MockStreamHandlerEventSink? sink;

  void send(Map<String, Object> event) => sink!.success(event);
}

List<llm.ChatMessage> get _messages => [llm.ChatMessage.user("Fix this")];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("a new run keeps streaming after the previous run is cancelled", () async {
    final swift = _FakeSwift();
    final chat = AppleChat(system: "Be brief.");

    final old = chat.chatStream(_messages).listen((_) {});
    await pumpEventQueue();
    final current = <llm.ChatStreamEvent>[];
    final done = Completer<void>();
    chat.chatStream(_messages).listen(current.add, onDone: done.complete);
    await pumpEventQueue();
    final [oldId, currentId] = swift.started;

    await old.cancel();
    await pumpEventQueue();
    expect(swift.cancelled, [oldId], reason: "only the cancelled run's task stops");

    swift
      ..send({"id": oldId, "delta": "stale"})
      ..send({"id": currentId, "delta": "Fixed"})
      ..send({"id": currentId, "done": true});
    await done.future;

    expect(current.whereType<llm.TextDeltaEvent>().map((e) => e.delta), ["Fixed"]);
    expect(current.last, isA<llm.CompletionEvent>().having((e) => e.response.text, "text", "Fixed"));
  });

  test("a model error ends the run without cancelling it", () async {
    final swift = _FakeSwift();
    final events = AppleChat(system: "").chatStream(_messages).toList();
    await pumpEventQueue();
    swift.send({"id": swift.started.single, "error": "Too long"});

    expect(await events, [isA<llm.ErrorEvent>().having((e) => e.error.message, "message", "Too long")]);
    expect(swift.cancelled, isEmpty);
  });
}
