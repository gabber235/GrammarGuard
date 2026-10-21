import "package:dio/dio.dart";
import "package:grammar_guard/llm/apple_model.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "gateway.g.dart";

@Riverpod(keepAlive: true)
LlmGateway llmGateway(Ref ref) => const LlmDartGateway();

/// Builds llm_dart clients. The only place that knows each backend.
class LlmDartGateway implements LlmGateway {
  const LlmDartGateway({this.newDio});

  /// Contract tests pass a client with a ReplayAdapter; llm_dart fills in
  /// the base URL and auth headers. Null in the app.
  final Dio Function()? newDio;

  @override
  Future<llm.ChatCapability> chat(
    Connection connection,
    ModelRef model, {
    required String system,
    ModelOptions options = const ModelOptions(),
    bool webSearch = false,
  }) async {
    if (model.backend == Backend.apple) return AppleChat(system: system);
    var builder = _builder(connection).model(model.id).systemPrompt(system);
    if (newDio case final dio?) builder = builder.http((http) => http.dioClient(dio()));
    if (options.temperature case final t?) builder = builder.temperature(t);
    if (options.reasoningEffort case final effort?) builder = builder.reasoningEffort(effort);
    // At most 3 searches per message, about 1 cent each.
    if (webSearch && model.backend.canSearch) builder = builder.webSearch(maxUses: 3);
    return builder.build();
  }

  @override
  Future<List<llm.AIModel>> models(Connection connection) async {
    final listing = await _builder(connection).buildModelListing();
    return listing.models();
  }

  llm.LLMBuilder _builder(Connection c) {
    final base = llm.ai();
    final key = c.apiKey ?? "";
    // Only local servers have an address; cloud backends must not ask.
    String url() => c.serverUrl.toString();
    return switch (c.backend) {
      Backend.anthropic => base.anthropic().apiKey(key),
      Backend.openai => base.openai().apiKey(key),
      Backend.google => base.google().apiKey(key),
      Backend.deepseek => base.deepseek().apiKey(key),
      Backend.xai => base.xai().apiKey(key),
      Backend.groq => base.groq().apiKey(key),
      Backend.phind => base.phind().apiKey(key),
      Backend.openrouter => base.openRouter().apiKey(key),
      Backend.ollama =>
        key.isEmpty ? base.ollama((o) => o.keepAlive("5m")).baseUrl(url()) : base.ollama().baseUrl(url()).apiKey(key),
      // Local servers accept any key; llm_dart requires a non-empty one.
      Backend.openaiCompatible => base.openai().baseUrl(url()).apiKey(key.isEmpty ? "none" : key),
      Backend.apple => throw StateError("Apple runs on device, not over HTTP."),
    };
  }
}
