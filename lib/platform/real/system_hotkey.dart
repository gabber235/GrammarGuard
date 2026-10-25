import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

class SystemHotkey implements GlobalHotkey {
  SystemHotkey(this._manager);

  final HotKeyManager _manager;
  HotKey? _current;

  @override
  Future<HotkeyStatus> register(HotKey hotKey, VoidCallback onPressed) async {
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
