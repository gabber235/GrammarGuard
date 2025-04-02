import "package:grammar_guard/services/secure_storage_service.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "api_key_state.g.dart";

@riverpod
class ApiKeyState extends _$ApiKeyState {
  @override
  Future<String?> build() async {
    return SecureStorageService().getApiKey();
  }

  Future<void> setApiKey(String apiKey) async {
    await SecureStorageService().setApiKey(apiKey);
    state = AsyncValue.data(apiKey);
  }

  Future<void> deleteApiKey() async {
    await SecureStorageService().deleteApiKey();
    state = const AsyncValue.data(null);
  }
}
