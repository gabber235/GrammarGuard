import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "api_key_state.g.dart";

const _storage = FlutterSecureStorage();
String _getApiKeyKey(String providerName) => "${providerName}_api_key";

@Riverpod(keepAlive: true)
class ApiKeyState extends _$ApiKeyState {
  @override
  Future<Map<String, String>> build() async {
    final allKeys = await _storage.readAll();
    final apiKeys = <String, String>{};

    for (final entry in allKeys.entries) {
      if (entry.key.endsWith("_api_key")) {
        final providerName = entry.key.replaceAll("_api_key", "");
        apiKeys[providerName] = entry.value;
      }
    }

    return apiKeys;
  }

  Future<void> setApiKey(String providerName, String apiKey) async {
    await _storage.write(key: _getApiKeyKey(providerName), value: apiKey);
    final current = state.value ?? <String, String>{};
    final updated = <String, String>{...current, providerName: apiKey};
    state = AsyncValue.data(updated);
    ref.invalidate(apiKeyProvider(providerName));
  }

  Future<void> deleteApiKey(String providerName) async {
    await _storage.delete(key: _getApiKeyKey(providerName));
    final current = state.value ?? <String, String>{};
    final updated = Map<String, String>.from(current)..remove(providerName);
    state = AsyncValue.data(updated);
    ref.invalidate(apiKeyProvider(providerName));
  }
}

@Riverpod(keepAlive: true)
Future<String?> apiKey(Ref ref, String providerName) {
  return _storage.read(key: _getApiKeyKey(providerName));
}
