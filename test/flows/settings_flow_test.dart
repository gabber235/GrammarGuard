import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:hotkey_manager/hotkey_manager.dart";

import "../support/test_flow.dart";

void main() {
  Future<void> openGeneral(FlowApp app) async {
    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await app.press(LogicalKeyboardKey.comma);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await app.tester.tap(find.text("General"));
    await app.settle();
  }

  Future<void> openInstructions(FlowApp app) async {
    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await app.press(LogicalKeyboardKey.comma);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
    await app.tester.tap(find.text("Instructions"));
    await app.settle();
  }

  Future<HotKey> hotkey(FlowApp app) => app.read(hotkeySettingProvider.future);

  testFlow("keys pressed on the General page never change the shortcut by accident", (app) async {
    await openGeneral(app);
    final before = await hotkey(app);

    await app.press(LogicalKeyboardKey.keyK);
    await app.press(LogicalKeyboardKey.escape);

    expect((await hotkey(app)).logicalKey, before.logicalKey);
    expect(find.byType(SettingsPage), findsNothing, reason: "Esc left Settings instead of being recorded");
  });

  testFlow("Change records one shortcut, and only one with a modifier", (app) async {
    await openGeneral(app);
    await app.tester.tap(find.text("Change"));
    await app.settle();

    await app.press(LogicalKeyboardKey.keyK);
    expect(find.text("Hold Cmd, Option, Ctrl or Shift too."), findsOneWidget);

    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await app.press(LogicalKeyboardKey.keyK);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    final saved = await hotkey(app);
    expect(saved.logicalKey, LogicalKeyboardKey.keyK);
    expect(saved.modifiers, [HotKeyModifier.control]);
  });

  testFlow("Esc while recording cancels and stays in Settings", (app) async {
    await openGeneral(app);
    await app.tester.tap(find.text("Change"));
    await app.settle();

    await app.press(LogicalKeyboardKey.escape);

    expect(find.text("Change"), findsOneWidget);
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testFlow("a setup file that does not load can be swapped for the built-in one in one click", (app) async {
    await app.breakLibrary();
    await openInstructions(app);
    expect(find.textContaining("library.yaml has a problem"), findsOneWidget);
    expect(find.textContaining("The text of `enhance` has a comma"), findsOneWidget);

    await app.tester.tap(find.text("Use the built-in setup"));
    await app.settle();

    expect(find.textContaining("library.yaml has a problem"), findsNothing);
    expect(find.textContaining("Your old file is library.yaml.broken-"), findsOneWidget);
    expect(app.read(libraryStoreProvider).value!.problem, isNull);
    final kept = app.files.directory("/support").listSync().where((f) => f.basename.contains(".broken-"));
    expect(kept.single.basename, startsWith("library.yaml.broken-"));
  });
}
