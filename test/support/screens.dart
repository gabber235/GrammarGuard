import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/session/session.dart";
import "package:llm_dart/llm_dart.dart" as llm;

import "test_flow.dart";

/// One state of the app worth seeing, and how to get there from a fresh
/// start.
class Screen {
  const Screen(this.name, this.drive, {this.brightness = Brightness.dark});

  final String name;
  final Future<void> Function(FlowApp app) drive;
  final Brightness brightness;

  /// The name as a file name: "bar search" is bar_search.
  String get file => name.replaceAll(" ", "_");
}

/// Every screen and the states inside it. The goldens check each one; the
/// media capture (`just media`) renders them with real fonts for pull
/// requests and the README.
final screens = <Screen>[
  // The main window, from nothing to a finished review.
  Screen("empty", (app) async {}),
  Screen("thinking", (app) async {
    app
      ..frontApp = notes
      ..selection = _input;
    app.model.midStream([], thinking: "The user wants a light polish. Fix capitalization and the of/have mistake, ");
    await app.pressHotkey();
  }),
  Screen("streaming", (app) async {
    app
      ..frontApp = discord
      ..selection = _input;
    app.model.midStream(["Hey team, I think we should ", "have shipped this Friday, but the tests"]);
    await app.pressHotkey();
  }),
  Screen("review", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyN]);
  }),
  Screen("review light", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyN]);
  }, brightness: Brightness.light),
  Screen("review decided", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyY, LogicalKeyboardKey.keyX, LogicalKeyboardKey.keyY]);
  }),
  Screen("review why", (app) async {
    await review(app);
    app.model.says('{"reasons": [{"id": 0, "reason": "A message starts with a capital letter."}]}');
    await _keys(app, [LogicalKeyboardKey.slash], hold: LogicalKeyboardKey.shiftLeft);
  }),
  Screen("side by side", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyH]);
  }),
  Screen("preview", (app) async {
    app
      ..frontApp = notes
      ..selection = "plan: fix login, then ship";
    app.model.reply(["**Plan**\n\n1. Fix the login bug.\n2. Ship the release."]);
    await app.pressHotkey();
    await _keys(app, [LogicalKeyboardKey.keyV]);
  }),
  Screen("failed", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.events([llm.ErrorEvent(const llm.GenericError("429: rate limit reached for this key."))]);
    await app.pressHotkey();
  }),

  // The bar.
  Screen("bar", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.space]);
  }),
  Screen("bar search", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.space]);
    await app.tester.enterText(find.byType(TextField), "form");
    await _keys(app, [LogicalKeyboardKey.arrowDown]);
  }),
  Screen("bar models", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyM]);
  }),
  Screen("bar no match", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyM]);
    await app.tester.enterText(find.byType(TextField), "@nothing like this");
    await app.settle();
  }),
  Screen("bar compare", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.keyC]);
  }),
  Screen("bar light", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.space]);
    await app.tester.enterText(find.byType(TextField), "form");
    await app.settle();
  }, brightness: Brightness.light),

  // Views that take the review's place.
  Screen("compare", (app) async {
    await review(app);
    app.model.reply(["Hi team, we should have shipped Friday, but tests weren't ready. Monday? Shout if not."]);
    app.read(sessionActionsProvider).compareWith(const ModelRef(Backend.anthropic, "claude-sonnet-5-5"));
    await app.settle();
  }),
  Screen("editor", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.tab]);
  }),
  Screen("assistant no model", (app) async {
    await review(app);
    await app.openAssistant("make my Discord replies friendlier");
  }),
  const Screen("assistant proposal", _proposal),
  const Screen("assistant proposal light", _proposal, brightness: Brightness.light),
  Screen("assistant applied", (app) async {
    await _proposal(app);
    await _keys(app, [LogicalKeyboardKey.enter]);
  }),

  // Settings, every page.
  const Screen("settings models", _settings),
  Screen("settings instructions", (app) => _settings(app, "Instructions")),
  Screen("settings instruction dialog", (app) async {
    await _settings(app, "Instructions");
    await app.tester.tap(find.text("Casual").first);
    await app.settle();
  }),
  Screen("settings profiles", (app) async {
    await review(app);
    await _settings(app, "Profiles");
    await app.tester.tap(find.text("Discord").first);
    await app.settle();
  }),
  Screen("settings general", (app) => _settings(app, "General")),
  Screen("settings general light", (app) => _settings(app, "General"), brightness: Brightness.light),
  Screen("settings history", (app) async {
    await review(app);
    await _keys(app, [LogicalKeyboardKey.enter]);
    await _settings(app, "History");
  }),
];

const _input =
    "hey team, i think we should of shipped this friday but the tests wasnt ready. "
    "lets aim for monday, if anyone has concerns lmk";
const _output =
    "Hey team, I think we should have shipped this Friday, but the tests weren't ready. "
    "Let's aim for Monday. If anyone has concerns, let me know.";

/// A Discord message rewritten and ready for review.
Future<void> review(FlowApp app) async {
  app
    ..frontApp = discord
    ..selection = _input;
  app.model.reply([_output]);
  await app.pressHotkey();
}

Future<void> _keys(FlowApp app, List<LogicalKeyboardKey> keys, {LogicalKeyboardKey? hold}) async {
  for (final key in keys) {
    if (hold != null) await app.tester.sendKeyDownEvent(hold);
    await app.press(key);
    if (hold != null) await app.tester.sendKeyUpEvent(hold);
  }
}

Future<void> _settings(FlowApp app, [String? section]) async {
  await _keys(app, [LogicalKeyboardKey.comma], hold: LogicalKeyboardKey.metaLeft);
  if (section != null) {
    await app.tester.tap(find.text(section).first);
    await app.settle();
  }
}

Future<void> _proposal(FlowApp app) async {
  await review(app);
  app.model
    ..callsTool("put_instruction", {
      "id": "friendly-short",
      "name": "Friendly and short",
      "text": "Keep it warm and casual, cut filler, at most three sentences.",
    })
    ..callsTool("put_profile", {
      "name": "Discord",
      "apps": ["com.hnc.discord"],
      "use": ["friendly-short", "discord"],
    })
    ..says("I added a Friendly and short instruction and switched the Discord profile to it.");
  await app.chooseAssistantModel();
  await app.openAssistant("make my Discord replies friendlier and shorter");
  expect(app.read(assistantProvider).proposal, hasLength(2));
}
