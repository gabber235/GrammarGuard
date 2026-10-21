import "dart:convert";

import "package:grammar_guard/llm/apple_model.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "connections.g.dart";

const _settingsKey = "connections_v2";

/// Saved connection settings. Keys live in secure storage, everything else
/// in preferences as JSON. Replaces api_key_state.dart,
/// provider_settings_state.dart and the Ollama query string config (B1).
@Riverpod(keepAlive: true)
class Connections extends _$Connections {
  @override
  Future<Map<Backend, Connection>> build() async {
    final prefs = await ref.watch(preferencesProvider.future);
    final secrets = ref.watch(secureStorageProvider);
    final appleReady = await ref.watch(appleModelAvailableProvider.future);
    final saved = _decode(prefs.getString(_settingsKey));

    return {
      for (final backend in Backend.values)
        backend: Connection(
          backend: backend,
          enabled:
              saved[backend]?.enabled ??
              switch (backend.key) {
                // Cloud backends switch on when a key is added; local
                // servers stay off until the user turns them on.
                KeyNeed.required => true,
                KeyNeed.optional || KeyNeed.none => backend == Backend.apple && appleReady,
              },
          baseUrl: saved[backend]?.baseUrl,
          apiKey: backend.key == KeyNeed.none ? null : await secrets.read(key: backend.secretKey),
        ),
    };
  }

  Future<void> save(Connection connection) async {
    final secrets = ref.read(secureStorageProvider);
    final key = connection.apiKey?.trim() ?? "";
    if (connection.backend.key != KeyNeed.none) {
      if (key.isEmpty) {
        await secrets.delete(key: connection.backend.secretKey);
      } else {
        await secrets.write(key: connection.backend.secretKey, value: key);
      }
    }

    final current = await future;
    final next = {...current, connection.backend: connection};
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.setString(_settingsKey, _encode(next.values));
    state = AsyncData(next);
  }

  // The JSON in preferences: {"ollama": {"enabled": true, "baseUrl": "..."}}.
  static Map<Backend, ({bool enabled, Uri? baseUrl})> _decode(String? raw) {
    if (raw == null) return {};
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return {};
    }
    if (decoded is! Map<String, dynamic>) return {};
    final result = <Backend, ({bool enabled, Uri? baseUrl})>{};
    for (final MapEntry(:key, :value) in decoded.entries) {
      final backend = Backend.values.asNameMap()[key];
      if (backend == null || value is! Map<String, dynamic>) continue;
      final url = value["baseUrl"];
      result[backend] = (enabled: value["enabled"] == true, baseUrl: url is String ? Uri.tryParse(url) : null);
    }
    return result;
  }

  static String _encode(Iterable<Connection> connections) => jsonEncode({
    for (final c in connections)
      c.backend.name: {"enabled": c.enabled, if (c.baseUrl != null) "baseUrl": c.baseUrl.toString()},
  });
}
