import "dart:convert";

import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "provider_settings_state.g.dart";

const _providerSettingsKey = "provider_settings_v1";

class ProviderSettings {
  const ProviderSettings({required this.enabled});

  const ProviderSettings.defaults() : enabled = true;

  factory ProviderSettings.fromJson(Map<String, dynamic> json) {
    final enabledValue = json["enabled"];
    if (enabledValue is bool) {
      return ProviderSettings(enabled: enabledValue);
    }

    return const ProviderSettings.defaults();
  }

  final bool enabled;

  ProviderSettings copyWith({bool? enabled}) {
    return ProviderSettings(enabled: enabled ?? this.enabled);
  }

  Map<String, dynamic> toJson() {
    return {"enabled": enabled};
  }
}

@Riverpod(keepAlive: true)
class ProviderSettingsState extends _$ProviderSettingsState {
  @override
  Future<Map<String, ProviderSettings>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_providerSettingsKey);
    if (settingsJson == null) {
      return {};
    }

    try {
      final decoded = json.decode(settingsJson);
      if (decoded is! Map<String, dynamic>) {
        return {};
      }

      final settings = <String, ProviderSettings>{};
      for (final entry in decoded.entries) {
        if (entry.value is! Map<String, dynamic>) {
          continue;
        }

        settings[entry.key] = ProviderSettings.fromJson(entry.value);
      }

      return settings;
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }

  Future<void> setEnabled(String providerName, {required bool enabled}) async {
    final current = await future;
    final existing = current[providerName] ?? const ProviderSettings.defaults();
    final updated = <String, ProviderSettings>{
      ...current,
      providerName: existing.copyWith(enabled: enabled),
    };
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateSettings(
    String providerName,
    ProviderSettings settings,
  ) async {
    final current = await future;
    final updated = <String, ProviderSettings>{
      ...current,
      providerName: settings,
    };
    await _persist(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> _persist(Map<String, ProviderSettings> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(
      settings.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString(_providerSettingsKey, encoded);
  }
}

@riverpod
ProviderSettings providerSettingsForProvider(Ref ref, String providerName) {
  final settings = ref.watch(providerSettingsStateProvider).value;
  return settings?[providerName] ?? const ProviderSettings.defaults();
}
