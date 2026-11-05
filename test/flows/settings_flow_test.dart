import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/settings/connection_tile.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:llm_dart/llm_dart.dart" as llm;

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

  for (final platform in const [TargetPlatform.macOS, TargetPlatform.linux, TargetPlatform.windows]) {
    testFlow("a mouse click picks a row in a list with a search field on $platform", (app) async {
      await openSettings(app);
      await app.tester.tap(find.text("Choose a model"));
      await app.settle();

      // A real click spans frames, unlike tester.tap: the row must survive
      // the frame between pressing and releasing the button.
      final click = await app.tester.startGesture(
        app.tester.getCenter(find.text("Claude Sonnet 5.5")),
        kind: PointerDeviceKind.mouse,
      );
      await app.tester.pump();
      await click.up();
      await app.settle();

      expect(app.library.assistantModel?.id, contains("sonnet"));
    }, platform: platform);
  }

  testFlow("an empty model list says what to do instead of that nothing matches", (app) async {
    final connections = app.container.read(connectionsProvider.notifier);
    await connections.save(const Connection(backend: Backend.anthropic, enabled: true));
    await app.settle();
    await openSettings(app);

    await app.tester.tap(find.text("Choose a model"));
    await app.settle();

    expect(find.text("No models yet. Add an API key under Connections below."), findsOneWidget);
    expect(find.text("Nothing matches."), findsNothing);
  });

  group("an API key", () {
    Finder keyField() =>
        find.descendant(of: find.widgetWithText(ConnectionRow, "OpenAI"), matching: find.byType(TextField));

    String? saved(FlowApp app) => app.container.read(connectionsProvider).value?[Backend.openai]?.apiKey;

    testFlow("saves itself soon after it is pasted, without Enter", (app) async {
      await openSettings(app);
      await app.tester.enterText(keyField(), "sk-pasted");
      await app.tester.pump(ConnectionRow.saveDelay);
      await app.settle();

      expect(saved(app), "sk-pasted");
      expect(find.textContaining("OpenAI"), findsWidgets);
    });

    testFlow("saves on leaving Settings straight after pasting", (app) async {
      await openSettings(app);
      await app.tester.enterText(keyField(), "sk-pasted");

      await app.press(LogicalKeyboardKey.escape);

      expect(find.byType(SettingsPage), findsNothing);
      expect(saved(app), "sk-pasted");
    });

    testFlow("the service refusing it shows as rejected, not ready", (app) async {
      app.model.listing = const llm.AuthError("Invalid OpenAI API key");
      await openSettings(app);
      await app.tester.enterText(keyField(), "sk-wrong");
      await app.tester.pump(ConnectionRow.saveDelay);
      await app.settle();

      expect(
        find.descendant(of: find.widgetWithText(ConnectionRow, "OpenAI"), matching: find.text("Key rejected")),
        findsOneWidget,
      );
    });

    testFlow("a service that cannot answer does not call the key wrong", (app) async {
      await openSettings(app);
      await app.tester.enterText(keyField(), "sk-pasted");
      await app.tester.pump(ConnectionRow.saveDelay);
      await app.settle();

      expect(
        find.descendant(of: find.widgetWithText(ConnectionRow, "OpenAI"), matching: find.text("Saved, not checked")),
        findsOneWidget,
      );
    });
  });

  group("a local server", () {
    testFlow("started while the app runs shows its models when the window comes back", (app) async {
      await app.read(connectionsProvider.notifier).save(const Connection(backend: Backend.ollama, enabled: true));
      app.model.listing = const llm.HttpError("Connection refused");
      await openSettings(app);
      await app.settle();
      Finder status(String text) =>
          find.descendant(of: find.widgetWithText(ConnectionRow, "Ollama"), matching: find.text(text));
      expect(status("Not reachable"), findsOneWidget);

      app.model.listing = const [llm.AIModel(id: "llama3.2:latest")];
      app.window.emit(WindowEvent.focused);
      await app.settle();

      expect(status("Ready, 1 model"), findsOneWidget);
    });
  });

  group("the rewrites to keep", () {
    testFlow("a typed limit asks once, whether by Enter or by leaving the field", (app) async {
      await openSettings(app);
      await app.tester.tap(find.text("History"));
      await app.settle();
      final history = app.container.read(historyProvider.notifier);
      for (var i = 0; i < 3; i++) {
        await history.add(
          HistoryEntry(
            at: DateTime(2026, 11, 3, 12, i),
            input: "before $i",
            output: "after $i",
            profiles: const [],
            instructions: const [],
            picked: const [],
            words: "",
            decisions: const [],
          ),
        );
      }
      await app.settle();
      await app.tester.tap(find.text("100"));
      await app.settle();
      await app.tester.tap(find.text("Custom").last);
      await app.settle();
      await app.tester.enterText(find.byType(TextField), "1");

      await app.tester.testTextInput.receiveAction(TextInputAction.done);
      await app.settle();

      expect(find.text("Keep fewer rewrites"), findsOneWidget);
      await app.tester.tap(find.text("Remove them"));
      await app.settle();
      expect(find.text("Keep fewer rewrites"), findsNothing);
      expect(app.container.read(historyProvider).value, hasLength(1));
      expect(app.container.read(historyLimitProvider).value, 1);
    });

    Future<void> openHistory(FlowApp app) async {
      await openSettings(app);
      await app.tester.tap(find.text("History"));
      await app.settle();
    }

    Future<void> saveRewrites(FlowApp app, int count) async {
      final history = app.container.read(historyProvider.notifier);
      for (var i = 0; i < count; i++) {
        await history.add(
          HistoryEntry(
            at: DateTime(2026, 11, 3, 12, i),
            input: "before $i",
            output: "after $i",
            profiles: const [],
            instructions: const [],
            picked: const [],
            words: "",
            decisions: const [],
          ),
        );
      }
    }

    Future<void> pick(FlowApp app, String option) async {
      await app.tester.tap(
        find.text(
          app.container.read(historyLimitProvider).value == 0
              ? "Off"
              : "${app.container.read(historyLimitProvider).value}",
        ),
      );
      await app.settle();
      await app.tester.tap(find.text(option).last);
      await app.settle();
    }

    int saved(FlowApp app) => app.container.read(historyProvider).value!.length;
    int limit(FlowApp app) => app.container.read(historyLimitProvider).value!;

    testFlow("a preset is the new limit for new rewrites", (app) async {
      await openHistory(app);
      await pick(app, "20");
      expect(limit(app), 20);

      await saveRewrites(app, 25);
      expect(saved(app), 20);
    });

    testFlow("a lower limit asks first and Cancel changes nothing", (app) async {
      await saveRewrites(app, 25);
      await openHistory(app);

      await pick(app, "20");
      expect(find.text("This removes the 5 oldest rewrites. This cannot be undone."), findsOneWidget);
      await app.tester.tap(find.text("Cancel"));
      await app.settle();

      expect(limit(app), HistoryLimit.standard);
      expect(saved(app), 25);
    });

    testFlow("Esc leaves the question, not Settings, and changes nothing", (app) async {
      await saveRewrites(app, 25);
      await openHistory(app);

      await pick(app, "20");
      await app.press(LogicalKeyboardKey.escape);

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text("Keep fewer rewrites"), findsNothing);
      expect(limit(app), HistoryLimit.standard);
      expect(saved(app), 25);
    });

    testFlow("the number holds still while its question is open", (app) async {
      await saveRewrites(app, 3);
      await openHistory(app);
      await pick(app, "Custom");
      final field = find.byType(TextField);

      await app.tester.enterText(field, "2");
      await app.tester.testTextInput.receiveAction(TextInputAction.done);
      await app.settle();
      expect(find.text("Keep fewer rewrites"), findsOneWidget);
      expect(app.tester.widget<TextField>(field).readOnly, isTrue);

      await app.tester.tap(find.text("Remove them"));
      await app.settle();
      expect(app.tester.widget<TextField>(field).readOnly, isFalse);
      expect(saved(app), 2);
    });

    testFlow("picking again replaces the question", (app) async {
      await saveRewrites(app, 25);
      await openHistory(app);

      await pick(app, "20");
      await pick(app, "100");

      expect(find.text("Keep fewer rewrites"), findsNothing);
      expect(limit(app), 100);
      expect(saved(app), 25);
    });

    testFlow("a lower limit removes the oldest once confirmed", (app) async {
      await saveRewrites(app, 25);
      await openHistory(app);

      await pick(app, "20");
      await app.tester.tap(find.text("Remove them"));
      await app.settle();

      expect(limit(app), 20);
      expect(saved(app), 20);
      expect(app.container.read(historyProvider).value!.first.input, "before 24", reason: "the newest stay");
    });

    testFlow("Off can keep what is saved, and saves nothing new", (app) async {
      await saveRewrites(app, 3);
      await openHistory(app);

      await pick(app, "Off");
      await app.tester.tap(find.text("Keep them"));
      await app.settle();

      expect(limit(app), 0);
      expect(saved(app), 3);
      await saveRewrites(app, 1);
      expect(saved(app), 3);
    });

    testFlow("Off can delete what is saved", (app) async {
      await saveRewrites(app, 3);
      await openHistory(app);

      await pick(app, "Off");
      await app.tester.tap(find.text("Delete them"));
      await app.settle();

      expect(saved(app), 0);
    });

    testFlow("a custom number is any whole number up to the maximum", (app) async {
      await openHistory(app);
      await pick(app, "Custom");
      final field = find.byType(TextField);

      await app.tester.enterText(field, "${HistoryLimit.max + 1}");
      await app.tester.testTextInput.receiveAction(TextInputAction.done);
      await app.settle();
      expect(find.text("Use a whole number from 1 to ${HistoryLimit.max}."), findsOneWidget);
      expect(limit(app), HistoryLimit.standard);

      await app.tester.enterText(field, "250");
      await app.tester.testTextInput.receiveAction(TextInputAction.done);
      await app.settle();
      expect(limit(app), 250);
    });

    testFlow("an older off switch still counts as off", (app) async {
      final prefs = await app.container.read(preferencesProvider.future);
      await prefs.setBool("history_enabled", false);
      app.container.invalidate(historyLimitProvider);

      expect(await app.container.read(historyLimitProvider.future), 0);
    });
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

  group("the instruction editor", () {
    Future<void> openInstructions(FlowApp app) async {
      await openSettings(app);
      await app.tester.tap(find.text("Instructions"));
      await app.settle();
    }

    Future<void> edit(FlowApp app, String name) async {
      await openInstructions(app);
      await app.tester.tap(find.text(name).first);
      await app.settle();
      expect(find.text("Edit $name"), findsOneWidget);
    }

    Future<void> tap(FlowApp app, String text) async {
      await app.tester.tap(find.text(text));
      await app.settle();
    }

    /// The button at the end of the list; the list builds it before it shows.
    Future<void> scrollToNew(FlowApp app) async {
      await app.tester.scrollUntilVisible(find.text("New instruction"), 200, scrollable: find.byType(Scrollable).last);
      await app.tester.ensureVisible(find.text("New instruction"));
      await app.settle();
    }

    const casual = InstructionId("casual");

    testFlow("an instruction's group is picked from a list that opens in place", (app) async {
      await edit(app, "Casual");

      await tap(app, "Tone");
      await tap(app, "Length");
      expect(find.text("Audience"), findsNothing, reason: "picking closes it");

      await tap(app, "Save");
      expect(app.library[casual]?.group, const GroupId("length"));
      expect(find.text("Instructions"), findsNWidgets(2), reason: "back on the list");
    });

    testFlow("Save writes the new name and text", (app) async {
      await edit(app, "Casual");
      final nameField = app.tester.widget<TextField>(find.byType(TextField).first);
      expect(nameField.focusNode?.hasFocus, isTrue);
      expect(nameField.controller?.selection, const TextSelection.collapsed(offset: 6), reason: "caret after the name");

      await app.tester.enterText(find.byType(TextField).first, "Relaxed");
      await app.tester.enterText(find.byType(TextField).last, "Be relaxed.");
      await tap(app, "Save");

      expect(app.library[casual]?.name, "Relaxed");
      expect(app.library[casual]?.text, "Be relaxed.");
    });

    testFlow("New instruction adds one", (app) async {
      await openInstructions(app);
      await scrollToNew(app);
      final before = app.library.instructions.length;
      await tap(app, "New instruction");
      expect(find.text("Delete"), findsNothing, reason: "nothing to delete yet");

      await app.tester.enterText(find.byType(TextField).first, "Pirate");
      await app.tester.enterText(find.byType(TextField).last, "Talk like a pirate.");
      await tap(app, "Save");

      expect(app.library.instructions, hasLength(before + 1));
      expect(app.library.instructions.last.name, "Pirate");
      expect(app.library.instructions.last.text, "Talk like a pirate.");
    });

    testFlow("Delete removes it", (app) async {
      await edit(app, "Casual");
      await tap(app, "Delete");
      expect(app.library[casual], isNull);
    });

    testFlow("a name the library refuses says why and keeps the editor open", (app) async {
      await edit(app, "Casual");

      await app.tester.enterText(find.byType(TextField).first, "");
      await tap(app, "Save");

      expect(find.text("Every instruction needs an id and a name."), findsOneWidget);
      expect(find.text("Edit Casual"), findsOneWidget);
      expect(app.library[casual]?.name, "Casual");
    });

    for (final (way, leave) in [
      ("Cancel", (FlowApp app) => tap(app, "Cancel")),
      ("Esc", (FlowApp app) => app.press(LogicalKeyboardKey.escape)),
      ("the back arrow", (FlowApp app) => app.tester.tap(find.byIcon(Icons.arrow_back)).then((_) => app.settle())),
    ]) {
      testFlow("$way goes back to the list without saving, at the same scroll", (app) async {
        await openInstructions(app);
        final list = find.byType(Scrollable).last;
        await scrollToNew(app);
        final scrolled = app.tester.state<ScrollableState>(list).position.pixels;
        await tap(app, "New instruction");

        await app.tester.enterText(find.byType(TextField).first, "Pirate");
        final before = app.library.instructions.length;
        await leave(app);

        expect(find.byType(SettingsPage), findsOneWidget);
        expect(find.text("New instruction"), findsOneWidget, reason: "back on the list");
        expect(app.library.instructions, hasLength(before));
        expect(app.tester.state<ScrollableState>(find.byType(Scrollable).last).position.pixels, scrolled);

        await app.press(LogicalKeyboardKey.escape);
        expect(find.byType(SettingsPage), findsNothing, reason: "the next Esc leaves Settings");
      });
    }

    testFlow("the second click of a double click does not reach the editor", motion: true, (app) async {
      await openInstructions(app);
      await app.tester.tap(find.text("Casual").first);
      await app.tester.pump(const Duration(milliseconds: 100));

      await app.tester.tap(find.text("Delete"), warnIfMissed: false);
      await app.tester.pump(const Duration(seconds: 1));
      expect(app.library[casual], isNotNull);

      await tap(app, "Delete");
      expect(app.library[casual], isNull, reason: "it works once the editor is in place");
    });

    testFlow("another page closes the editor without saving", (app) async {
      await edit(app, "Casual");

      await app.tester.enterText(find.byType(TextField).first, "Relaxed");
      await tap(app, "History");
      await tap(app, "Instructions");

      expect(find.text("Edit Casual"), findsNothing);
      expect(app.library[casual]?.name, "Casual");
    });
  });
}
