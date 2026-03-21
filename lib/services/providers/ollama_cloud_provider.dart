import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/services/providers/ollama_shared.dart";
import "package:grammar_guard/state/api_key_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

const _storage = FlutterSecureStorage();
const _configKey = "ollama_cloud_config";

final _ollamaCloudConfigProvider =
    AsyncNotifierProvider<OllamaCloudConfigNotifier, OllamaConfig>(
      OllamaCloudConfigNotifier.new,
    );

class OllamaCloudConfigNotifier extends AsyncNotifier<OllamaConfig> {
  @override
  Future<OllamaConfig> build() async {
    try {
      final configJson = await _storage.read(key: _configKey);
      if (configJson != null) {
        final json = Map<String, dynamic>.from(
          Uri.splitQueryString(configJson),
        );
        return OllamaConfig.fromJson(json);
      }
    } on Exception catch (e) {
      debugPrint("Failed to load Ollama Cloud config: $e");
    }
    return const OllamaConfig(serverUrl: "https://ollama.com");
  }

  Future<void> updateConfig(OllamaConfig config) async {
    try {
      final configString = Uri(
        queryParameters: config.toJson().map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ).query;
      await _storage.write(key: _configKey, value: configString);
      ref.invalidateSelf();
    } catch (e) {
      throw Exception("Failed to save configuration: $e");
    }
  }
}

class OllamaCloudProvider extends AiProvider {
  const OllamaCloudProvider();

  @override
  String get name => "ollama_cloud";

  @override
  String get displayName => "Ollama Cloud";

  String get defaultServerUrl => "https://ollama.com";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    final config = await ref.read(_ollamaCloudConfigProvider.future);
    final apiKey = await ref.read(apiKeyProvider(name).future);

    return fetchOllamaModels(
      serverUrl: config.serverUrl,
      provider: this,
      timeout: config.timeout,
      apiKey: apiKey,
    );
  }

  @override
  Widget buildConfigurationWidget({required WidgetRef ref}) {
    return _OllamaCloudConfigurationWidget(provider: this);
  }

  @override
  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  }) async* {
    final config = await ref.read(_ollamaCloudConfigProvider.future);
    final apiKey = await ref.read(apiKeyProvider(name).future);

    yield* generateOllamaContent(
      serverUrl: config.serverUrl,
      prompt: prompt,
      inputText: inputText,
      model: model,
      apiKey: apiKey,
    );
  }
}

class _OllamaCloudConfigurationWidget extends HookConsumerWidget {
  const _OllamaCloudConfigurationWidget({required this.provider});

  final OllamaCloudProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverUrlController = useTextEditingController();
    final apiKeyController = useTextEditingController();
    final isLoading = useState(false);
    final isTesting = useState(false);
    final configAsync = ref.watch(_ollamaCloudConfigProvider);
    final apiKeyAsync = ref.watch(apiKeyProvider(provider.name));

    useEffect(() {
      configAsync.whenData((config) {
        serverUrlController.text = config.serverUrl;
      });
      return null;
    }, [configAsync]);

    useEffect(() {
      apiKeyController.text = apiKeyAsync.value ?? "";
      return null;
    }, [apiKeyAsync.value]);

    return OllamaSharedConfigWidget(
      serverUrlController: serverUrlController,
      apiKeyController: apiKeyController,
      isLoading: isLoading,
      isTesting: isTesting,
      showApiKeyField: true,
      providerDisplayName: provider.displayName,
      defaultServerUrl: provider.defaultServerUrl,
      onSave: () => _saveConfig(
        ref,
        serverUrlController,
        apiKeyController,
        isLoading,
        context,
      ),
      onTest: () => _testConnection(
        ref,
        serverUrlController,
        apiKeyController,
        isTesting,
        context,
      ),
      onRefreshModels: () => _refreshModels(ref, context),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  Future<void> _saveConfig(
    WidgetRef ref,
    TextEditingController serverUrlController,
    TextEditingController apiKeyController,
    ValueNotifier<bool> isLoading,
    BuildContext context,
  ) async {
    final serverUrl = serverUrlController.text.trim();
    if (serverUrl.isEmpty) return;

    isLoading.value = true;

    try {
      final config = OllamaConfig(serverUrl: serverUrl);
      await ref.read(_ollamaCloudConfigProvider.notifier).updateConfig(config);

      final apiKey = apiKeyController.text.trim();
      if (apiKey.isNotEmpty) {
        await ref
            .read(apiKeyStateProvider.notifier)
            .setApiKey(provider.name, apiKey);
      } else {
        await ref
            .read(apiKeyStateProvider.notifier)
            .deleteApiKey(provider.name);
      }

      if (!context.mounted) return;
      _showSnackBar(context, "Ollama Cloud configuration saved", Colors.green);
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Failed to save configuration: $e", Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _testConnection(
    WidgetRef ref,
    TextEditingController serverUrlController,
    TextEditingController apiKeyController,
    ValueNotifier<bool> isTesting,
    BuildContext context,
  ) async {
    final serverUrl = serverUrlController.text.trim();
    final apiKey = apiKeyController.text.trim();

    isTesting.value = true;

    try {
      final result = await testOllamaConnection(
        serverUrl.isEmpty ? provider.defaultServerUrl : serverUrl,
        apiKey: apiKey.isEmpty ? null : apiKey,
      );

      if (!context.mounted) return;

      switch (result) {
        case OllamaConnectionSuccess():
          _showSnackBar(context, "Connection successful!", Colors.green);
        case OllamaConnectionError(message: final message):
          _showSnackBar(context, "Connection failed: $message", Colors.red);
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Unexpected error: $e", Colors.red);
    } finally {
      isTesting.value = false;
    }
  }

  Future<void> _refreshModels(WidgetRef ref, BuildContext context) async {
    try {
      ref.invalidate(modelRegistryProvider);
      if (!context.mounted) return;
      _showSnackBar(context, "Models refreshed", Colors.blue);
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Failed to refresh models: $e", Colors.red);
    }
  }
}
