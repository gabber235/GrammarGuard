import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/services/providers/ollama_shared.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

const _storage = FlutterSecureStorage();
const _configKey = "ollama_local_config";

final _ollamaLocalConfigProvider =
    AsyncNotifierProvider<OllamaLocalConfigNotifier, OllamaConfig>(
      OllamaLocalConfigNotifier.new,
    );

class OllamaLocalConfigNotifier extends AsyncNotifier<OllamaConfig> {
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
      debugPrint("Failed to load Ollama Local config: $e");
    }
    return const OllamaConfig(serverUrl: "http://localhost:11434");
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

class OllamaLocalProvider extends AiProvider {
  const OllamaLocalProvider();

  @override
  String get name => "ollama_local";

  @override
  String get displayName => "Ollama Local";

  String get defaultServerUrl => "http://localhost:11434";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    final config = await ref.read(_ollamaLocalConfigProvider.future);

    return fetchOllamaModels(
      serverUrl: config.serverUrl,
      provider: this,
      timeout: config.timeout,
    );
  }

  @override
  Widget buildConfigurationWidget({required WidgetRef ref}) {
    return _OllamaLocalConfigurationWidget(provider: this);
  }

  @override
  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  }) async* {
    final config = await ref.read(_ollamaLocalConfigProvider.future);

    yield* generateOllamaContent(
      serverUrl: config.serverUrl,
      prompt: prompt,
      inputText: inputText,
      model: model,
    );
  }
}

class _OllamaLocalConfigurationWidget extends HookConsumerWidget {
  const _OllamaLocalConfigurationWidget({required this.provider});

  final OllamaLocalProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverUrlController = useTextEditingController();
    final isLoading = useState(false);
    final isTesting = useState(false);
    final configAsync = ref.watch(_ollamaLocalConfigProvider);

    useEffect(() {
      configAsync.whenData((config) {
        serverUrlController.text = config.serverUrl;
      });
      return null;
    }, [configAsync]);

    return OllamaSharedConfigWidget(
      serverUrlController: serverUrlController,
      isLoading: isLoading,
      isTesting: isTesting,
      showApiKeyField: false,
      providerDisplayName: provider.displayName,
      defaultServerUrl: provider.defaultServerUrl,
      onSave: () => _saveConfig(ref, serverUrlController, isLoading, context),
      onTest: () =>
          _testConnection(ref, serverUrlController, isTesting, context),
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
    ValueNotifier<bool> isLoading,
    BuildContext context,
  ) async {
    final serverUrl = serverUrlController.text.trim();
    if (serverUrl.isEmpty) return;

    isLoading.value = true;

    try {
      final config = OllamaConfig(serverUrl: serverUrl);
      await ref.read(_ollamaLocalConfigProvider.notifier).updateConfig(config);
      if (!context.mounted) return;
      _showSnackBar(context, "Ollama Local server URL saved", Colors.green);
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(context, "Failed to save server URL: $e", Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _testConnection(
    WidgetRef ref,
    TextEditingController serverUrlController,
    ValueNotifier<bool> isTesting,
    BuildContext context,
  ) async {
    final serverUrl = serverUrlController.text.trim();

    isTesting.value = true;

    try {
      final result = await testOllamaConnection(
        serverUrl.isEmpty ? provider.defaultServerUrl : serverUrl,
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
