import "dart:async";
import "dart:io";

import "package:grammar_guard/app/navigation.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/session/session.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:tray_manager/tray_manager.dart";

part "tray.g.dart";

/// Menu bar icon on macOS, tray icon on Windows and Linux: the app's only
/// visible presence while the popup is hidden.
@Riverpod(keepAlive: true)
Future<void> tray(Ref ref) async {
  await trayManager.setIcon(
    // Windows loads tray icons with LoadImage, which only reads .ico.
    Platform.isWindows ? "assets/tray_icon.ico" : "assets/tray_icon@2x.png",
    isTemplate: true, // macOS tints it for light and dark menu bars
  );
  await trayManager.setToolTip("GrammarGuard");
  await trayManager.setContextMenu(
    Menu(
      items: [
        MenuItem(key: "clipboard", label: "Rewrite clipboard"),
        MenuItem(key: "settings", label: "Settings…"),
        MenuItem.separator(),
        MenuItem(key: "quit", label: "Quit GrammarGuard"),
      ],
    ),
  );
  final listener = _TrayListener(ref);
  trayManager.addListener(listener);
  ref.onDispose(() => trayManager.removeListener(listener));
}

class _TrayListener with TrayListener {
  _TrayListener(this.ref);

  final Ref ref;

  @override
  void onTrayIconMouseDown() => unawaited(trayManager.popUpContextMenu());

  @override
  void onTrayMenuItemClick(MenuItem menuItem) => unawaited(_handle(menuItem.key));

  Future<void> _handle(String? key) async {
    final window = ref.read(desktopWindowProvider);
    switch (key) {
      case "clipboard":
        await ref.read(sessionActionsProvider).useClipboard();
        await window.show();
      case "settings":
        await window.show();
        await openSettings();
      case "quit":
        await window.close();
    }
  }
}
