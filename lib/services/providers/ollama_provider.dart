import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "ollama_provider.g.dart";

const _storage = FlutterSecureStorage();
const _ollamaConfigKey = "ollama_config";

class OllamaConfig {
  const OllamaConfig({
    required this.serverUrl,
    this.timeout = 30000,
  });

  factory OllamaConfig.fromJson(Map<String, dynamic> json) {
    return OllamaConfig(
      serverUrl: json["serverUrl"] as String? ?? "http://localhost:11434",
      timeout: json["timeout"] as int? ?? 30000,
    );
  }

  final String serverUrl;
  final int timeout;

  Map<String, dynamic> toJson() {
    return {
      "serverUrl": serverUrl,
      "timeout": timeout,
    };
  }

  OllamaConfig copyWith({
    String? serverUrl,
    int? timeout,
  }) {
    return OllamaConfig(
      serverUrl: serverUrl ?? this.serverUrl,
      timeout: timeout ?? this.timeout,
    );
  }

  static const defaultConfig = OllamaConfig(
    serverUrl: "http://localhost:11434",
    timeout: 30000,
  );
}

sealed class OllamaConnectionResult {
  const OllamaConnectionResult();
}

class OllamaConnectionSuccess extends OllamaConnectionResult {
  const OllamaConnectionSuccess();
}

class OllamaConnectionError extends OllamaConnectionResult {
  const OllamaConnectionError(this.message);
  final String message;
}

@Riverpod(keepAlive: true)
class OllamaConfiguration extends _$OllamaConfiguration {
  @override
  Future<OllamaConfig> build() async {
    try {
      final configJson = await _storage.read(key: _ollamaConfigKey);
      if (configJson != null) {
        final json =
            Map<String, dynamic>.from(Uri.splitQueryString(configJson));
        return OllamaConfig.fromJson(json);
      }
    } on Exception catch (e) {
      debugPrint("Failed to load Ollama config: $e");
    }
    return OllamaConfig.defaultConfig;
  }

  Future<void> updateConfig(OllamaConfig config) async {
    try {
      final configString = Uri(
        queryParameters: config.toJson().map(
              (key, value) => MapEntry(key, value.toString()),
            ),
      ).query;
      await _storage.write(key: _ollamaConfigKey, value: configString);
      ref.invalidateSelf();
    } catch (e) {
      throw Exception("Failed to save configuration: $e");
    }
  }

  Future<void> setServerUrl(String serverUrl) async {
    final currentConfig = await future;
    final newConfig = currentConfig.copyWith(serverUrl: serverUrl.trim());
    await updateConfig(newConfig);
  }

  Future<OllamaConnectionResult> testConnection([String? customUrl]) async {
    try {
      final config = customUrl != null
          ? OllamaConfig(serverUrl: customUrl.trim())
          : await future;

      final dio = Dio(
        BaseOptions(
          connectTimeout: Duration(milliseconds: config.timeout),
          receiveTimeout: Duration(milliseconds: config.timeout),
        ),
      );

      final response = await dio.get("${config.serverUrl}/api/tags");

      if (response.statusCode == 200) {
        return const OllamaConnectionSuccess();
      } else {
        return OllamaConnectionError(
          "Server responded with status ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return const OllamaConnectionError("Connection timeout");
        case DioExceptionType.connectionError:
          return const OllamaConnectionError(
            "Could not connect to Ollama server. Make sure it's running.",
          );
        default:
          return OllamaConnectionError("Network error: ${e.message}");
      }
    } on Exception catch (e) {
      return OllamaConnectionError("Unexpected error: $e");
    }
  }
}

class OllamaProvider extends AiProvider {
  const OllamaProvider();

  @override
  String get name => "ollama";

  @override
  String get displayName => "Ollama";

  String get defaultServerUrl => "http://localhost:11434";

  @override
  Future<List<AiModel>> fetchAvailableModels(Ref ref) async {
    try {
      final config = await ref.read(ollamaConfigurationProvider.future);

      final dio = Dio(
        BaseOptions(
          connectTimeout: Duration(milliseconds: config.timeout),
          receiveTimeout: Duration(milliseconds: config.timeout),
        ),
      );

      final response = await dio.get("${config.serverUrl}/api/tags");

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final models = data["models"] as List<dynamic>? ?? [];

        return models.map((model) {
          final modelMap = model as Map<String, dynamic>;
          final modelName = modelMap["name"] as String;
          final displayName = modelName.split(":").first;

          return AiModel(
            name: modelName,
            displayName: displayName,
            provider: this,
            pricePerMillionInputTokens: 0,
            pricePerMillionOutputTokens: 0,
          );
        }).toList();
      }
    } on DioException catch (e) {
      debugPrint("Failed to fetch Ollama models: ${e.message}");
    } on Exception catch (e) {
      debugPrint("Unexpected error fetching Ollama models: $e");
    }
    return [];
  }

  @override
  Widget buildConfigurationWidget({
    required WidgetRef ref,
  }) {
    return const OllamaConfigurationWidget();
  }

  @override
  Stream<GenerationEvent> generateContent({
    required String prompt,
    required String inputText,
    required AiModel model,
    required Ref ref,
  }) async* {
    yield const LoadingEvent(message: "Getting server configuration...");

    try {
      final config = await ref.read(ollamaConfigurationProvider.future);

      yield const LoadingEvent(message: "Connecting to Ollama...");

      final provider = await llm
          .ai()
          .ollama(
            (builder) =>
                builder.numGpu(-1).numBatch(512).keepAlive("5m").numa(true),
          )
          .baseUrl(config.serverUrl)
          .model(model.name)
          .systemPrompt(prompt)
          .build();

      yield const LoadingEvent(message: "Generating content...");

      final messages = [
        llm.ChatMessage.user(inputText),
      ];

      final stream = provider.chatStream(messages);

      await for (final event in stream) {
        switch (event) {
          case llm.ThinkingDeltaEvent(delta: final delta):
            yield ThinkingDeltaEvent(delta: delta);
          case llm.TextDeltaEvent(delta: final delta):
            yield TextDeltaEvent(delta: delta);
          case llm.CompletionEvent(response: final response):
            debugPrint("Ollama response: ${response.text}");
            if (response.text != null) {
              yield UsageEvent(
                usage: RequestUsage(
                  promptTokenCount: inputText.length ~/ 4,
                  completionTokenCount: response.text!.length ~/ 4,
                  modelName: model.name,
                  providerName: model.provider.name,
                  cost: 0,
                ),
              );
            }
          case llm.ErrorEvent(error: final error):
            yield ErrorEvent(error: error.message);
          default:
            break;
        }
      }
    } on Exception catch (e) {
      yield ErrorEvent(error: "Failed to generate content: $e");
    }
  }
}

class OllamaConfigurationWidget extends HookConsumerWidget {
  const OllamaConfigurationWidget({super.key});

  void _showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> _saveServerUrl(
    WidgetRef ref,
    TextEditingController serverUrlController,
    ValueNotifier<bool> isLoading,
    BuildContext context,
  ) async {
    final serverUrl = serverUrlController.text.trim();
    if (serverUrl.isEmpty) return;

    isLoading.value = true;

    try {
      await ref
          .read(ollamaConfigurationProvider.notifier)
          .setServerUrl(serverUrl);
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Ollama server URL saved",
        Colors.green,
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Failed to save server URL: $e",
        Colors.red,
      );
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
    final serverUrl = serverUrlController.text.trim().ifEmpty;

    isTesting.value = true;

    try {
      final result = await ref
          .read(ollamaConfigurationProvider.notifier)
          .testConnection(serverUrl);

      if (!context.mounted) return;

      switch (result) {
        case OllamaConnectionSuccess():
          _showSnackBar(
            context,
            "Connection successful!",
            Colors.green,
          );
        case OllamaConnectionError(message: final message):
          _showSnackBar(
            context,
            "Connection failed: $message",
            Colors.red,
          );
      }
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Unexpected error: $e",
        Colors.red,
      );
    } finally {
      isTesting.value = false;
    }
  }

  Future<void> _refreshModels(WidgetRef ref, BuildContext context) async {
    try {
      ref.invalidate(modelRegistryProvider);
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Models refreshed",
        Colors.blue,
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      _showSnackBar(
        context,
        "Failed to refresh models: $e",
        Colors.red,
      );
    }
  }

  Widget _buildActionButtons(
    TextEditingController serverUrlController,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> isTesting,
    WidgetRef ref,
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading.value || isTesting.value
                    ? null
                    : () => _saveServerUrl(
                          ref,
                          serverUrlController,
                          isLoading,
                          context,
                        ),
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Save Server URL"),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isLoading.value || isTesting.value
                  ? null
                  : () => _testConnection(
                        ref,
                        serverUrlController,
                        isTesting,
                        context,
                      ),
              child: isTesting.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Test"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _refreshModels(ref, context),
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh Models"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServerUrlField(TextEditingController serverUrlController) {
    return TextField(
      controller: serverUrlController,
      decoration: const InputDecoration(
        labelText: "Ollama Server URL",
        hintText: "http://localhost:11434",
        border: OutlineInputBorder(),
        helperText: "Default: http://localhost:11434",
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ollama Configuration",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "Configure your Ollama server connection. Make sure Ollama is running before testing the connection.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serverUrlController = useTextEditingController();
    final isLoading = useState(false);
    final isTesting = useState(false);
    final config = ref.watch(ollamaConfigurationProvider);

    useEffect(
      () {
        config.whenData((config) {
          serverUrlController.text = config.serverUrl;
        });
        return null;
      },
      [config],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _buildHeader(context),
        _buildServerUrlField(serverUrlController),
        _buildActionButtons(
          serverUrlController,
          isLoading,
          isTesting,
          ref,
          context,
        ),
      ],
    );
  }
}

extension on String {
  String? get ifEmpty => isEmpty ? null : this;
}
