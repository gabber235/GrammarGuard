import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/bar/command_bar.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/session/session.dart";

import "../support/test_flow.dart";

void main() {
  Future<void> captureFromDiscord(FlowApp app) async {
    app
      ..frontApp = discord
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello."]);
    await app.pressHotkey();
  }

  Set<InstructionId> active(FlowApp app) => {for (final a in app.read(resolvedProvider)!.active) a.instruction.id};

  testFlow("Space swaps the result for the bar, Esc swaps it back", (app) async {
    await captureFromDiscord(app);
    expect(find.byType(ResultView), findsOneWidget);

    await app.press(LogicalKeyboardKey.space);
    expect(find.byType(CommandBar), findsOneWidget);
    expect(find.byType(ResultView), findsNothing, reason: "the bar is a view, not a layer over the result");

    await app.press(LogicalKeyboardKey.escape);
    expect(find.byType(CommandBar), findsNothing);
    expect(find.byType(ResultView), findsOneWidget);
    expect(app.visible, isTrue, reason: "Esc closed the bar only");
  });

  testFlow("the empty bar lists what is on first, and Enter turns it off", (app) async {
    await captureFromDiscord(app);
    expect(active(app), contains(const InstructionId("discord")));

    await app.press(LogicalKeyboardKey.space);
    expect(find.text("On for this text from Discord"), findsOneWidget);
    expect(find.text("Discord profile"), findsWidgets);
    final first = app.read(resolvedProvider)!.active.first.instruction;

    await app.press(LogicalKeyboardKey.enter);
    expect(find.byType(CommandBar), findsNothing);
    expect(active(app), isNot(contains(first.id)));
  });

  testFlow("arrowing to the last row scrolls it clear of the fade", (app) async {
    await captureFromDiscord(app);
    await app.press(LogicalKeyboardKey.space);
    final list = app.tester.getRect(find.byType(ListView));
    final last = find.text("Ask the assistant");
    bool clear() => last.evaluate().isNotEmpty && app.tester.getRect(last).bottom <= list.bottom - 32;
    expect(clear(), isFalse, reason: "the list fits; this test needs a longer one");

    for (var i = 0; i < 20; i++) {
      await app.press(LogicalKeyboardKey.arrowDown);
    }
    expect(clear(), isTrue);
  });

  testFlow("a row on for this text is listed once", (app) async {
    await captureFromDiscord(app);
    await app.press(LogicalKeyboardKey.digit2); // Polish, also a pin
    await app.press(LogicalKeyboardKey.space);
    expect(find.text("Polish"), findsOneWidget);
  });

  testFlow("a typed request shows as on, and Enter on it drops it", (app) async {
    await captureFromDiscord(app);
    app.model.reply(["Hello there."]);
    await app.press(LogicalKeyboardKey.space);
    await app.tester.enterText(find.byType(TextField), "make it rhyme");
    await app.settle();
    expect(find.text("Use \u201cmake it rhyme\u201d as a request"), findsOneWidget);
    await app.press(LogicalKeyboardKey.enter); // nothing else matches: the request is the first row
    expect(app.read(resolvedProvider)!.words, "make it rhyme");

    await app.press(LogicalKeyboardKey.space);
    expect(find.text("\u201cmake it rhyme\u201d"), findsOneWidget);
    // The request comes after the instructions that are on.
    for (var i = 0; i < app.read(resolvedProvider)!.active.length; i++) {
      await app.press(LogicalKeyboardKey.arrowDown);
    }
    await app.press(LogicalKeyboardKey.enter);
    expect(app.read(resolvedProvider)!.words, isEmpty);
  });

  testFlow("new text closes the bar", (app) async {
    await captureFromDiscord(app);
    await app.press(LogicalKeyboardKey.space);
    expect(app.read(sessionProvider).bar, isNotNull);

    app.selection = "other text";
    app.model.reply(["Other text."]);
    app.window.visible = false;
    await app.pressHotkey();
    expect(find.byType(CommandBar), findsNothing);
  });

  testFlow("M opens the bar on models with the cursor after the @", (app) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS; // desktop fields select all on focus
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await captureFromDiscord(app);
    await app.press(LogicalKeyboardKey.keyM);
    final field = app.tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.value.selection, const TextSelection.collapsed(offset: 1));
  });

  testFlow("C opens the bar on models, and Enter compares instead of switching", (app) async {
    await captureFromDiscord(app);
    final current = app.read(runRequestProvider)!.model.ref;
    await app.press(LogicalKeyboardKey.keyC);
    expect(find.text("Compare with which model?"), findsOneWidget);

    await app.press(LogicalKeyboardKey.enter);
    expect(app.read(sessionProvider).compare, isNotNull);
    expect(app.read(runRequestProvider)!.model.ref, current, reason: "the result keeps its model");
  });
}
