// `shots` (devenv): the real app in a real macOS window, with a fake model and
// a fake source app, stepped through every screen with real key events.
// Each state is captured with `screencapture -l` (this window only, glass
// and all) into SHOTS_DIR, then the app quits. Not a test (no _test suffix), so CI never runs
// it. The popup must stay in front: clicking elsewhere hides it.
import "dart:io";

import "package:file/memory.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/platform/real/window_manager_window.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/tray.dart";
import "package:grammar_guard/app/window_setup.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/fakes.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/scripted_llm.dart";
import "package:grammar_guard/review/review.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:window_manager/window_manager.dart";

const _out = String.fromEnvironment("SHOTS_DIR", defaultValue: "/tmp/gg_shots");
const _discord = SourceApp(id: "com.hnc.discord", name: "Discord", processId: 1);
const _notes = SourceApp(id: "com.apple.notes", name: "Notes", processId: 2);

const _discordText =
    "hey team, i think we should of shipped this friday but the tests wasnt ready. "
    "lets aim for monday, if anyone has concerns lmk";
const _discordFixed = [
  "Hey team, ",
  "I think ",
  "we should ",
  "have shipped ",
  "this Friday, ",
  "but the ",
  "tests weren't ",
  "ready. ",
  "Let's aim ",
  "for Monday. ",
  "If anyone ",
  "has concerns, ",
  "let me know.",
];
const _enhanced = [
  "Hey team, ",
  "we should have ",
  "shipped Friday, ",
  "but the tests ",
  "weren't ready. ",
  "Let's aim for Monday. ",
  "Any concerns? ",
  "Let me know.",
];
const _notesText =
    "Meeting notes: the onboarding flow is to long and users drop of at step three. "
    "We could merge step two and three, and remove the optional survey alltogether.";
const _notesFixed = [
  "Meeting notes: ",
  "the onboarding flow ",
  "is too long, ",
  "and users drop off ",
  "at step three. ",
  "We could merge steps two and three ",
  "and remove the optional survey altogether.",
];

void main() {
  // Frames as the app asks for them until the window has its size; see
  // prepareWindow below.
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("screenshot tour", (tester) async {
    Directory(_out).createSync(recursive: true);
    for (final old in Directory(_out).listSync().whereType<File>()) {
      old.deleteSync();
    }
    await prepareWindow();
    // Every frame from now on, as on screen. Not earlier: frames drawn while
    // prepareWindow resizes the hidden window hit a Metal surface of the old
    // size, and Impeller aborted the app (about one run in two).
    await Future<void>.delayed(const Duration(milliseconds: 300));
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({"claude_api_key": "demo"});
    final files = MemoryFileSystem();
    final hotkey = FakeHotkey();
    final bridge = FakeTextBridge(selection: _discordText, source: _discord);
    final model = ScriptedLlm()
      ..delay = const Duration(milliseconds: 90)
      ..reply(_discordFixed) // the first run, slow enough to see it stream
      ..reply(_enhanced) // ] steps to Enhance
      ..reply(_discordFixed.map((c) => c.replaceAll("Hey", "Hi")).toList()) // compare with another model
      // Applying the assistant's proposal changes the Discord profile, so
      // the text is rewritten once more with it.
      ..reply(["Hey team, ", "we should have shipped Friday, ", "but tests weren't ready. ", "Monday? Let me know."])
      ..reply(_notesFixed) // the Notes text, light theme
      ..fail("429: rate limit reached for this key. Try again in a minute.")
      ..reply(_notesFixed) // R after the error
      // ? asks the same model why each change was made.
      ..says(
        '{"reasons": [{"id": 0, "reason": "Capitalize the first word."}, '
        '{"id": 1, "reason": "I is always capitalized."}, '
        '{"id": 2, "reason": "Should have, not should of."}, '
        '{"id": 3, "reason": "Days of the week are capitalized."}]}',
      )
      // The assistant: two proposals, then a summary.
      ..callsTool("put_instruction", {
        "id": "friendly-short",
        "name": "Friendly and short",
        "text": "Keep it warm and casual, cut filler, at most three sentences.",
      })
      ..callsTool("put_profile", {
        "name": "Discord",
        "apps": ["com.hnc.discord", "discord.exe", "discord"],
        "use": ["discord", "friendly-short"],
      })
      ..says("I added a Friendly and short instruction and switched the Discord profile to it.");

    final container = ProviderContainer(
      overrides: [
        llmGatewayProvider.overrideWithValue(model),
        globalHotkeyProvider.overrideWithValue(hotkey),
        textBridgeProvider.overrideWithValue(bridge),
        fileSystemProvider.overrideWithValue(files),
        appSupportDirProvider.overrideWith((ref) async => files.directory("/support")..createSync()),
        trayProvider.overrideWith((ref) async {}),
        // Started like a login item: hidden until the hotkey shows it.
        launchedInBackgroundProvider.overrideWithValue(true),
        desktopWindowProvider.overrideWith((ref) {
          final window = WindowManagerWindow(windowManager);
          ref.onDispose(window.dispose);
          return _StaysUp(window);
        }),
      ],
    );
    addTearDown(container.dispose);
    // Started like main.dart does at login. pumpWidget would wait for a
    // frame, and the popup draws none until the hotkey shows it; showing
    // it early to get one is not what the app does and upsets Metal.
    runApp(UncontrolledProviderScope(container: container, child: const GrammarGuardApp()));
    await _wait(tester, 2000);

    var n = 0;
    // Only this app's own window is ever captured (-l, by window number),
    // never the screen region: whatever else is open on the desktop must
    // not end up in a screenshot. A hidden window is skipped, not captured.
    Future<void> shot(String name) async {
      await _wait(tester, 700); // let the motion finish
      final file = "$_out/${(++n).toString().padLeft(2, "0")}-$name.png";
      if (!await windowManager.isVisible()) {
        // ignore: avoid_print
        print("SKIP $file: the window is hidden");
        return;
      }
      final result = await Process.run("screencapture", ["-x", "-o", "-l${await windowManager.getId()}", file]);
      if (result.exitCode != 0 && File(file).existsSync()) File(file).deleteSync();
      // ignore: avoid_print
      print(
        "SHOT $file ${result.exitCode == 0 ? "" : result.stderr} "
        "cursor=${container.read(reviewProvider)?.vimState.cursorPosition} "
        "life=${binding.lifecycleState} frames=${binding.framesEnabled} focus=${FocusManager.instance.primaryFocus}",
      );
    }

    // A real hotkey press makes the app active. Synthetic input cannot
    // (macOS 14 refuses), and Flutter parks keyboard focus while the app is
    // inactive, so the tour tells Flutter what the OS would have.
    void activate() => binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    Future<void> key(LogicalKeyboardKey key, {LogicalKeyboardKey? hold, int ms = 400}) async {
      activate();
      if (hold != null) await tester.sendKeyDownEvent(hold);
      await tester.sendKeyEvent(key);
      if (hold != null) await tester.sendKeyUpEvent(hold);
      await _wait(tester, ms);
    }

    Future<void> type(String text) async {
      activate();
      final field = tester.widget<EditableText>(find.byType(EditableText).last);
      // As typed: the cursor after the text, nothing selected.
      field.controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      await _wait(tester, 400);
    }

    // Hotkey in Discord: capture, then the result streams in.
    hotkey.press();
    await _wait(tester, 900);
    await shot("streaming");
    await _wait(tester, 1800);
    await shot("review");

    model.delay = const Duration(milliseconds: 25);
    await key(LogicalKeyboardKey.keyN);
    await shot("review-next-change");
    await key(LogicalKeyboardKey.keyY);
    await key(LogicalKeyboardKey.keyX);
    await shot("review-kept-and-undone");
    await key(LogicalKeyboardKey.keyU);
    await key(LogicalKeyboardKey.keyU);

    await key(LogicalKeyboardKey.slash, hold: LogicalKeyboardKey.shiftLeft, ms: 1200);
    await shot("why");
    await key(LogicalKeyboardKey.slash, hold: LogicalKeyboardKey.shiftLeft);

    await key(LogicalKeyboardKey.keyH);
    await shot("side-by-side");
    await key(LogicalKeyboardKey.keyH);
    await key(LogicalKeyboardKey.keyV);
    await shot("markdown-preview");
    await key(LogicalKeyboardKey.keyV);

    await key(LogicalKeyboardKey.space);
    await shot("bar");
    await type("form");
    await shot("bar-search");
    await key(LogicalKeyboardKey.escape);
    await key(LogicalKeyboardKey.keyM);
    await shot("bar-models");
    await key(LogicalKeyboardKey.escape);

    await key(LogicalKeyboardKey.tab, ms: 800);
    await shot("vim-editor");
    // The editor opens in normal mode, so one Esc goes back. A second
    // would hide the popup.
    await key(LogicalKeyboardKey.escape, ms: 800);

    await key(LogicalKeyboardKey.bracketRight, ms: 1500);
    await shot("stepped-to-enhance");

    await key(LogicalKeyboardKey.keyC);
    await type("sonnet 5.5");
    await key(LogicalKeyboardKey.enter, ms: 1500);
    await shot("compare");
    await key(LogicalKeyboardKey.escape);

    // Settings: choose the assistant's model there, as a user must once.
    await key(LogicalKeyboardKey.comma, hold: LogicalKeyboardKey.metaLeft, ms: 800);
    await shot("settings-models");
    await container.read(libraryStoreProvider.notifier).apply([
      const LibraryChange.setDefaults(assistantModel: ModelRef(Backend.anthropic, "claude-sonnet-5-5")),
    ], author: ChangeAuthor.you);
    for (final (label, name) in [
      ("Instructions", "settings-instructions"),
      ("Profiles", "settings-profiles"),
      ("General", "settings-general"),
    ]) {
      await tester.tap(find.text(label).first);
      await _wait(tester, 600);
      await shot(name);
    }
    await key(LogicalKeyboardKey.escape, ms: 800);

    // The assistant from the bar: Tab hands the typed request over.
    await key(LogicalKeyboardKey.space);
    await type("make my Discord replies friendlier and shorter");
    await key(LogicalKeyboardKey.tab, ms: 2500);
    await shot("assistant-proposal");
    await key(LogicalKeyboardKey.enter, ms: 1000);
    await shot("assistant-applied");
    await key(LogicalKeyboardKey.escape, ms: 800);

    // Enter pastes into Discord and the popup goes away.
    await key(LogicalKeyboardKey.enter, ms: 1200);

    // A longer note, in the light theme.
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    bridge
      ..source = _notes
      ..selection = _notesText;
    hotkey.press();
    await _wait(tester, 1500);
    await shot("light-review");
    await key(LogicalKeyboardKey.escape, ms: 800);
    tester.platformDispatcher.clearPlatformBrightnessTestValue();

    // A failure, then R.
    bridge.selection = "$_notesText ";
    hotkey.press();
    await _wait(tester, 1500);
    await shot("error");
    await key(LogicalKeyboardKey.keyR, ms: 1500);
    await shot("after-retry");

    await key(LogicalKeyboardKey.comma, hold: LogicalKeyboardKey.metaLeft, ms: 800);
    await tester.tap(find.text("History").first);
    await _wait(tester, 600);
    await shot("settings-history");

    expect(n, greaterThan(20));
    binding.reportData = {"shots": n};
    // Run with --no-resident, nothing waits for the app; quit when done.
    exit(0);
  });
}

/// Real time passes; with the fully live frame policy the engine draws on
/// its own, and a hidden window (the popup after Enter) never blocks.
Future<void> _wait(WidgetTester tester, int ms) => Future<void>.delayed(Duration(milliseconds: ms));

/// The real window, minus blur. A synthetic hotkey cannot make the app
/// active (macOS refuses), so after the popup has hidden once, showing it
/// again is followed by a blur, and the popup would hide itself before the
/// next shot. A real hotkey press activates the app, so users never see it.
class _StaysUp implements DesktopWindow {
  _StaysUp(this._window);

  final DesktopWindow _window;

  @override
  Stream<WindowEvent> get events => _window.events.where((e) => e != WindowEvent.blurred);

  @override
  Future<bool> isVisible() => _window.isVisible();

  @override
  Future<void> show() => _window.show();

  @override
  Future<void> hide() => _window.hide();

  @override
  Future<void> setPopup({required bool popup}) => _window.setPopup(popup: popup);

  @override
  Future<void> close() => _window.close();
}
