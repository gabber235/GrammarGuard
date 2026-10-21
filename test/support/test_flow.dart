import "dart:async";
import "dart:io";

import "package:dio/dio.dart";
import "package:file/memory.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/app/app.dart";
import "package:grammar_guard/app/tray.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/apple_model.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/fakes.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/scripted_llm.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hooks_riverpod/misc.dart" show ProviderListenable;
import "package:shared_preferences/shared_preferences.dart";

import "replay_adapter.dart";

/// The whole app with the OS and the model replaced. Reads like the story.
class FlowApp {
  FlowApp() {
    container = ProviderContainer(
      overrides: [
        desktopWindowProvider.overrideWithValue(window),
        globalHotkeyProvider.overrideWithValue(hotkey),
        textBridgeProvider.overrideWithValue(bridge),
        llmGatewayProvider.overrideWithValue(model),
        fileSystemProvider.overrideWithValue(files),
        appleModelAvailableProvider.overrideWith((ref) async => false),
        // Flutter's asset channel does not answer reliably under the test
        // clock; the files are read straight from assets/.
        bundledAssetProvider.overrideWith((ref, key) async => File(key).readAsStringSync()),
        appSupportDirProvider.overrideWith((ref) async => files.directory("/support")..createSync()),
        httpProvider.overrideWith((ref) => Dio()..httpClientAdapter = ReplayAdapter.offline()),
        trayProvider.overrideWith((ref) async {}),
      ],
    );
  }

  late WidgetTester tester;
  late final ProviderContainer container;
  final window = FakeWindow();
  final hotkey = FakeHotkey();
  final bridge = FakeTextBridge();
  final model = ScriptedLlm();
  final files = MemoryFileSystem();

  /// The app, as the test pumps it.
  Widget get widget => UncontrolledProviderScope(container: container, child: const GrammarGuardApp());

  /// Window size, reduced motion (unless [motion], for filming
  /// transitions), mocked storage; then waits until the setup file is read
  /// and the model list is known, as a user would before pressing the hotkey.
  Future<void> start(WidgetTester tester, {bool pump = true, bool motion = false}) async {
    this.tester = tester;
    tester.view.physicalSize = const Size(1000, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    if (!motion) {
      tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
        disableAnimations: true,
      );
      addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    }
    addTearDown(container.dispose);
    if (pump) await tester.pumpWidget(widget);
    for (var i = 0; i < 50 && !ready; i++) {
      await settle();
    }
    expect(ready, isTrue, reason: "The app did not load its setup and models.");
  }

  SourceApp? get frontApp => bridge.source;
  set frontApp(SourceApp? app) => bridge.source = app;
  String? get selection => bridge.selection;
  set selection(String? text) => bridge.selection = text;
  set clipboard(String text) => bridge.clipboard = text;
  String get clipboard => bridge.clipboard;
  bool get visible => window.visible;

  Future<void> pressHotkey() async {
    hotkey.press();
    await settle();
  }

  Future<void> press(LogicalKeyboardKey key) async {
    await tester.sendKeyEvent(key);
    await settle();
  }

  /// Spinners never settle, so flows advance time instead of waiting for
  /// silence.
  Future<void> settle() async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
  }

  String? pastedInto(SourceApp app) => bridge.pasted.where((p) => p.$2?.id == app.id).lastOrNull?.$1;

  Library get library => container.read(libraryStoreProvider).value!.library;

  /// The assistant has no automatic model: tests choose one, as a user
  /// does once in Settings.
  Future<void> chooseAssistantModel([ModelRef model = const ModelRef(Backend.anthropic, "claude-haiku-4-5")]) async {
    await container.read(libraryStoreProvider.notifier).apply([
      LibraryChange.setDefaults(assistantModel: model),
    ], author: ChangeAuthor.you);
    await settle();
  }

  /// Sends [text] and waits until the assistant has answered.
  Future<void> openAssistant(String text) async {
    unawaited(container.read(assistantProvider.notifier).open(text));
    for (var i = 0; i < 50 && (i == 0 || container.read(assistantProvider).busy); i++) {
      await settle();
    }
  }

  T read<T>(ProviderListenable<T> provider) => container.read(provider);

  bool get ready =>
      container.read(libraryStoreProvider).hasValue &&
      (container.read(modelCatalogProvider).value?.isNotEmpty ?? false);
}

/// Mocked preferences and an Anthropic key, so the catalog is not empty.
void mockStorage() {
  SharedPreferences.setMockInitialValues({});
  FlutterSecureStorage.setMockInitialValues({"claude_api_key": "test-key"});
}

/// A widget test with fakes for every port, the bundled library, and an
/// Anthropic key so the catalog is not empty.
void testFlow(String description, Future<void> Function(FlowApp app) body) {
  testWidgets(description, (tester) async {
    mockStorage();
    final app = FlowApp();
    await app.start(tester);
    await body(app);
    // Let short delays end (the "Copied" toast keeps the popup up 700 ms).
    await tester.pump(const Duration(seconds: 5));
  });
}

const discord = SourceApp(id: "com.hnc.discord", name: "Discord", processId: 42);
const notes = SourceApp(id: "com.apple.notes", name: "Notes", processId: 7);
