import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
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
}
