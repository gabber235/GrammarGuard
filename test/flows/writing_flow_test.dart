import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/setup_line.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/review_pane.dart";

import "../support/test_flow.dart";

void main() {
  testFlow("the text view carries over from writing to the review", (app) async {
    app
      ..frontApp = discord
      ..selection = "hey team, i think we should of shipped this friday";
    app.model
      ..delay = const Duration(milliseconds: 100)
      ..reply(["Hey team, ", "I think we should ", "have shipped this Friday."]);

    app.hotkey.press();
    while (app.read(currentRunProvider)?.value is! Streaming) {
      await app.tester.pump(const Duration(milliseconds: 20));
    }
    await app.tester.pump(const Duration(milliseconds: 150));
    final writing = app.tester.element(find.byType(ReviewPane));
    expect(app.tester.widget<ReviewPane>(find.byType(ReviewPane)).writing, isTrue);

    await app.settle();
    expect(app.read(currentRunProvider)?.value, isA<Done>());
    expect(app.tester.element(find.byType(ReviewPane)), same(writing), reason: "swapped, not carried over");
    expect(app.tester.widget<ReviewPane>(find.byType(ReviewPane)).writing, isFalse);
  });

  testFlow("the line above the text says what is on and why", (app) async {
    app
      ..frontApp = discord
      ..selection = "helo";
    app.model.reply(["Hello."]);
    await app.pressHotkey();

    final line = app.tester.widget<Text>(find.descendant(of: find.byType(SetupLine), matching: find.byType(Text)));
    final text = line.textSpan!.toPlainText();
    expect(text, contains("Discord profile  Casual, Discord markdown"));
    expect(text, contains("Default  Polish"));
    expect(text, contains(app.read(runRequestProvider)!.model.label));

    await app.tester.tap(find.byType(SetupLine));
    await app.settle();
    expect(app.read(sessionProvider).bar, isNotNull, reason: "clicking it opens the bar");
  });
}
