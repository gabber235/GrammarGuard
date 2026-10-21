import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

class SystemHotkey implements GlobalHotkey {
  SystemHotkey(this._manager, {required this._isWayland});

  final HotKeyManager _manager;
  final bool _isWayland;
  HotKey? _current;

  @override
  Future<HotkeyStatus> register(HotKey hotKey, VoidCallback onPressed) async {
    if (_isWayland) {
      return const HotkeyStatus.unavailable(
        "Wayland does not allow global shortcuts. Open GrammarGuard from "
        "your app launcher and press Ctrl+V to use the clipboard.",
      );
    }
    await unregister();
    try {
      await _manager.register(hotKey, keyDownHandler: (_) => onPressed());
      _current = hotKey;
      return const HotkeyStatus.active();
    } on PlatformException catch (error) {
      return HotkeyStatus.unavailable(error.message ?? "Another app already uses this shortcut.");
    }
  }

  @override
  Future<void> unregister() async {
    final current = _current;
    if (current == null) return;
    await _manager.unregister(current);
    _current = null;
  }
}
