import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/session.dart";
import "package:llm_dart/llm_dart.dart" as llm;

import "../support/test_flow.dart";

void main() {
  testFlow("an Anthropic style stream with a completion first still delivers its text", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.events([
      // llm_dart's Anthropic stream: usage at message_start, text, usage at the end.
      llm.CompletionEvent(usageReply("", promptTokens: 42)),
      const llm.TextDeltaEvent("hel"),
      const llm.TextDeltaEvent("lo"),
      llm.CompletionEvent(usageReply("", completionTokens: 3)),
    ]);

    await app.pressHotkey();
    final done = app.read(currentRunProvider)?.value;
    expect(done, isA<Done>().having((d) => d.text, "text", "hello"));
    expect((done! as Done).usage.promptTokens, 42);
    expect((done as Done).usage.completionTokens, 3);
  });

  testFlow("a stream that ends without completing fails with a retry hint", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.events([const llm.TextDeltaEvent("hel")]);

    await app.pressHotkey();
    expect(app.read(currentRunProvider)?.value, isA<Failed>());
    await app.press(LogicalKeyboardKey.enter);
    expect(app.bridge.pasted, isEmpty);
  });

  testFlow("an error outside llm_dart fails the run instead of writing forever", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.crash(ArgumentError("No host specified in URI http:///v1"));

    await app.pressHotkey();
    expect(app.read(currentRunProvider)?.value, isA<Failed>().having((f) => f.message, "message", contains("No host")));
  });

  testFlow("the model's outer whitespace and <text> wrapper do not leak into the result", (app) async {
    app
      ..frontApp = notes
      ..selection = " helo\n";
    app.model.reply(["<text>\nhello\n</text>"]);

    await app.pressHotkey();
    expect(app.read(currentRunProvider)?.value, isA<Done>().having((d) => d.text, "text", " hello\n"));
  });
}

llm.ChatResponse usageReply(String text, {int? promptTokens, int? completionTokens}) =>
    _Usage(text, llm.UsageInfo(promptTokens: promptTokens, completionTokens: completionTokens));

class _Usage implements llm.ChatResponse {
  _Usage(this.text, this.usage);

  @override
  final String text;

  @override
  final llm.UsageInfo usage;

  @override
  List<llm.ToolCall>? get toolCalls => null;

  @override
  String? get thinking => null;
}
