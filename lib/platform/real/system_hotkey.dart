import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

class SystemHotkey implements GlobalHotkey {
  SystemHotkey(this._manager);

  final HotKeyManager _manager;
  final _current = <HotKey>[];

  @override
  Future<Map<HotkeyPurpose, HotkeyStatus>> register(
    Map<HotkeyPurpose, HotKey> keys,
    void Function(HotkeyPurpose purpose) onPressed,
  ) async {
    await unregister();
    return {
      for (final MapEntry(key: purpose, value: hotKey) in keys.entries)
        purpose: await _register(hotKey, () => onPressed(purpose)),
    };
  }

  Future<HotkeyStatus> _register(HotKey hotKey, VoidCallback onPressed) async {
    try {
      await _manager.register(hotKey, keyDownHandler: (_) => onPressed());
      _current.add(hotKey);
      return const HotkeyStatus.active();
    } on PlatformException catch (error) {
      return HotkeyStatus.unavailable(error.message ?? "Another app already uses this shortcut.");
    }
  }

  @override
  Future<void> unregister() async {
    // Taken first: registering again unregisters too, while the old binding's
    // own unregister may still be on its way.
    final old = [..._current];
    _current.clear();
    for (final hotKey in old) {
      await _manager.unregister(hotKey);
    }
  }
}
