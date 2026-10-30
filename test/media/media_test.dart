@Tags(["media"])
library;

import "dart:io";
import "dart:ui" as ui;

import "package:alchemist/alchemist.dart" show loadFonts;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../support/desktop.dart";
import "../support/screens.dart";
import "../support/test_flow.dart";
import "stage.dart";

/// Renders the app for people to look at, with real fonts, into
/// build/media: every screen in [screens] as `screens/<name>.png` (end
/// states, twice the resolution), and `films/<name>/` as numbered frames plus
/// a `delay` file (milliseconds per frame): short stories of the app in use,
/// on a [Stage] with the chat app the text comes from. `media` (devenv) runs
/// it and encodes WebP; CI publishes the result to pull requests and the
/// README.
void main() {
  const out = "build/media";
  // The app ships on desktop: macOS key labels and text fields.

  /// The app inside [around], fonts loaded, started like a user would find
  /// it.
  Future<FlowApp> open(
    WidgetTester tester, {
    required Brightness brightness,
    required bool motion,
    required Widget Function(Widget app) around,
  }) async {
    await tester.runAsync(loadFonts);
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    mockStorage();
    final app = FlowApp();
    // Mounted first: opening the app shows the window, and start leaves it
    // for the other app. The other way round, the first hotkey hides it.
    await tester.pumpWidget(Directionality(textDirection: TextDirection.ltr, child: around(app.widget)));
    await app.start(tester, pump: false, motion: motion);
    return app;
  }

  Future<void> save(WidgetTester tester, String path) async {
    final image = await captureImage(tester.element(find.byType(Directionality).first));
    await tester.runAsync(() async {
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    });
    image.dispose();
  }

  group("screens", () {
    for (final screen in screens) {
      testWidgets(screen.name, variant: _macOS, (tester) async {
        final app = await open(
          tester,
          brightness: screen.brightness,
          motion: false,
          around: (app) => Desktop(light: screen.brightness == Brightness.light, child: app),
        );
        await screen.drive(app);
        await app.settle();
        tester.view.devicePixelRatio = 2;
        tester.view.physicalSize = const Size(2000, 1200);
        await app.settle();
        await save(tester, "$out/screens/${screen.file}.png");
      });
    }
  });

  /// Frames every [step] for [length] after [before], while [timeline]
  /// plays its acts at their times (milliseconds from the start).
  void film(
    String name, {
    required _Act before,
    required Map<int, _Act> timeline,
    required int length,
    Brightness brightness = Brightness.dark,
    int step = 40,
  }) {
    testWidgets(name, variant: _macOS, (tester) async {
      final stage = Stage(light: brightness == Brightness.light);
      final app = await open(
        tester,
        brightness: brightness,
        motion: true,
        around: (app) => StageView(stage: stage, app: app),
      );
      tester.view.physicalSize = Stage.size;
      app.frontApp = discord;
      app.model.delay = const Duration(milliseconds: 90);
      await before(app, stage);
      await tester.pump(const Duration(seconds: 1));
      final dir = Directory("$out/films/${name.replaceAll(" ", "_")}");
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      dir.createSync(recursive: true);
      File("${dir.path}/delay").writeAsStringSync("$step");

      final played = <int>{};
      var pastes = app.bridge.pasted.length;
      for (var at = 0, frame = 0; at <= length; at += step, frame++) {
        for (final MapEntry(key: time, value: act) in timeline.entries) {
          if (time <= at && played.add(time)) await act(app, stage);
        }
        if (app.bridge.pasted.length > pastes) {
          pastes = app.bridge.pasted.length;
          stage.paste(app.bridge.pasted.last.$1);
        }
        stage.windowShown = app.visible;
        await stage.tick(Duration(milliseconds: step));
        await tester.pump(Duration(milliseconds: step));
        await save(tester, "${dir.path}/${frame.toString().padLeft(4, "0")}.png");
      }
      // Let delays and timers end before the test does.
      await tester.pump(const Duration(seconds: 5));
    });
  }

  group("films", () {
    // The whole story: a message written in a chat, selected, rewritten,
    // reviewed change by change, pasted back and sent.
    for (final brightness in Brightness.values) {
      film(
        brightness == Brightness.dark ? "in use" : "in use light",
        brightness: brightness,
        before: (app, stage) async => app.model.reply(_chunks),
        timeline: {
          300: (app, stage) async => stage.type(_input),
          2600: (app, stage) async {
            stage
              ..show(["Cmd", "A"])
              ..selectAll();
            app.selection = stage.draft;
          },
          3200: (app, stage) async {
            stage.show(["Option", "Shift", "G"]);
            app.hotkey.press();
          },
          5300: _press(LogicalKeyboardKey.keyN),
          5900: _press(LogicalKeyboardKey.keyN),
          6500: (app, stage) async {
            app.model.says(_reasons);
            await _press(LogicalKeyboardKey.slash, hold: LogicalKeyboardKey.shiftLeft, shows: ["?"])(app, stage);
          },
          8300: _press(LogicalKeyboardKey.keyY),
          9100: _press(LogicalKeyboardKey.enter),
          10100: (app, stage) async => stage
            ..show(["Enter"])
            ..send(),
        },
        length: 11600,
      );
    }

    // A request typed in the bar reruns the rewrite.
    film(
      "request",
      before: (app, stage) async {
        await _ready(app, stage);
        app.model.reply(["Hey team! ", "Tests weren't ready, ", "so we ship Monday. ", "Concerns? ", "Let me know."]);
      },
      timeline: {
        400: _press(LogicalKeyboardKey.space),
        1100: (app, stage) async => stage.type(
          "shorter, and upbeat",
          cps: 22,
          onType: (typed) => app.tester.enterText(find.byType(TextField), typed),
        ),
        2400: _press(LogicalKeyboardKey.enter),
      },
      length: 5600,
    );

    // A second model next to the first, and keeping one.
    film(
      "compare",
      before: (app, stage) async {
        await _ready(app, stage);
        app.model.reply([
          "Hi team, ",
          "we should have shipped Friday, ",
          "but tests weren't ready. ",
          "Monday? ",
          "Shout if not.",
        ]);
      },
      timeline: {
        400: _press(LogicalKeyboardKey.keyC),
        1100: (app, stage) async =>
            stage.type("sonnet", cps: 18, onType: (typed) => app.tester.enterText(find.byType(TextField), typed)),
        1900: _press(LogicalKeyboardKey.enter),
        4200: _press(LogicalKeyboardKey.arrowRight),
      },
      length: 5600,
    );

    // The assistant changes the setup from a sentence, after a review.
    film(
      "assistant",
      before: (app, stage) async {
        await _ready(app, stage);
        await app.chooseAssistantModel();
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
          ..says("I added a **Friendly and short** instruction and switched the **Discord** profile to it.");
      },
      timeline: {
        400: _press(LogicalKeyboardKey.space),
        1100: (app, stage) async => stage.type(
          "make my Discord replies friendlier",
          cps: 24,
          onType: (typed) => app.tester.enterText(find.byType(TextField), typed),
        ),
        2700: _press(LogicalKeyboardKey.tab),
        6000: _press(LogicalKeyboardKey.enter),
      },
      length: 7800,
    );

    // Settings, through its pages to a profile.
    film(
      "settings",
      before: _ready,
      timeline: {
        400: _press(LogicalKeyboardKey.comma, hold: LogicalKeyboardKey.metaLeft),
        1500: _tap("Instructions"),
        2700: _tap("Profiles"),
        3900: _tap("Discord"),
        5400: _press(LogicalKeyboardKey.escape),
      },
      length: 6400,
    );
  });
}

typedef _Act = Future<void> Function(FlowApp app, Stage stage);

/// Presses [key] in the app's window and shows it on the stage, or what
/// it [shows] (Shift and / show as ?).
_Act _press(LogicalKeyboardKey key, {LogicalKeyboardKey? hold, List<String>? shows}) => (app, stage) async {
  stage.show(shows ?? [if (hold != null) _label(hold), _label(key)]);
  if (hold != null) await app.tester.sendKeyDownEvent(hold);
  await app.tester.sendKeyEvent(key);
  if (hold != null) await app.tester.sendKeyUpEvent(hold);
};

_Act _tap(String text) =>
    (app, stage) => app.tester.tap(find.text(text).first);

String _label(LogicalKeyboardKey key) => switch (key) {
  LogicalKeyboardKey.metaLeft => "Cmd",
  LogicalKeyboardKey.space => "Space",
  LogicalKeyboardKey.enter => "Enter",
  LogicalKeyboardKey.escape => "Esc",
  LogicalKeyboardKey.tab => "Tab",
  LogicalKeyboardKey.arrowRight => "Right",
  _ => key.keyLabel.toLowerCase(),
};

/// The message written, selected and rewritten, ready for review.
Future<void> _ready(FlowApp app, Stage stage) async {
  stage
    ..draft = _input
    ..selected = true;
  app.selection = _input;
  app.model.reply(_chunks);
  await app.pressHotkey();
  await app.tester.pump(const Duration(seconds: 2));
}

const _input =
    "hey team, i think we should of shipped this friday but the tests wasnt ready. "
    "lets aim for monday, if anyone has concerns lmk";

/// Why each change was made, as the model answers ? in the review.
const _reasons = r"""
{"reasons": [
  {"id": 0, "reason": "A message starts with a capital letter."},
  {"id": 1, "reason": "The pronoun I is always capitalized."},
  {"id": 2, "reason": "\"Should of\" is a common mishearing of \"should have\"."}
]}""";

const _chunks = [
  "Hey team, ",
  "I think ",
  "we should ",
  "have shipped ",
  "this Friday, ",
  "but the tests ",
  "weren't ready. ",
  "Let's aim ",
  "for Monday. ",
  "If anyone ",
  "has concerns, ",
  "let me know.",
];

final _macOS = TargetPlatformVariant.only(TargetPlatform.macOS);
