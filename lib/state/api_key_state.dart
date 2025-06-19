import "package:grammar_guard/services/secure_storage_service.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "api_key_state.g.dart";

@riverpod
class ApiKeyState extends _$ApiKeyState {
  @override
  Future<Map<String, String>> build() async {
    return SecureStorageService().getAllApiKeys();
  }

  Future<void> setApiKey(String providerName, String apiKey) async {
    await SecureStorageService().setApiKey(providerName, apiKey);
    final current = state.valueOrNull ?? <String, String>{};
    final updated = <String, String>{...current, providerName: apiKey};
    state = AsyncValue.data(updated);
  }

  Future<void> deleteApiKey(String providerName) async {
    await SecureStorageService().deleteApiKey(providerName);
    final current = state.valueOrNull ?? <String, String>{};
    final updated = Map<String, String>.from(current)..remove(providerName);
    state = AsyncValue.data(updated);
  }

  Future<String?> getApiKey(String providerName) async {
    final apiKeys = state.valueOrNull;
    return apiKeys?[providerName];
  }
}
