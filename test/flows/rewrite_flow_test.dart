import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/session.dart";

import "../support/test_flow.dart";

void main() {
  testFlow("Discord text gets Discord markdown and is pasted back", (app) async {
    app
      ..frontApp = discord
      ..selection = "its release day, lmk if it breaks"
      ..clipboard = "copied earlier";
    app.model.reply(["it's release day, ", "let me know if it breaks"]);

    await app.pressHotkey();
    final resolved = app.read(resolvedProvider)!;
    expect(resolved.profiles.map((p) => p.name), ["Discord"]);
    expect(resolved.active.map((a) => a.instruction.id.value), contains("discord"));
    expect(app.model.calls.single.system, contains("<destination>Discord</destination>"));
    expect(app.model.calls.single.system, isNot(contains("its release")));

    await app.press(LogicalKeyboardKey.enter);
    expect(app.pastedInto(discord), "it's release day, let me know if it breaks");
    expect(app.clipboard, "copied earlier");
    expect(app.visible, isFalse);
  });

  testFlow("switching 2, 3, 2 calls the model twice, not three times", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello!"]);

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.digit3);
    await app.press(LogicalKeyboardKey.digit2);
    expect(app.model.calls, hasLength(2));
    expect(app.read(currentRunProvider)?.value, isA<Done>());
  });

  testFlow("Esc cancels a running rewrite and Enter does nothing", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.hang();

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.escape);
    expect(app.model.cancelled, 1);
    await app.press(LogicalKeyboardKey.enter);
    expect(app.bridge.pasted, isEmpty);
  });

  testFlow("nothing is sent to a model at launch", (app) async {
    app.clipboard = "my password";
    expect(app.model.calls, isEmpty);
  });

  testFlow("launching or opening the app again shows the popup without the hotkey", (app) async {
    expect(app.window.popup, isTrue);
    expect(app.shownAtLaunch, isTrue, reason: "a launch shows the window although the hotkey works");
    expect(app.visible, isFalse, reason: "going back to the other app hid it");

    app.window.emit(WindowEvent.reopened);
    await app.settle();
    expect(app.visible, isTrue, reason: "Finder, Explorer or a launcher opened the app again");
    expect(app.model.calls, isEmpty);
  });

  testFlow("a login start stays hidden until the hotkey", background: true, (app) async {
    expect(app.window.popup, isTrue);
    expect(app.shownAtLaunch, isFalse);

    app.selection = "helo";
    app.model.reply(["hello"]);
    await app.pressHotkey();
    expect(app.visible, isTrue);
  });

  testFlow("the hotkey closes the popup the OS opened, and sends nothing", (app) async {
    // The popup is in front, so the clipboard would be the only text to take.
    app.clipboard = "my password";
    app.window.emit(WindowEvent.reopened);
    await app.settle();

    await app.pressHotkey();
    expect(app.visible, isFalse);
    expect(app.model.calls, isEmpty);
  });

  testFlow("rejecting a replacement keeps the original word (B2)", (app) async {
    app
      ..frontApp = notes
      ..selection = "the food is good";
    app.model.reply(["the meal is good"]);

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.keyN);
    await app.press(LogicalKeyboardKey.keyX);
    await app.press(LogicalKeyboardKey.enter);
    expect(app.pastedInto(notes), "the food is good");
  });

  testFlow("a result without changes still shows the review", (app) async {
    app
      ..frontApp = notes
      ..selection = "the food is good";
    app.model.reply(["the food is good"]);

    await app.pressHotkey();
    expect(find.textContaining("the food is good", findRichText: true), findsOneWidget);
    await app.press(LogicalKeyboardKey.enter);
    expect(app.pastedInto(notes), "the food is good");
  });

  testFlow("] steps the edit level and [ comes back from the cache", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello!"]);

    await app.pressHotkey(); // Polish
    await app.press(LogicalKeyboardKey.bracketRight); // Enhance
    await app.press(LogicalKeyboardKey.bracketLeft); // Polish again
    expect(app.model.calls, hasLength(2));
  });

  testFlow("Email delivers rich text", (app) async {
    app
      ..frontApp = const SourceApp(id: "com.apple.mail", name: "Mail", processId: 3)
      ..selection = "**hi** team";
    app.model.reply(["**Hi** team"]);

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.enter);
    expect(app.bridge.lastHtml, contains("<strong>Hi</strong>"));
  });

  testFlow("without Accessibility the result is copied with a reason", (app) async {
    app
      ..frontApp = discord
      ..selection = "helo";
    app.bridge.canPaste = false;
    app.model.reply(["hello"]);

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.enter);
    expect(app.clipboard, "hello");
    expect(find.textContaining("Accessibility"), findsOneWidget);
  });

  testFlow("compare: right arrow keeps the second model, Esc leaves", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello!"])
      ..reply(["Hi"]);
    const sonnet = ModelRef(Backend.anthropic, "claude-sonnet-5-5");

    await app.pressHotkey();
    app.read(sessionActionsProvider).compareWith(sonnet);
    await app.settle();
    expect(app.model.calls, hasLength(2));
    await app.press(LogicalKeyboardKey.arrowRight);
    expect(app.read(sessionProvider).compare, isNull);
    expect(app.read(runRequestProvider)?.model.ref, sonnet);
    expect(app.read(currentRunProvider)?.value, isA<Done>());

    app.read(sessionActionsProvider).compareWith(const ModelRef(Backend.anthropic, "claude-haiku-4-5"));
    await app.settle();
    await app.press(LogicalKeyboardKey.escape);
    expect(app.read(sessionProvider).compare, isNull);
    expect(app.visible, isTrue, reason: "Esc leaves compare before it hides the popup");
  });
}
