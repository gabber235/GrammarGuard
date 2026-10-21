import "dart:io";
import "dart:ui";

import "package:flutter_acrylic/flutter_acrylic.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:window_manager/window_manager.dart";

/// Clears hotkeys left by a crashed run and prepares a hidden window.
/// The session shows it: at once when no hotkey is available, otherwise on
/// the first hotkey press.
Future<void> prepareWindow() async {
  await hotKeyManager.unregisterAll();
  await Window.initialize(); // flutter_acrylic, for the glass effect
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      size: const Size(1000, 600),
      center: true,
      backgroundColor: const Color(0x00000000),
      title: "GrammarGuard",
      // macOS: fixed at launch, see WindowManagerWindow.setPopup.
      titleBarStyle: Platform.isMacOS ? TitleBarStyle.hidden : null,
    ),
  );
}
