import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:hotkey_manager/hotkey_manager.dart";

import "../support/test_flow.dart";

void main() {
  Future<void> openSettings(FlowApp app) async {
    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
    await app.press(LogicalKeyboardKey.comma);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
  }

  Future<void> openGeneral(FlowApp app) async {
    await openSettings(app);
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
    expect(find.text("Hold Cmd, Option, Ctrl or Shift too, or use an F key."), findsOneWidget);

    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await app.press(LogicalKeyboardKey.keyK);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    final saved = await hotkey(app);
    expect(saved.logicalKey, LogicalKeyboardKey.keyK);
    expect(saved.modifiers, [HotKeyModifier.control]);
  });

  testFlow("Change records a function key on its own", (app) async {
    await openGeneral(app);
    await app.tester.tap(find.text("Change"));
    await app.settle();

    await app.press(LogicalKeyboardKey.f1);

    final saved = await hotkey(app);
    expect(saved.physicalKey, PhysicalKeyboardKey.f1);
    expect(saved.modifiers, isEmpty);
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

  testFlow("the assistant model list opens in place, filters, and picks with the keyboard", (app) async {
    await openSettings(app);
    final panel = find.ancestor(of: find.text("Assistant model"), matching: find.byType(Panel));
    final closed = app.tester.getSize(panel).height;

    await app.tester.tap(find.text("Choose a model"));
    await app.settle();
    expect(app.tester.getSize(panel).height, greaterThan(closed), reason: "the panel grows to hold the list");
    expect(
      find.descendant(of: panel, matching: find.text("Claude Sonnet 5.5")),
      findsOneWidget,
      reason: "the rows are in the panel, not in a menu over the window",
    );

    await app.tester.enterText(find.descendant(of: panel, matching: find.byType(TextField)), "opus");
    await app.settle();
    expect(find.text("Claude Sonnet 5.5"), findsNothing);
    expect(find.text("Claude Opus 5.5"), findsOneWidget);

    await app.press(LogicalKeyboardKey.arrowDown);
    await app.press(LogicalKeyboardKey.enter);

    expect(app.library.assistantModel, const ModelRef(Backend.anthropic, "claude-opus-5"));
    expect(find.descendant(of: panel, matching: find.text("Claude Opus 5")), findsOneWidget);
    expect(find.descendant(of: panel, matching: find.byType(TextField)), findsNothing);
    expect(app.tester.getSize(panel).height, closed);
  });

  testFlow("Esc closes the open list and keeps Settings; Enter opens it again", (app) async {
    await openSettings(app);
    await app.tester.tap(find.text("Choose a model"));
    await app.settle();

    await app.press(LogicalKeyboardKey.escape);
    expect(find.text("Claude Sonnet 5.5"), findsNothing);
    expect(find.byType(SettingsPage), findsOneWidget, reason: "Esc closed the list only");

    await app.press(LogicalKeyboardKey.enter);
    expect(find.text("Claude Sonnet 5.5"), findsOneWidget, reason: "focus stayed on the picker");

    await app.press(LogicalKeyboardKey.escape);
    await app.press(LogicalKeyboardKey.escape);
    expect(find.byType(SettingsPage), findsNothing);
  });

  testFlow("an instruction's group is picked from a list that opens inside the dialog", (app) async {
    await openSettings(app);
    await app.tester.tap(find.text("Instructions"));
    await app.settle();
    await app.tester.tap(find.text("Casual").first);
    await app.settle();
    final dialog = find.byType(AlertDialog);

    await app.tester.tap(find.descendant(of: dialog, matching: find.text("Tone")));
    await app.settle();
    await app.tester.tap(find.descendant(of: dialog, matching: find.text("Length")));
    await app.settle();
    expect(
      find.descendant(of: dialog, matching: find.text("Audience")),
      findsNothing,
      reason: "picking closes it",
    );

    await app.tester.tap(find.text("Save"));
    await app.settle();
    expect(app.library[const InstructionId("casual")]?.group, const GroupId("length"));
  });
}
