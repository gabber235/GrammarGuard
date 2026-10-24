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
  final trayIcon = TrayIcon.create()!;
  // The native icon goes away when this wrapper is garbage collected, so
  // onDispose keeps the reference for as long as the provider lives.
  ref.onDispose(trayIcon.dispose);
  trayIcon
    // Windows loads tray icons with LoadImage, which only reads .ico.
    ..icon = ImageAsset.fromAsset(Platform.isWindows ? "assets/tray_icon.ico" : "assets/tray_icon@2x.png")
    // macOS tints it for light and dark menu bars
    ..isIconTemplate = true
    ..setTooltip("GrammarGuard");

  final window = ref.read(desktopWindowProvider);
  final menu = Menu.create()!
    ..addItem(
      _item("Rewrite clipboard", () async {
        await ref.read(sessionActionsProvider).useClipboard();
        await window.show();
      }),
    )
    ..addItem(
      _item("Settings…", () async {
        await window.show();
        await openSettings();
      }),
    )
    ..addSeparator()
    ..addItem(_item("Quit GrammarGuard", window.close));
  trayIcon
    ..setContextMenu(menu)
    // Linux panels open the menu themselves and report no clicks.
    ..setContextMenuTrigger(ContextMenuTrigger.clicked)
    ..setVisible(true);
}

MenuItem _item(String label, Future<void> Function() onClick) {
  return MenuItem.createWithLabelAndType(label, MenuItemType.normal)!..addListener((event) {
    if (event is MenuItemClickedEvent) unawaited(onClick());
  });
}
