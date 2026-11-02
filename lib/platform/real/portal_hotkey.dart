import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

/// The ids the desktop knows the shortcuts by. Hyprland binds name them
/// (grammarguard:open), so they must not change.
const _ids = {HotkeyPurpose.rewrite: "open", HotkeyPurpose.chooseFirst: "choose"};

/// The global shortcuts through the XDG desktop portal, the only way on
/// Wayland. The runner talks to the portal; the desktop decides which keys
/// trigger them (Hyprland ignores the proposal and uses its own binds).
class PortalHotkey implements GlobalHotkey {
  PortalHotkey(this._channel) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != "activated") return;
      for (final MapEntry(key: purpose, value: id) in _ids.entries) {
        if (id == call.arguments) _onPressed?.call(purpose);
      }
    });
  }

  final MethodChannel _channel;
  void Function(HotkeyPurpose)? _onPressed;

  @override
  Future<Map<HotkeyPurpose, HotkeyStatus>> register(
    Map<HotkeyPurpose, HotKey> keys,
    void Function(HotkeyPurpose purpose) onPressed,
  ) async {
    _onPressed = null;
    final usable = {
      for (final MapEntry(key: purpose, value: hotKey) in keys.entries)
        if (_keycode(hotKey) != null) purpose: hotKey,
    };
    HotkeyStatus status(HotkeyPurpose purpose, HotkeyStatus bound) => usable.containsKey(purpose)
        ? bound
        : const HotkeyStatus.unavailable("The desktop cannot use this key for the shortcut.");
    if (usable.isEmpty) {
      return {for (final purpose in keys.keys) purpose: status(purpose, const HotkeyStatus.active())};
    }
    // One session holds both, so a desktop bound once stays bound.
    HotkeyStatus bound;
    try {
      final answer = await _channel.invokeMapMethod<String, Object?>("register", {
        "shortcuts": [
          for (final MapEntry(key: purpose, value: hotKey) in usable.entries)
            {
              "id": _ids[purpose],
              "keycode": _keycode(hotKey),
              "modifiers": [for (final modifier in hotKey.modifiers ?? const <HotKeyModifier>[]) modifier.name],
            },
        ],
      });
      _onPressed = onPressed;
      bound = HotkeyStatus.active(note: answer?["note"] as String?);
    } on PlatformException catch (error) {
      bound = HotkeyStatus.unavailable(error.message ?? "The desktop did not allow the shortcut.");
    }
    return {for (final purpose in keys.keys) purpose: status(purpose, bound)};
  }

  int? _keycode(HotKey hotKey) =>
      kLinuxToPhysicalKey.entries.where((entry) => entry.value == hotKey.physicalKey).firstOrNull?.key;

  @override
  Future<void> unregister() async {
    _onPressed = null;
    await _channel.invokeMethod<void>("unregister");
  }
}
