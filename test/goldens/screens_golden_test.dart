import "package:alchemist/alchemist.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/session/session.dart";
import "package:llm_dart/llm_dart.dart" as llm;

import "../support/desktop.dart";
import "../support/test_flow.dart";

/// Every screen and the states inside it, in the 1000 by 600 popup over a
/// stand in desktop, dark unless named light. Animations are off (reduced
/// motion), so each image is the end state.
void main() {
  Future<void> screen(
    String name,
    Future<void> Function(FlowApp app) drive, {
    Brightness brightness = Brightness.dark,
  }) async {
    late FlowApp app;
    await goldenTest(
      name,
      fileName: name.replaceAll(" ", "_"),
      constraints: BoxConstraints.tight(const Size(1000, 600)),
      builder: () {
        // The app ships on desktop: macOS key labels and text fields, no
        // touch selection handles.
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        mockStorage();
        app = FlowApp();
        return MediaQuery(
          data: MediaQueryData(platformBrightness: brightness, size: const Size(1000, 600)),
          child: Desktop(light: brightness == Brightness.light, child: app.widget),
        );
      },
      pumpBeforeTest: (tester) async {
        await app.start(tester, pump: false);
        await drive(app);
        await app.settle();
      },
    );
  }

  const input =
      "hey team, i think we should of shipped this friday but the tests wasnt ready. "
      "lets aim for monday, if anyone has concerns lmk";
  const output =
      "Hey team, I think we should have shipped this Friday, but the tests weren't ready. "
      "Let's aim for Monday. If anyone has concerns, let me know.";

  Future<void> review(FlowApp app) async {
    app
      ..frontApp = discord
      ..selection = input;
    app.model.reply([output]);
    await app.pressHotkey();
  }

  Future<void> keys(FlowApp app, List<LogicalKeyboardKey> keys, {LogicalKeyboardKey? hold}) async {
    for (final key in keys) {
      if (hold != null) await app.tester.sendKeyDownEvent(hold);
      await app.press(key);
      if (hold != null) await app.tester.sendKeyUpEvent(hold);
    }
  }

  Future<void> settings(FlowApp app, [String? section]) async {
    await keys(app, [LogicalKeyboardKey.comma], hold: LogicalKeyboardKey.metaLeft);
    if (section != null) {
      await app.tester.tap(find.text(section).first);
      await app.settle();
    }
  }

  Future<void> proposal(FlowApp app) async {
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

  // The main window, from nothing to a finished review.
  screen("empty", (app) async {});
  screen("thinking", (app) async {
    app
      ..frontApp = notes
      ..selection = input;
    app.model.midStream([], thinking: "The user wants a light polish. Fix capitalization and the of/have mistake, ");
    await app.pressHotkey();
  });
  screen("streaming", (app) async {
    app
      ..frontApp = discord
      ..selection = input;
    app.model.midStream(["Hey team, I think we should ", "have shipped this Friday, but the tests"]);
    await app.pressHotkey();
  });
  screen("review", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyN]);
  });
  screen("review light", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyN]);
  }, brightness: Brightness.light);
  screen("review decided", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyY, LogicalKeyboardKey.keyX, LogicalKeyboardKey.keyY]);
  });
  screen("review why", (app) async {
    await review(app);
    app.model.says('{"reasons": [{"id": 0, "reason": "A message starts with a capital letter."}]}');
    await keys(app, [LogicalKeyboardKey.slash], hold: LogicalKeyboardKey.shiftLeft);
  });
  screen("side by side", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyH]);
  });
  screen("preview", (app) async {
    app
      ..frontApp = notes
      ..selection = "plan: fix login, then ship";
    app.model.reply(["**Plan**\n\n1. Fix the login bug.\n2. Ship the release."]);
    await app.pressHotkey();
    await keys(app, [LogicalKeyboardKey.keyV]);
  });
  screen("failed", (app) async {
    app
      ..frontApp = notes
      ..selection = "helo";
    app.model.events([llm.ErrorEvent(const llm.GenericError("429: rate limit reached for this key."))]);
    await app.pressHotkey();
  });

  // The bar.
  screen("bar", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.space]);
  });
  screen("bar search", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.space]);
    await app.tester.enterText(find.byType(TextField), "form");
    await keys(app, [LogicalKeyboardKey.arrowDown]);
  });
  screen("bar models", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyM]);
  });
  screen("bar no match", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyM]);
    await app.tester.enterText(find.byType(TextField), "@nothing like this");
    await app.settle();
  });
  screen("bar compare", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.keyC]);
  });
  screen("bar light", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.space]);
    await app.tester.enterText(find.byType(TextField), "form");
    await app.settle();
  }, brightness: Brightness.light);

  // Views that take the review's place.
  screen("compare", (app) async {
    await review(app);
    app.model.reply(["Hi team, we should have shipped Friday, but tests weren't ready. Monday? Shout if not."]);
    app.read(sessionActionsProvider).compareWith(const ModelRef(Backend.anthropic, "claude-sonnet-5-5"));
    await app.settle();
  });
  screen("editor", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.tab]);
  });
  screen("assistant no model", (app) async {
    await review(app);
    await app.openAssistant("make my Discord replies friendlier");
  });
  screen("assistant proposal", proposal);
  screen("assistant proposal light", proposal, brightness: Brightness.light);
  screen("assistant applied", (app) async {
    await proposal(app);
    await keys(app, [LogicalKeyboardKey.enter]);
  });

  // Settings, every page.
  screen("settings models", (app) async => settings(app));
  screen("settings instructions", (app) async => settings(app, "Instructions"));
  screen("settings instruction dialog", (app) async {
    await settings(app, "Instructions");
    await app.tester.tap(find.text("Casual").first);
    await app.settle();
  });
  screen("settings profiles", (app) async {
    await review(app);
    await settings(app, "Profiles");
    await app.tester.tap(find.text("Discord").first);
    await app.settle();
  });
  screen("settings general", (app) async => settings(app, "General"));
  screen("settings general light", (app) async => settings(app, "General"), brightness: Brightness.light);
  screen("settings history", (app) async {
    await review(app);
    await keys(app, [LogicalKeyboardKey.enter]);
    await settings(app, "History");
  });
}
