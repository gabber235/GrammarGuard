import "package:freezed_annotation/freezed_annotation.dart";
import "package:llm_dart/llm_dart.dart" as llm;

part "llm.freezed.dart";

/// Every chat backend llm_dart supports, plus Apple's on-device model.
/// test/llm/backend_test.dart fails when llm_dart registers a chat
/// provider that is missing here, so the list stays complete.
enum Backend {
  // Keeps the existing secure storage key "claude_api_key".
  anthropic("Anthropic", key: KeyNeed.required, secretName: "claude"),
  openai("OpenAI", key: KeyNeed.required),
  google("Google Gemini", key: KeyNeed.required, secretName: "gemini"),
  deepseek("DeepSeek", key: KeyNeed.required),
  xai("xAI Grok", key: KeyNeed.required),
  groq("Groq", key: KeyNeed.required),
  phind("Phind", key: KeyNeed.required),
  openrouter("OpenRouter", key: KeyNeed.required),
  // Local by default. With a key and https://ollama.com it is Ollama Cloud.
  ollama("Ollama", key: KeyNeed.optional, defaultUrl: "http://localhost:11434"),
  openaiCompatible("OpenAI compatible server", key: KeyNeed.optional, defaultUrl: "http://localhost:1234/v1/"),
  apple("Apple on-device", key: KeyNeed.none);

  const Backend(this.label, {required this.key, this.defaultUrl, this._secretName});

  final String label;
  final KeyNeed key;

  /// Present when the user can change the server address.
  final String? defaultUrl;
  final String? _secretName;

  String get secretKey => "${_secretName ?? name}_api_key";

  /// The provider's own web search tool exists for these.
  bool get canSearch => switch (this) {
    anthropic || openai || google || xai || openrouter => true,
    _ => false,
  };
}

enum KeyNeed { required, optional, none }

/// The user's saved settings for one backend. The key lives in secure storage.
@freezed
abstract class Connection with _$Connection {
  const Connection._();

  const factory Connection({
    required Backend backend,

    /// Off by default for local servers, so startup never waits on one.
    required bool enabled,
    String? apiKey,
    Uri? baseUrl,
  }) = _Connection;

  bool get isUsable =>
      enabled &&
      switch (backend.key) {
        KeyNeed.required => (apiKey ?? "").isNotEmpty,
        KeyNeed.optional || KeyNeed.none => true,
      };

  Uri get serverUrl => baseUrl ?? Uri.parse(backend.defaultUrl!);
}

/// A model on a backend. Written as "backend/model-id" in library.yaml.
@freezed
abstract class ModelRef with _$ModelRef {
  const ModelRef._();

  const factory ModelRef(Backend backend, String id) = _ModelRef;

  /// Null for unknown backends or malformed values.
  static ModelRef? tryParse(String value) {
    final slash = value.indexOf("/");
    if (slash <= 0) return null;
    final backend = Backend.values.asNameMap()[value.substring(0, slash)];
    return backend == null ? null : ModelRef(backend, value.substring(slash + 1));
  }

  @override
  String toString() => "${backend.name}/$id";
}

@freezed
abstract class Price with _$Price {
  const Price._();

  const factory Price({required double inputPerMillion, required double outputPerMillion}) = _Price;

  static const free = Price(inputPerMillion: 0, outputPerMillion: 0);

  double cost(llm.UsageInfo usage) =>
      (usage.promptTokens ?? 0) / 1e6 * inputPerMillion + (usage.completionTokens ?? 0) / 1e6 * outputPerMillion;
}

@freezed
abstract class ModelInfo with _$ModelInfo {
  const factory ModelInfo({
    required ModelRef ref,
    required String label,

    /// Null when unknown; local backends are [Price.free].
    Price? price,

    /// Whether the model can call tools, which the assistant needs. Null
    /// when unknown (models a server lists that models.dev does not know).
    bool? tools,
  }) = _ModelInfo;
}

/// Per profile model settings. Null means the backend's default.
@freezed
abstract class ModelOptions with _$ModelOptions {
  const factory ModelOptions({double? temperature, llm.ReasoningEffort? reasoningEffort}) = _ModelOptions;
}

/// The one seam between GrammarGuard and model APIs. Everything else uses
/// llm_dart's own ChatCapability, messages, tools and stream events; tests
/// return a ScriptedChat that extends llm.ChatCapability.
abstract interface class LlmGateway {
  Future<llm.ChatCapability> chat(
    Connection connection,
    ModelRef model, {
    required String system,
    ModelOptions options = const ModelOptions(),
    bool webSearch = false,
  });

  /// The backend's own model list. Throws when the backend has none
  /// (xAI, Groq, Phind); the catalog then uses the bundled list.
  Future<List<llm.AIModel>> models(Connection connection);
}
