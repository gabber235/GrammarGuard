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

/// Renders the app for people to look at, with real fonts, into
/// build/media: every screen in [screens] as screens/<name>.png (end
/// states, twice the resolution), and films/<name>/ as numbered frames plus
/// a `delay` file (milliseconds per frame) for each view change and for the
/// app in use. `just media` runs it and encodes WebP; CI publishes the
/// result to pull requests and the README.
void main() {
  const out = "build/media";
  // The app ships on desktop: macOS key labels and text fields.

  /// The app over the stand in desktop, fonts loaded, started like a user
  /// would find it.
  Future<FlowApp> open(WidgetTester tester, {required Brightness brightness, required bool motion}) async {
    await tester.runAsync(loadFonts);
    tester.platformDispatcher.platformBrightnessTestValue = brightness;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    mockStorage();
    final app = FlowApp();
    await app.start(tester, pump: false, motion: motion);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Desktop(light: brightness == Brightness.light, child: app.widget),
      ),
    );
    await app.settle();
    return app;
  }

  Future<void> save(WidgetTester tester, String path) async {
    final image = await captureImage(tester.element(find.byType(Desktop)));
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
        final app = await open(tester, brightness: screen.brightness, motion: false);
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
  /// plays its actions at their times (milliseconds from the start).
  void film(
    String name, {
    required Future<void> Function(FlowApp app) before,
    required Map<int, Future<void> Function(FlowApp app)> timeline,
    required int length,
    int step = 20,
  }) {
    testWidgets(name, variant: _macOS, (tester) async {
      final app = await open(tester, brightness: Brightness.dark, motion: true);
      await before(app);
      await tester.pump(const Duration(seconds: 1));
      final dir = Directory("$out/films/${name.replaceAll(" ", "_")}");
      if (dir.existsSync()) dir.deleteSync(recursive: true);
      dir.createSync(recursive: true);
      File("${dir.path}/delay").writeAsStringSync("$step");

      final played = <int>{};
      for (var at = 0, frame = 0; at <= length; at += step, frame++) {
        for (final MapEntry(key: time, value: action) in timeline.entries) {
          if (time <= at && played.add(time)) await action(app);
        }
        await save(tester, "${dir.path}/${frame.toString().padLeft(4, "0")}.png");
        await tester.pump(Duration(milliseconds: step));
      }
      // Let delays and timers end before the test does.
      await tester.pump(const Duration(seconds: 5));
    });
  }

  Future<void> key(FlowApp app, LogicalKeyboardKey key, {LogicalKeyboardKey? hold}) async {
    if (hold != null) await app.tester.sendKeyDownEvent(hold);
    await app.tester.sendKeyEvent(key);
    if (hold != null) await app.tester.sendKeyUpEvent(hold);
  }

  group("films", () {
    film("open bar", before: review, timeline: {0: (app) => key(app, LogicalKeyboardKey.space)}, length: 520);
    film(
      "close bar",
      before: (app) async {
        await review(app);
        await app.press(LogicalKeyboardKey.space);
      },
      timeline: {0: (app) => key(app, LogicalKeyboardKey.escape)},
      length: 520,
    );
    film("preview", before: review, timeline: {0: (app) => key(app, LogicalKeyboardKey.keyV)}, length: 520);
    film(
      "open settings",
      before: review,
      timeline: {0: (app) => key(app, LogicalKeyboardKey.comma, hold: LogicalKeyboardKey.metaLeft)},
      length: 520,
    );

    // The app in use: the hotkey, the diff growing as the model writes,
    // a few review keys, the bar and back.
    film(
      "in use",
      before: (app) async {
        app
          ..frontApp = discord
          ..selection =
              "hey team, i think we should of shipped this friday but the tests wasnt ready. "
              "lets aim for monday, if anyone has concerns lmk";
        app.model
          ..delay = const Duration(milliseconds: 90)
          ..reply([
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
          ]);
      },
      timeline: {
        500: (app) async => app.hotkey.press(),
        3000: (app) => key(app, LogicalKeyboardKey.keyY),
        3600: (app) => key(app, LogicalKeyboardKey.keyN),
        4200: (app) => key(app, LogicalKeyboardKey.keyX),
        4900: (app) => key(app, LogicalKeyboardKey.space),
        6200: (app) => key(app, LogicalKeyboardKey.escape),
      },
      length: 7400,
      step: 40,
    );
  });
}

final _macOS = TargetPlatformVariant.only(TargetPlatform.macOS);
