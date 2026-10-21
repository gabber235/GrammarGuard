// The real app on the real OS with only the model, the hotkey and storage
// faked: real window, real clipboard, real text bridge channel.
// macOS: flutter test integration_test -d macos
// Linux CI: xvfb-run flutter test integration_test -d linux
import "package:file/memory.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/tray.dart";
import "package:grammar_guard/app/window_setup.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/platform/fakes.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/scripted_llm.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:integration_test/integration_test.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("clipboard in, review, Enter copies the result", (tester) async {
    await prepareWindow();
    // Never touch the developer's own setup, keys or preferences.
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({"claude_api_key": "test-key"});
    final files = MemoryFileSystem();
    final model = ScriptedLlm()..reply(["Hello there."]);
    await Clipboard.setData(const ClipboardData(text: "helo there"));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          llmGatewayProvider.overrideWithValue(model),
          // Window mode, the way in without a hotkey. In popup mode the
          // hidden window makes `flutter test` on macOS lose the test result,
          // although the same flow passes under `flutter run`.
          globalHotkeyProvider.overrideWithValue(FakeHotkey(status: const HotkeyStatus.unavailable("test"))),
          fileSystemProvider.overrideWithValue(files),
          appSupportDirProvider.overrideWith((ref) async => files.directory("/support")..createSync()),
          trayProvider.overrideWith((ref) async {}),
        ],
        child: const GrammarGuardApp(),
      ),
    );
    await _pumpFor(tester, const Duration(seconds: 2));

    final modifier = defaultTargetPlatform == TargetPlatform.macOS
        ? LogicalKeyboardKey.meta
        : LogicalKeyboardKey.control;
    await tester.sendKeyDownEvent(modifier);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyV);
    await tester.sendKeyUpEvent(modifier);
    await _pumpFor(tester, const Duration(seconds: 1));
    expect(model.calls, hasLength(1));

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpFor(tester, const Duration(seconds: 1));

    expect((await Clipboard.getData(Clipboard.kTextPlain))?.text, "Hello there.");
  });
}

/// Real time passes, so platform channels can answer. pumpAndSettle would
/// never return while a spinner runs.
Future<void> _pumpFor(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
