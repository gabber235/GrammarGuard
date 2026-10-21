// One file like this per backend.
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:llm_dart/llm_dart.dart" as llm;

import "../support/replay_adapter.dart";

void main() {
  test("Claude stream becomes text deltas and usage", () async {
    final adapter = ReplayAdapter({"/v1/messages": "test/fixtures/anthropic/stream.sse"});
    final gateway = LlmDartGateway(newDio: () => Dio()..httpClientAdapter = adapter);
    final chat = await gateway.chat(
      const Connection(backend: Backend.anthropic, enabled: true, apiKey: "test"),
      const ModelRef(Backend.anthropic, "claude-haiku-4-5"),
      system: "<rewrite_task>…</rewrite_task>",
    );

    final events = await chat.chatStream([llm.ChatMessage.user("<text>\nhelo\n</text>")]).toList();

    expect(events.whereType<llm.TextDeltaEvent>().map((e) => e.delta).join(), "hello");
    // llm_dart sends a completion at the start (input count) and more at
    // the end (output count); Run merges them and waits for the stream end.
    final usages = [for (final e in events.whereType<llm.CompletionEvent>()) e.response.usage];
    expect(usages.map((u) => u?.promptTokens ?? 0).reduce((a, b) => a > b ? a : b), 42);
    expect(usages.map((u) => u?.completionTokens ?? 0).reduce((a, b) => a > b ? a : b), 3);
    // The system prompt goes in the system field, never as a user message.
    // Anthropic takes the system prompt as a list of text blocks.
    expect(adapter.requests.single["system"], [
      {"type": "text", "text": "<rewrite_task>…</rewrite_task>"},
    ]);
    expect(adapter.requests.single["messages"], hasLength(1));
  });
}
