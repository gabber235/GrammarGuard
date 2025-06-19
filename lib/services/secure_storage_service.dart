import "package:flutter_secure_storage/flutter_secure_storage.dart";

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static String _getApiKeyKey(String providerName) => "${providerName}_api_key";

  Future<String?> getApiKey(String providerName) async {
    return _storage.read(key: _getApiKeyKey(providerName));
  }

  Future<void> setApiKey(String providerName, String apiKey) async {
    await _storage.write(key: _getApiKeyKey(providerName), value: apiKey);
  }

  Future<void> deleteApiKey(String providerName) async {
    await _storage.delete(key: _getApiKeyKey(providerName));
  }

  Future<Map<String, String>> getAllApiKeys() async {
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
}
