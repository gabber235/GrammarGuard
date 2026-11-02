import "dart:convert";

import "package:flutter/services.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:hotkey_manager/hotkey_manager.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "hotkey_setting.g.dart";

const _hotkeyKey = "hotkey";
const _historyKey = "history_enabled";
const _historyLimitKey = "history_limit";
const _readingSizeKey = "reading_size";

/// The default stays Alt+Shift+G (Option+Shift+G on macOS).
final defaultHotKey = HotKey(
  key: PhysicalKeyboardKey.keyG,
  modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
  scope: HotKeyScope.system,
);

@Riverpod(keepAlive: true)
class HotkeySetting extends _$HotkeySetting {
  @override
  Future<HotKey> build() async {
    final prefs = await ref.watch(preferencesProvider.future);
    final saved = prefs.getString(_hotkeyKey);
    if (saved == null) return defaultHotKey;
    try {
      return HotKey.fromJson(jsonDecode(saved) as Map<String, dynamic>);
    } on FormatException {
      return defaultHotKey;
    }
  }

  /// HotkeyBinding watches this provider and re-registers.
  Future<void> set(HotKey hotKey) async {
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.setString(_hotkeyKey, jsonEncode(hotKey.toJson()));
    state = AsyncData(hotKey);
  }
}

/// How many rewrites stay on this computer; zero keeps none. Stored once
/// here, and an older "off" switch still counts.
@Riverpod(keepAlive: true)
class HistoryLimit extends _$HistoryLimit {
  static const standard = 100;
  static const presets = [0, 20, 100, 1000];

  /// Every rewrite saves the whole file again, which stays quick up to here.
  static const max = 10000;

  @override
  Future<int> build() async {
    final prefs = await ref.watch(preferencesProvider.future);
    return prefs.getInt(_historyLimitKey) ?? (prefs.getBool(_historyKey) == false ? 0 : standard);
  }

  Future<void> set(int limit) async {
    final clamped = limit.clamp(0, max);
    await (await ref.read(preferencesProvider.future)).setInt(_historyLimitKey, clamped);
    state = AsyncData(clamped);
  }
}

/// The size of the review text, in logical pixels. Large by default for
/// easy reading; Settings, General moves it between [min] and [max].
@Riverpod(keepAlive: true)
class ReadingSize extends _$ReadingSize {
  static const double standard = 19;
  static const double min = 15;
  static const double max = 28;

  @override
  Future<double> build() async =>
      ((await ref.watch(preferencesProvider.future)).getDouble(_readingSizeKey) ?? standard).clamp(min, max);

  Future<void> set(double size) async {
    final clamped = size.clamp(min, max);
    await (await ref.read(preferencesProvider.future)).setDouble(_readingSizeKey, clamped);
    state = AsyncData(clamped);
  }
}

/// How [hotKey] is written on screen, one entry per key cap:
/// `["Option", "Shift", "G"]` on macOS, `["Alt", "Shift", "G"]` elsewhere.
List<String> hotkeyLabels(HotKey hotKey, {required bool mac}) => [
  for (final modifier in hotKey.modifiers ?? const <HotKeyModifier>[])
    switch (modifier) {
      HotKeyModifier.alt => mac ? "Option" : "Alt",
      HotKeyModifier.shift => "Shift",
      HotKeyModifier.control => "Ctrl",
      HotKeyModifier.meta => mac ? "Cmd" : "Win",
      HotKeyModifier.capsLock => "Caps Lock",
      HotKeyModifier.fn => "Fn",
    },
  hotKey.logicalKey.keyLabel.toUpperCase(),
];
