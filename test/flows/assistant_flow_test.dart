import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/bar/command_bar.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:llm_dart/llm_dart.dart" as llm;

import "../support/test_flow.dart";

void main() {
  testFlow("the assistant proposes a profile and nothing is saved until Enter", (app) async {
    await app.chooseAssistantModel();
    app.frontApp = notes;
    app.model
      ..callsTool("put_instruction", {
        "id": "friendly-pro",
        "name": "Friendly professional",
        "text": "Clear, warm, no corporate phrases.",
      })
      ..callsTool("put_profile", {
        "name": "Notes",
        "apps": ["com.apple.notes"],
        "use": ["friendly-pro", "shorter"],
      })
      ..says("I proposed a Notes profile.");

    await app.openAssistant("make a profile for Notes, friendly but professional");
    expect(app.read(assistantProvider).proposal, hasLength(2));
    expect(app.library.profiles.where((p) => p.name == "Notes"), isEmpty);

    await app.press(LogicalKeyboardKey.enter);
    expect(app.library.profiles.singleWhere((p) => p.name == "Notes").use, [
      const InstructionId("friendly-pro"),
      const InstructionId("shorter"),
    ]);
    expect((await app.read(changeLogProvider.future)).first.author, ChangeAuthor.assistant);
  });

  testFlow("the answer renders Markdown instead of showing its marks", (app) async {
    await app.chooseAssistantModel();
    app.model.says("Turned on **Markdown** for `T3 Code`.");

    await app.openAssistant("use markdown in T3 Code");
    expect(find.textContaining("Turned on Markdown for", findRichText: true), findsOneWidget);
    expect(find.textContaining("**", findRichText: true), findsNothing);
  });

  testFlow("adding an instruction to a profile changes that profile, not a new one", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_profile", {
        "name": "discord",
        "add_use": ["shorter"],
        "remove_use": ["casual"],
      })
      ..says("Discord replies are shorter now.");

    await app.openAssistant("make my Discord replies shorter");
    expect(find.text("Change profile Discord"), findsOneWidget);
    await app.press(LogicalKeyboardKey.enter);

    final discord = app.library.profiles.where((p) => p.name.toLowerCase() == "discord").single;
    expect(discord.use, [const InstructionId("discord"), const InstructionId("shorter")]);
    expect(discord.when.apps, {"com.hnc.discord", "discord.exe", "discord"});
    expect(discord.when.title?.pattern, r"\| Discord");
  });

  testFlow("an empty value clears a profile field", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_profile", {"name": "Email", "url": "", "deliver": ""})
      ..says("Done.");

    await app.openAssistant("email in apps only, and plain paste");
    await app.press(LogicalKeyboardKey.enter);
    final email = app.library.profiles.singleWhere((p) => p.name == "Email");
    expect(email.when.url, isNull);
    expect(email.deliver, isNull);
    expect(email.when.apps, contains("com.apple.mail"));
  });

  testFlow("a new profile for an app that has one goes back to the model", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_profile", {
        "name": "Discord markdown links",
        "apps": ["discord"],
        "use": ["shorter"],
      })
      ..says("Let me change Discord instead.");

    await app.openAssistant("use shorter in Discord");
    expect(app.read(assistantProvider).proposal, isEmpty);
    final result = app.model.calls.last.messages.last.messageType as llm.ToolResultMessage;
    expect(result.results.single.function.arguments, contains("name Discord"));
  });

  testFlow("a separate profile for an app that has one is proposed when asked for", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_profile", {
        "name": "Discord long",
        "apps": ["discord"],
        "min_words": 100,
        "use": ["shorter"],
        "separate": true,
      })
      ..says("Added a second profile for long Discord texts.");

    await app.openAssistant("a second Discord profile for long messages");
    expect(find.text("New profile Discord long"), findsOneWidget);
  });

  testFlow("read_setup shows what is proposed so far", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_instruction", {"id": "british", "name": "British spelling", "text": "Use British spelling."})
      ..callsTool("read_setup", {})
      ..says("Proposed.");

    await app.openAssistant("british spelling");
    final result = app.model.calls.last.messages.last.messageType as llm.ToolResultMessage;
    expect(result.results.single.function.arguments, contains("Use British spelling."));
  });

  testFlow("an invalid proposal goes back to the model, not to the user", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_profile", {
        "name": "Slack",
        "apps": ["slack"],
        "use": ["does-not-exist"],
      })
      ..says("Sorry, fixed.");

    await app.openAssistant("slack profile please");
    expect(app.read(assistantProvider).proposal, isEmpty);
    final last = app.model.calls.last.messages.last.messageType as llm.ToolResultMessage;
    expect(last.results.single.function.arguments, contains("does-not-exist"));
  });

  testFlow("dropping a change with x keeps it out, undo restores the setup", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("put_instruction", {"id": "british", "name": "British spelling", "text": "Use British spelling."})
      ..callsTool("remove_instruction", {"id": "no-em-dash"})
      ..says("Two changes.");

    await app.openAssistant("british spelling, and I like em dashes");
    await app.press(LogicalKeyboardKey.keyY);
    await app.press(LogicalKeyboardKey.keyX);
    await app.press(LogicalKeyboardKey.enter);
    expect(app.library[const InstructionId("british")], isNotNull);
    expect(app.library[const InstructionId("no-em-dash")], isNotNull);

    await app.read(libraryStoreProvider.notifier).undo();
    await app.settle();
    expect(app.library[const InstructionId("british")], isNull);
  });

  testFlow("Esc stops a long answer", (app) async {
    await app.chooseAssistantModel();
    for (var i = 0; i < 200; i++) {
      app.model.callsTool("read_setup", {});
    }
    app.model.delay = const Duration(milliseconds: 50);
    unawaited(app.read(assistantProvider.notifier).open("tidy up my setup"));
    await app.settle();
    await app.press(LogicalKeyboardKey.escape);
    await app.settle();
    expect(app.model.calls.length, lessThan(200));
    expect(app.read(assistantProvider).busy, isFalse);
  });

  testFlow("Tab in the bar hands the typed text to the assistant", (app) async {
    await app.chooseAssistantModel();
    app.model.says("Sure.");
    await app.press(LogicalKeyboardKey.space);
    await app.tester.enterText(find.byType(TextField), "why so formal");
    await app.press(LogicalKeyboardKey.tab);
    expect(app.model.calls.single.messages.single.content, "why so formal");
  });

  testFlow("typing a reply never fires the review keys", (app) async {
    await app.chooseAssistantModel();
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model
      ..reply(["hello"])
      ..says("What should change?");
    await app.pressHotkey();
    await app.openAssistant("change my setup");

    await app.tester.tap(find.byType(TextField));
    await app.settle();
    for (final key in [LogicalKeyboardKey.space, LogicalKeyboardKey.keyC, LogicalKeyboardKey.enter]) {
      await app.press(key);
      expect(find.byType(CommandBar), findsNothing, reason: "$key opened the bar");
    }
    expect(app.pastedInto(notes), isNull);
    expect(app.read(assistantProvider).open, isTrue);
  });

  testFlow("a tool that fails on bad arguments answers the model, not the user", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..callsTool("remove_instruction", {})
      ..says("Which one?");

    await app.openAssistant("remove one");
    expect(app.read(assistantProvider).error, isNull);
    final result = app.model.calls.last.messages.last.messageType as llm.ToolResultMessage;
    expect(result.results.single.function.arguments, startsWith("Tool failed"));
  });

  testFlow("reset while answering keeps the new conversation clean", (app) async {
    await app.chooseAssistantModel();
    app.model
      ..delay = const Duration(milliseconds: 50)
      ..callsTool("read_setup", {})
      ..says("Late answer.");
    unawaited(app.read(assistantProvider.notifier).open("tidy up"));
    await app.tester.pump(const Duration(milliseconds: 10));

    app.read(assistantProvider.notifier).reset();
    await app.settle();
    expect(app.read(assistantProvider).messages, isEmpty);
    expect(app.read(assistantProvider).error, isNull);
  });

  testFlow("without a chosen model the assistant asks for one and sends nothing", (app) async {
    await app.openAssistant("make a Notes profile");
    expect(app.read(assistantProvider).error, contains("Choose a model for the assistant"));
    expect(app.model.calls, isEmpty);
  });

  testFlow(
    "Esc closes the bar and keeps the typed text out of the assistant",
    (app) async {
      await app.press(LogicalKeyboardKey.space);
      await app.tester.enterText(find.byType(TextField), "form");
      await app.press(LogicalKeyboardKey.escape);
      expect(find.byType(CommandBar), findsNothing);
      expect(app.read(assistantProvider).open, isFalse);
    },
    platform: TargetPlatform.macOS, // macOS maps keys in text fields differently
  );
}
