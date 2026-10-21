@Tags(["motion"])
library;

import "dart:io";
import "dart:ui" as ui;

import "package:alchemist/alchemist.dart" show loadFonts;
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

import "../support/desktop.dart";
import "../support/test_flow.dart";

/// Films every kind of view change: frames at fixed times after the key,
/// as PNGs in build/motion/<change>/, for judging motion by eye. Not a test
/// of anything; `just motion` runs it.
void main() {
  final frames = [for (var ms = 0; ms <= 520; ms += 20) ms];

  void film(String name, Future<void> Function(FlowApp app) before, Future<void> Function(FlowApp app) change) {
    testWidgets(name, (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await tester.runAsync(loadFonts);
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      mockStorage();
      final app = FlowApp();
      await app.start(tester, pump: false, motion: true);
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Desktop(child: app.widget),
        ),
      );
      await app.settle();
      await before(app);
      await tester.pump(const Duration(seconds: 1));

      final dir = Directory("build/motion/${name.replaceAll(" ", "_")}")..createSync(recursive: true);
      await change(app);
      var at = 0;
      for (final ms in frames) {
        await tester.pump(Duration(milliseconds: ms - at));
        at = ms;
        final image = await captureImage(tester.element(find.byType(Desktop)));
        await tester.runAsync(() async {
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          File("${dir.path}/${ms.toString().padLeft(3, "0")}.png").writeAsBytesSync(png!.buffer.asUint8List());
        });
      }
      await tester.pump(const Duration(seconds: 2));
    });
  }

  Future<void> review(FlowApp app) async {
    app
      ..frontApp = discord
      ..selection = "hey team, i think we should of shipped this friday but the tests wasnt ready";
    app.model.reply(["Hey team, I think we should have shipped this Friday, but the tests weren't ready."]);
    await app.pressHotkey();
  }

  Future<void> key(FlowApp app, LogicalKeyboardKey key, {LogicalKeyboardKey? hold}) async {
    if (hold != null) await app.tester.sendKeyDownEvent(hold);
    await app.tester.sendKeyEvent(key);
    if (hold != null) await app.tester.sendKeyUpEvent(hold);
  }

  film("open bar", review, (app) => key(app, LogicalKeyboardKey.space));
  film("close bar", (app) async {
    await review(app);
    await app.press(LogicalKeyboardKey.space);
  }, (app) => key(app, LogicalKeyboardKey.escape));
  film("preview", review, (app) => key(app, LogicalKeyboardKey.keyV));
  film("open settings", review, (app) => key(app, LogicalKeyboardKey.comma, hold: LogicalKeyboardKey.metaLeft));
}
