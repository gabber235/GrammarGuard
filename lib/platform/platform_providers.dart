import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:file/file.dart";
import "package:file/local.dart";
import "package:flutter/services.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/real/native_text_bridge.dart";
import "package:grammar_guard/platform/real/portal_hotkey.dart";
import "package:grammar_guard/platform/real/system_hotkey.dart";
import "package:grammar_guard/platform/real/window_manager_window.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:path_provider/path_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:window_manager/window_manager.dart";

part "platform_providers.g.dart";

@Riverpod(keepAlive: true)
DesktopWindow desktopWindow(Ref ref) {
  final window = WindowManagerWindow(windowManager);
  ref.onDispose(window.dispose);
  return window;
}

/// Started by a login item with `--background` (the Windows installer, the
/// nix modules): the window stays hidden until the hotkey or the OS opens
/// it. main.dart sets it from the launch arguments.
@Riverpod(keepAlive: true)
bool launchedInBackground(Ref ref) => false;

@Riverpod(keepAlive: true)
GlobalHotkey globalHotkey(Ref ref) {
  final environment = Platform.environment;
  final wayland =
      Platform.isLinux && (environment["XDG_SESSION_TYPE"] == "wayland" || environment.containsKey("WAYLAND_DISPLAY"));
  if (!wayland) return SystemHotkey(hotKeyManager);
  return PortalHotkey(const MethodChannel("grammar_guard/global_shortcut"));
}

@Riverpod(keepAlive: true)
TextBridge textBridge(Ref ref) {
  return const NativeTextBridge(MethodChannel("grammar_guard/text_bridge"));
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> preferences(Ref ref) {
  return SharedPreferences.getInstance();
}

/// A text file bundled with the app (assets/...). Read as bytes and decoded
/// here, uncached: loadString hands large files to an isolate and caches a
/// future that outlives the zone that created it, which breaks widget tests.
@Riverpod(keepAlive: true)
Future<String> bundledAsset(Ref ref, String key) async {
  final bytes = await rootBundle.load(key);
  return utf8.decode(bytes.buffer.asUint8List());
}

/// Every file GrammarGuard reads or writes goes through this, so tests can
/// use an in-memory file system instead of the disk.
@Riverpod(keepAlive: true)
FileSystem fileSystem(Ref ref) => const LocalFileSystem();

/// Holds library.yaml, its history and history.jsonl.
@Riverpod(keepAlive: true)
Future<Directory> appSupportDir(Ref ref) async =>
    ref.watch(fileSystemProvider).directory((await getApplicationSupportDirectory()).path);

/// Shared HTTP client for model lists. Tests give it an offline adapter.
@Riverpod(keepAlive: true)
Dio http(Ref ref) {
  final dio = Dio(BaseOptions(receiveTimeout: const Duration(seconds: 8)));
  ref.onDispose(dio.close);
  return dio;
}

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  // The login keychain works with a self-signed build. The data protection
  // keychain needs a team id that a self-signed certificate does not have.
  return const FlutterSecureStorage(mOptions: MacOsOptions(usesDataProtectionKeychain: false));
}
