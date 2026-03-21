import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/ai_provider.dart";
import "package:grammar_guard/services/generation_event.dart";
import "package:grammar_guard/state/ai_usage.dart";
import "package:llm_dart/llm_dart.dart" as llm;

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

class OllamaConfig {
  const OllamaConfig({required this.serverUrl, this.timeout = 30000});

  factory OllamaConfig.fromJson(Map<String, dynamic> json) {
    final rawTimeout = json["timeout"];
    final parsedTimeout = rawTimeout is int
        ? rawTimeout
        : rawTimeout is String
        ? int.tryParse(rawTimeout) ?? 30000
        : 30000;

    return OllamaConfig(
      serverUrl: json["serverUrl"] as String? ?? "http://localhost:11434",
      timeout: parsedTimeout,
    );
  }

  final String serverUrl;
  final int timeout;

  Map<String, dynamic> toJson() {
    return {"serverUrl": serverUrl, "timeout": timeout};
  }

  OllamaConfig copyWith({String? serverUrl, int? timeout}) {
    return OllamaConfig(
      serverUrl: serverUrl ?? this.serverUrl,
      timeout: timeout ?? this.timeout,
    );
  }
}

Future<OllamaConnectionResult> testOllamaConnection(
  String serverUrl, {
  int timeout = 30000,
  String? apiKey,
}) async {
  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: timeout),
      receiveTimeout: Duration(milliseconds: timeout),
    ),
  );

  try {
    final response = await dio.get(
      "$serverUrl/api/tags",
      options: apiKey != null && apiKey.isNotEmpty
          ? Options(headers: {"Authorization": "Bearer $apiKey"})
          : null,
    );

    if (response.statusCode == 200) {
      return const OllamaConnectionSuccess();
    }
    return OllamaConnectionError(
      "Server responded with status ${response.statusCode}",
    );
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

Future<List<AiModel>> fetchOllamaModels({
  required String serverUrl,
  required AiProvider provider,
  int timeout = 30000,
  String? apiKey,
}) async {
  try {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(milliseconds: timeout),
        receiveTimeout: Duration(milliseconds: timeout),
      ),
    );

    final response = await dio.get(
      "$serverUrl/api/tags",
      options: apiKey != null && apiKey.isNotEmpty
          ? Options(headers: {"Authorization": "Bearer $apiKey"})
          : null,
    );

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
          provider: provider,
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

Stream<GenerationEvent> generateOllamaContent({
  required String serverUrl,
  required String prompt,
  required String inputText,
  required AiModel model,
  String? apiKey,
}) async* {
  yield const LoadingEvent(message: "Getting server configuration...");

  yield const LoadingEvent(message: "Connecting to Ollama...");

  final builder = llm
      .ai()
      .ollama((b) => b.numGpu(-1).numBatch(2048).keepAlive("60m").numa(true))
      .baseUrl(serverUrl)
      .model(model.name)
      .systemPrompt(prompt);

  if (apiKey != null && apiKey.isNotEmpty) {
    builder.apiKey(apiKey);
  }

  final llmProvider = await builder.build();

  yield const LoadingEvent(message: "Generating content...");

  final messages = [llm.ChatMessage.user(inputText)];
  final stream = llmProvider.chatStream(messages);

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
}

class OllamaSharedConfigWidget extends StatelessWidget {
  const OllamaSharedConfigWidget({
    required this.serverUrlController,
    required this.isLoading,
    required this.isTesting,
    required this.onSave,
    required this.onTest,
    required this.onRefreshModels,
    required this.providerDisplayName,
    required this.showApiKeyField,
    this.apiKeyController,
    this.defaultServerUrl = "http://localhost:11434",
    super.key,
  });

  final TextEditingController serverUrlController;
  final TextEditingController? apiKeyController;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<bool> isTesting;
  final VoidCallback onSave;
  final VoidCallback onTest;
  final VoidCallback onRefreshModels;
  final String providerDisplayName;
  final bool showApiKeyField;
  final String defaultServerUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        _buildHeader(context),
        _buildServerUrlField(),
        if (showApiKeyField && apiKeyController != null) _buildApiKeyField(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$providerDisplayName Configuration",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          showApiKeyField
              ? "Configure your Ollama Cloud connection."
              : "Configure your Ollama local server connection. Make sure Ollama is running.",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildServerUrlField() {
    return TextField(
      controller: serverUrlController,
      decoration: InputDecoration(
        labelText: "$providerDisplayName Server URL",
        hintText: defaultServerUrl,
        border: const OutlineInputBorder(),
        helperText: "Default: $defaultServerUrl",
      ),
    );
  }

  Widget _buildApiKeyField() {
    return TextField(
      controller: apiKeyController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: "API Key (optional)",
        hintText: "Enter API key if required",
        border: OutlineInputBorder(),
        helperText: "API key is optional for this provider",
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading.value || isTesting.value ? null : onSave,
                child: isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        showApiKeyField
                            ? "Save Configuration"
                            : "Save Server URL",
                      ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isLoading.value || isTesting.value ? null : onTest,
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
            onPressed: onRefreshModels,
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
}
