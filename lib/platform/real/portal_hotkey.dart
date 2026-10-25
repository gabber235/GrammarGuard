import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

/// The global shortcut through the XDG desktop portal, the only way on
/// Wayland. The runner talks to the portal; the desktop decides which keys
/// trigger it (Hyprland ignores the proposal and uses its own binds).
class PortalHotkey implements GlobalHotkey {
  PortalHotkey(this._channel) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "activated") _onPressed?.call();
    });
  }

  final MethodChannel _channel;
  VoidCallback? _onPressed;

  @override
  Future<HotkeyStatus> register(HotKey hotKey, VoidCallback onPressed) async {
    _onPressed = null;
    final keycode = kLinuxToPhysicalKey.entries.where((entry) => entry.value == hotKey.physicalKey).firstOrNull?.key;
    if (keycode == null) return const HotkeyStatus.unavailable("The desktop cannot use this key for the shortcut.");
    try {
      final bound = await _channel.invokeMapMethod<String, Object?>("register", {
        "keycode": keycode,
        "modifiers": [for (final modifier in hotKey.modifiers ?? const <HotKeyModifier>[]) modifier.name],
      });
      _onPressed = onPressed;
      return HotkeyStatus.active(note: bound?["note"] as String?);
    } on PlatformException catch (error) {
      return HotkeyStatus.unavailable(error.message ?? "The desktop did not allow the shortcut.");
    }
  }

  @override
  Future<void> unregister() async {
    _onPressed = null;
    await _channel.invokeMethod<void>("unregister");
  }
}
