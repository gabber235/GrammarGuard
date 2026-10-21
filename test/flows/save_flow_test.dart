import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/platform/ports.dart";

import "../support/test_flow.dart";

void main() {
  /// Space, type [query], then Enter with [modifier] held: a bar scope.
  Future<void> barEnter(FlowApp app, String query, LogicalKeyboardKey? modifier) async {
    await app.press(LogicalKeyboardKey.space);
    await app.tester.enterText(find.byType(TextField), query);
    await app.settle();
    if (modifier != null) await app.tester.sendKeyDownEvent(modifier);
    await app.press(LogicalKeyboardKey.enter);
    if (modifier != null) await app.tester.sendKeyUpEvent(modifier);
    await app.settle();
  }

  testFlow("S keeps what was picked for now in the app's own profile", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello."]);

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.digit6); // Professional
    await app.press(LogicalKeyboardKey.keyS);

    final profile = app.library.appProfile(notes.id)!;
    expect(profile.name, "Notes");
    expect(profile.use, contains(const InstructionId("professional")));
  });

  testFlow("S never overwrites another profile with the same name", (app) async {
    const flatpakDiscord = SourceApp(id: "com.discordapp.discord", name: "Discord", processId: 9);
    app
      ..frontApp = flatpakDiscord
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..reply(["Hello."]);
    final bundledDiscord = app.library.profiles.singleWhere((p) => p.name == "Discord");

    await app.pressHotkey();
    await app.press(LogicalKeyboardKey.digit6);
    await app.press(LogicalKeyboardKey.keyS);

    expect(app.library.profiles.singleWhere((p) => p.name == "Discord"), bundledDiscord);
    expect(app.library.appProfile(flatpakDiscord.id)?.name, "Discord (com.discordapp.discord)");
  });

  testFlow("Shift Enter in the bar saves an instruction for this app only", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.reply(["hello"]);

    await app.pressHotkey();
    await barEnter(app, "Casual", LogicalKeyboardKey.shiftLeft);

    expect(app.library.appProfile(notes.id)?.use, contains(const InstructionId("casual")));
    expect(app.library.defaults, isNot(contains(const InstructionId("casual"))));
  });

  testFlow("Cmd Enter in the bar saves an instruction for every app", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.reply(["hello"]);

    await app.pressHotkey();
    await barEnter(app, "Casual", LogicalKeyboardKey.metaLeft);

    expect(app.library.defaults, contains(const InstructionId("casual")));
    expect(app.library.appProfile(notes.id), isNull);
  });
}
