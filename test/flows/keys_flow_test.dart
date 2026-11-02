import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/keys_view.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/bar/command_bar.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/session/commands.dart";
import "package:grammar_guard/session/key_tips.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:hotkey_manager/hotkey_manager.dart";

import "../support/test_flow.dart";

void main() {
  Future<void> rewrite(FlowApp app, {String text = "helo wrld", List<String> reply = const ["Hello world."]}) async {
    // The hotkey hides a popup that is showing.
    await app.window.hide();
    app
      ..frontApp = discord
      ..selection = text;
    app.model.reply(reply);
    await app.pressHotkey();
  }

  Future<void> pressQuestionMark(FlowApp app) async {
    await app.tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await app.tester.sendKeyEvent(LogicalKeyboardKey.slash);
    await app.tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await app.settle();
  }

  Finder footerHint(String what) => find.descendant(of: find.byType(KeyHints), matching: find.text(what));

  /// What the tip says, when one shows.
  String? shownTip(FlowApp app) => app.read(keyTipsProvider).value?.shown?.tip;

  group("the footer", () {
    testFlow("names each review key by what it does", (app) async {
      await rewrite(app);

      for (final what in ["next", "previous", "accept", "reject", "all keys"]) {
        expect(footerHint(what), findsOneWidget, reason: what);
      }
      expect(find.text("keep, undo"), findsNothing);
    });

    testFlow("says Enter accepts what is still open, and how many", (app) async {
      await rewrite(app);
      final open = app.read(reviewProvider)!.getPendingChangeCount();
      expect(open, greaterThan(0));
      expect(footerHint("paste, accept $open"), findsOneWidget);

      for (var i = 0; i < open; i++) {
        await app.press(LogicalKeyboardKey.keyY);
        await app.press(LogicalKeyboardKey.keyN);
      }
      expect(footerHint("paste back"), findsOneWidget);
    });

    testFlow("offers a way on while writing", (app) async {
      app
        ..frontApp = discord
        ..selection = "helo";
      app.model.midStream(["Hel"]);
      await app.pressHotkey();

      expect(footerHint("change model"), findsOneWidget);
      expect(footerHint("stop"), findsOneWidget);
      expect(footerHint("all keys"), findsOneWidget);
    });

    testFlow("hints work with a mouse", (app) async {
      await rewrite(app);

      await app.tester.tap(footerHint("all keys"));
      await app.settle();

      expect(find.byType(KeysView), findsOneWidget);
    });
  });

  group("w", () {
    testFlow("shows why, where ? used to", (app) async {
      await rewrite(app);
      app.model.says('{"reasons": [{"id": 0, "reason": "Fixes the spelling."}]}');

      await app.press(LogicalKeyboardKey.keyW);

      expect(find.textContaining("Fixes the spelling."), findsOneWidget);
    });
  });

  group("the Keys view", () {
    testFlow("? swaps it in for the result and ? or Esc swap back, without hiding the window", (app) async {
      await rewrite(app);

      await pressQuestionMark(app);
      expect(find.byType(KeysView), findsOneWidget);
      expect(find.byType(ResultView), findsNothing);
      await pressQuestionMark(app);
      expect(find.byType(ResultView), findsOneWidget);

      await pressQuestionMark(app);
      await app.press(LogicalKeyboardKey.escape);
      expect(find.byType(ResultView), findsOneWidget);
      expect(app.visible, isTrue);
    });

    testFlow("lists what works now: with nothing captured, no review keys", (app) async {
      await app.tester.pump();
      app.window.emit(WindowEvent.reopened);
      await app.settle();

      await pressQuestionMark(app);

      expect(find.text(AppCommand.clipboard.title), findsOneWidget);
      expect(find.text(AppCommand.next.title), findsNothing);
      expect(find.text(AppCommand.compare.title), findsNothing);
    });

    testFlow("with a finished rewrite, lists every command with a key", (app) async {
      await rewrite(app);

      await pressQuestionMark(app);

      for (final command in AppCommand.values) {
        if (command.keys.isEmpty) continue;
        expect(find.text(command.title), findsOneWidget, reason: command.name);
      }
    });

    testFlow("lists the pinned instructions by name", (app) async {
      await rewrite(app);
      final pinned = app.library.pinned(1)!;

      await pressQuestionMark(app);

      expect(find.descendant(of: find.byType(KeysView), matching: find.text(pinned.name)), findsOneWidget);
    });

    testFlow("a click does what the key does, and goes back to the text", (app) async {
      await rewrite(app);
      await pressQuestionMark(app);

      await app.tester.tap(find.text(AppCommand.changeModel.title));
      await app.settle();

      expect(find.byType(KeysView), findsNothing);
      expect(find.byType(CommandBar), findsOneWidget);
      expect(app.read(sessionProvider).bar?.query, "@");
    });

    testFlow("a key works from inside it too, and goes back to the text", (app) async {
      await rewrite(app);
      await pressQuestionMark(app);

      await app.press(LogicalKeyboardKey.keyH);

      expect(find.byType(KeysView), findsNothing);
      expect(find.text("Original"), findsOneWidget);
    });

    testFlow("shows the global shortcuts, without making them clickable", (app) async {
      await rewrite(app);
      await pressQuestionMark(app);

      final row = find.widgetWithText(KeyRow, "Rewrite from any app");
      expect(app.tester.widget<KeyRow>(row).onTap, isNull);
      expect(find.text("Choose the model first, from any app"), findsNothing);
    });

    testFlow("going back keeps the preview and side by side as they were", (app) async {
      await rewrite(app);
      await app.press(LogicalKeyboardKey.keyV);
      expect(app.read(previewProvider), isTrue);

      await pressQuestionMark(app);
      await pressQuestionMark(app);

      expect(app.read(previewProvider), isTrue);
    });

    testFlow("a new capture leaves it for the result", (app) async {
      await rewrite(app);
      await pressQuestionMark(app);

      await rewrite(app, text: "another txt", reply: ["Another text."]);

      expect(find.byType(KeysView), findsNothing);
    });
  });

  group("the bar", () {
    testFlow("> lists every command with its key", (app) async {
      await rewrite(app);
      await app.press(LogicalKeyboardKey.space);
      await app.tester.enterText(find.byType(TextField), ">");
      await app.settle();

      final inBar = [
        for (final command in AppCommand.values)
          if (command.inBar) command,
      ];
      expect(inBar.length, greaterThan(8), reason: "more than the bar's usual eight rows");
      // The last one is further down than fits: scroll to prove it is there.
      await app.tester.scrollUntilVisible(find.text(inBar.last.title), 100, scrollable: find.byType(Scrollable).last);
      expect(find.text(inBar.last.title), findsOneWidget);
    });

    testFlow("every command runs from its row", (app) async {
      await rewrite(app);
      await app.press(LogicalKeyboardKey.space);
      await app.tester.enterText(find.byType(TextField), ">side by");
      await app.settle();

      await app.press(LogicalKeyboardKey.enter);

      expect(find.text("Original"), findsOneWidget);
      expect(find.byType(CommandBar), findsNothing);
    });

    testFlow("m starts at the current model, then the rest, with their prices", (app) async {
      await rewrite(app);
      final current = app.read(runRequestProvider)!.model;

      await app.press(LogicalKeyboardKey.keyM);

      final rows = app.tester.widgetList<PillRow>(find.byType(PillRow)).toList();
      expect(find.text(current.label), findsWidgets);
      expect(rows.first.current, isTrue);
      expect(
        find.descendant(of: find.byWidget(rows.first), matching: find.text(current.label)),
        findsOneWidget,
        reason: "the current model comes first",
      );
      expect(find.textContaining(" in, "), findsWidgets);
    });

    testFlow("m lists every model, not just the first eight", (app) async {
      await rewrite(app);
      await app.press(LogicalKeyboardKey.keyM);

      expect(find.byType(PillRow).evaluate().length, greaterThan(1));
      final session = app.read(sessionProvider);
      expect(session.bar?.query, "@");
      // More than the usual eight rows: the list scrolls past them.
      final scrollable = find.byType(Scrollable).last;
      await app.tester.drag(scrollable, const Offset(0, -2000));
      await app.settle();
      final position = app.tester.state<ScrollableState>(scrollable).position;
      expect(position.maxScrollExtent, greaterThan(0));
    });
  });

  group("tips", () {
    testFlow("one per rewrite, and it moves on to the next", (app) async {
      await rewrite(app);
      final first = shownTip(app);
      expect(first, isNotNull);
      expect(find.text(first!), findsOneWidget);

      await rewrite(app, text: "another txt", reply: ["Another text."]);

      expect(shownTip(app), isNot(first));
    });

    testFlow("the same text again keeps the tip, so nothing moves while reading", (app) async {
      await rewrite(app);
      final first = shownTip(app);

      await app.window.hide();
      await app.pressHotkey();

      expect(shownTip(app), first);
    });

    testFlow("goes the moment its key is used, and does not come back", (app) async {
      await rewrite(app);
      expect(app.read(keyTipsProvider).value?.shown, AppCommand.changeModel);

      await app.press(LogicalKeyboardKey.keyM);
      await app.press(LogicalKeyboardKey.escape);

      expect(app.read(keyTipsProvider).value?.shown, isNull);
      for (final text in ["one txt", "two txt", "three txt"]) {
        await rewrite(app, text: text, reply: ["Fixed $text."]);
        expect(app.read(keyTipsProvider).value?.shown, isNot(AppCommand.changeModel));
      }
    });

    testFlow("a used key stays used after a restart", (app) async {
      await rewrite(app);
      await app.press(LogicalKeyboardKey.keyM);
      await app.press(LogicalKeyboardKey.escape);
      await app.settle();

      app.container.invalidate(keyTipsProvider);
      await app.read(keyTipsProvider.future);

      expect(app.read(keyTipsProvider).value?.used, contains(AppCommand.changeModel));
    });

    testFlow("can be turned off", (app) async {
      await rewrite(app);
      await app.read(keyTipsProvider.notifier).setEnabled(enabled: false);
      await app.settle();

      expect(app.read(keyTipsProvider).value?.shown, isNull);
      expect(find.text(AppCommand.changeModel.tip!), findsNothing);
    });

    test("every tip has its words, and every word is for a key", () {
      for (final command in tipOrder) {
        expect(command.tip, isNotNull, reason: command.name);
        expect(command.keys, isNotEmpty, reason: command.name);
      }
    });
  });

  group("choose first", () {
    final chooseKey = HotKey(
      key: PhysicalKeyboardKey.keyM,
      modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
      scope: HotKeyScope.system,
    );

    Future<void> setUp(FlowApp app) async {
      await app.read(chooseFirstHotkeySettingProvider.notifier).set(chooseKey);
      await app.settle();
      // Changing a shortcut shows the window, and a hotkey hides a shown popup.
      await app.window.hide();
      app
        ..frontApp = discord
        ..selection = "helo";
    }

    Future<void> pressChooseFirst(FlowApp app) async {
      app.hotkey.press(HotkeyPurpose.chooseFirst);
      await app.settle();
    }

    testFlow("is off until set", (app) async {
      expect(app.hotkey.registered.keys, [HotkeyPurpose.rewrite]);
      app
        ..frontApp = discord
        ..selection = "helo";

      await pressChooseFirst(app);

      expect(app.visible, isFalse);
    });

    testFlow("opens on the models with the text, and sends nothing", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);

      await pressChooseFirst(app);

      expect(app.visible, isTrue);
      expect(find.byType(CommandBar), findsOneWidget);
      expect(app.read(sessionProvider).bar?.query, "@");
      expect(app.model.calls, isEmpty);
    });

    testFlow("sends to the model picked, and only then", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);
      await pressChooseFirst(app);
      expect(app.model.calls, isEmpty);

      final usual = app.read(modelCatalogProvider).value!.first.label;
      await app.tester.enterText(find.byType(TextField), "@sonnet");
      await app.settle();
      await app.press(LogicalKeyboardKey.enter);

      expect(app.model.calls, hasLength(1));
      expect(app.read(runRequestProvider)!.model.label, contains("Sonnet"));
      expect(usual, isNot(contains("Sonnet")), reason: "the pick must not be the model it would use anyway");
    });

    testFlow("Esc leaves it waiting, and says so", (app) async {
      await setUp(app);
      await pressChooseFirst(app);

      await app.press(LogicalKeyboardKey.escape);

      expect(find.text("Nothing sent yet."), findsOneWidget);
      expect(footerHint("use the usual model"), findsWidgets);
      expect(find.text("try again"), findsNothing, reason: "nothing was tried yet");
      expect(app.model.calls, isEmpty);
    });

    testFlow("r goes ahead with the usual model", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);
      await pressChooseFirst(app);
      await app.press(LogicalKeyboardKey.escape);

      await app.press(LogicalKeyboardKey.keyR);

      expect(app.model.calls, hasLength(1));
    });

    testFlow("other choices while waiting still send nothing", (app) async {
      await setUp(app);
      await pressChooseFirst(app);
      await app.press(LogicalKeyboardKey.escape);

      await app.press(LogicalKeyboardKey.bracketRight);
      await app.press(LogicalKeyboardKey.digit1);

      expect(app.model.calls, isEmpty);
      expect(find.text("Nothing sent yet."), findsOneWidget);
    });

    testFlow("Enter while waiting explains, and sends nothing", (app) async {
      await setUp(app);
      await pressChooseFirst(app);
      await app.press(LogicalKeyboardKey.escape);

      await app.press(LogicalKeyboardKey.enter);

      expect(app.bridge.pasted, isEmpty);
      expect(app.read(sessionProvider).notice, contains("Nothing sent yet"));
    });

    testFlow("the same text as last time also waits for the pick", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);
      await app.pressHotkey();
      expect(app.model.calls, hasLength(1));
      await app.window.hide();

      await pressChooseFirst(app);

      expect(find.byType(CommandBar), findsOneWidget);
      expect(app.read(sessionProvider).hold, RunHold.choosing);
      expect(app.model.calls, hasLength(1));
    });

    testFlow("a model saved for this app is a pick too, and runs on the saved one", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);
      await pressChooseFirst(app);

      final usual = app.read(modelCatalogProvider).value!.first.label;
      await app.tester.enterText(find.byType(TextField), "@sonnet");
      await app.settle();
      await app.tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await app.tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await app.tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await app.settle();

      expect(app.read(sessionProvider).hold, RunHold.none);
      expect(app.model.calls, hasLength(1));
      expect(app.read(runRequestProvider)!.model.label, contains("Sonnet"));
      expect(usual, isNot(contains("Sonnet")), reason: "the pick must not be the model it would use anyway");
    });

    testFlow("the normal shortcut still rewrites at once", (app) async {
      await setUp(app);
      app.model.reply(["Hello."]);

      await app.pressHotkey();

      expect(find.byType(CommandBar), findsNothing);
      expect(app.model.calls, hasLength(1));
    });

    testFlow("one shortcut refused leaves the other working", (app) async {
      await setUp(app);
      expect(app.read(isPopupProvider), isTrue);
      expect(app.hotkey.registered.keys, containsAll(HotkeyPurpose.values));

      await app.read(chooseFirstHotkeySettingProvider.notifier).set(null);
      await app.settle();

      expect(app.hotkey.registered.keys, [HotkeyPurpose.rewrite]);
      expect(app.read(isPopupProvider), isTrue);
    });

    testFlow("Settings records it, refuses the other shortcut's keys, and turns it off", (app) async {
      await app.press(LogicalKeyboardKey.escape);
      app.window.emit(WindowEvent.reopened);
      await app.settle();
      await app.tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await app.tester.sendKeyEvent(LogicalKeyboardKey.comma);
      await app.tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await app.settle();
      await app.tester.tap(find.text("General"));
      await app.settle();
      expect(find.text("Off"), findsOneWidget);

      await app.tester.tap(find.text("Set"));
      await app.settle();
      await app.tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await app.tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await app.tester.sendKeyEvent(LogicalKeyboardKey.keyG);
      await app.settle();
      expect(find.text("The other shortcut uses these keys."), findsOneWidget);
      expect(app.read(chooseFirstHotkeySettingProvider).value, isNull);

      await app.tester.sendKeyEvent(LogicalKeyboardKey.keyM);
      await app.tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await app.tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      await app.settle();
      expect(app.read(chooseFirstHotkeySettingProvider).value?.physicalKey, PhysicalKeyboardKey.keyM);
      expect(app.hotkey.registered.keys, containsAll(HotkeyPurpose.values));

      await app.tester.tap(find.text("Turn off"));
      await app.settle();
      expect(app.read(chooseFirstHotkeySettingProvider).value, isNull);
      expect(find.text("Off"), findsOneWidget);
    }, platform: TargetPlatform.macOS);
  });

  group("the README", () {
    test("lists every key under its own name", () {
      final readme = File("README.md").readAsStringSync();
      for (final command in AppCommand.values) {
        if (command.keys.isEmpty) continue;
        final keys = command.keys.map((key) => "<kbd>$key</kbd>").join("+");
        expect(readme, contains("| $keys | ${command.title}"), reason: command.name);
      }
    });
  });

  group("the table", () {
    test("gives no two commands the same key", () {
      final seen = <String, AppCommand>{};
      for (final command in AppCommand.values) {
        for (final activator in command.activators.cast<SingleActivator>()) {
          final name = [
            activator.trigger.keyId,
            activator.shift,
            activator.meta,
            activator.control,
            activator.alt,
          ].join();
          expect(seen[name], isNull, reason: "${command.name} and ${seen[name]?.name}");
          seen[name] = command;
        }
      }
    });

    test("says what is drawn: every command with a key draws it, and the reverse", () {
      for (final command in AppCommand.values) {
        expect(command.keys.isEmpty, command.activators.isEmpty, reason: command.name);
      }
    });
  });
}
