import "dart:async";

import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "hotkey_binding.g.dart";

/// Registers the user's shortcut and re-registers when it changes in
/// Settings. Its status decides popup or normal window.
@Riverpod(keepAlive: true)
class HotkeyBinding extends _$HotkeyBinding {
  @override
  Future<HotkeyStatus> build() async {
    final hotKey = await ref.watch(hotkeySettingProvider.future);
    final hotkey = ref.watch(globalHotkeyProvider);
    ref.onDispose(() => unawaited(hotkey.unregister()));
    final status = await hotkey.register(hotKey, () => ref.read(sessionActionsProvider).onHotkey());
    final window = ref.read(desktopWindowProvider);
    await window.setPopup(popup: status is HotkeyActive);
    if (status is HotkeyUnavailable) {
      // No hotkey means no other way in: show the window now.
      await window.show();
    }
    return status;
  }
}
