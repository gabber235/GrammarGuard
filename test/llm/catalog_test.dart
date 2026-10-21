import "dart:convert";
import "dart:io";

import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/apple_model.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("the bundled list knows which models can call tools", () {
    final bundled = parseBundledModels(File("assets/models.json").readAsStringSync());
    // The priciest Google model draws images and has no tools, so the
    // assistant must not pick it.
    expect(bundled[Backend.google]!["gemini-3-pro-image"]?.tools, isFalse);
    expect(bundled[Backend.anthropic]!.values.map((m) => m.tools), everyElement(isTrue));
  });

  test("embedding models are known by their id, or by a BERT family", () {
    for (final (id, family) in [
      ("text-embedding-3-small", null),
      ("gemini-embedding-001", null),
      ("nomic-embed-text:latest", "nomic-bert"),
      ("qwen3-embedding:0.6b", "qwen3"),
      ("text-embedding-nomic-embed-text-v1.5", null),
      ("all-minilm:latest", "bert"),
      ("bge-m3:latest", "bert"),
    ]) {
      expect(isEmbeddingModel(id, family: family), isTrue, reason: id);
    }
    for (final (id, family) in [
      ("claude-haiku-4-5", null),
      ("gpt-5-nano", null),
      ("llama3.2:latest", "llama"),
      ("qwen3:8b", "qwen3"),
      ("gemma3:4b", "gemma3"),
    ]) {
      expect(isEmbeddingModel(id, family: family), isFalse, reason: id);
    }
  });

  test("the bundled list offers no embedding models", () {
    final bundled = parseBundledModels(File("assets/models.json").readAsStringSync());
    // OpenAI's cheapest "models" are embeddings; listed, the first one would
    // become the default.
    expect(bundled[Backend.openai], isNot(contains("text-embedding-3-small")));
    expect(bundled[Backend.google], isNot(contains("gemini-embedding-001")));
  });

  test("a local server's embedding models are left out of the catalog", () async {
    SharedPreferences.setMockInitialValues({
      "connections_v2": jsonEncode({
        "ollama": {"enabled": true},
      }),
    });
    FlutterSecureStorage.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        appleModelAvailableProvider.overrideWith((ref) async => false),
        bundledAssetProvider.overrideWith((ref, key) async => File(key).readAsStringSync()),
        llmGatewayProvider.overrideWithValue(
          const _Listing([
            // What llm_dart makes of Ollama's /api/tags: the details' family
            // becomes the description.
            llm.AIModel(id: "llama3.2:latest", description: "llama"),
            llm.AIModel(id: "nomic-embed-text:latest", description: "nomic-bert"),
            llm.AIModel(id: "all-minilm:latest", description: "bert"),
            llm.AIModel(id: "qwen3:8b", description: "qwen3"),
          ]),
        ),
      ],
    );
    addTearDown(container.dispose);
    final listened = container.listen(modelCatalogProvider, (_, _) {});

    await container.read(modelCatalogProvider.future);
    await pumpEventQueue(); // the background refresh

    expect(listened.read().value?.map((m) => m.ref.id), ["llama3.2:latest", "qwen3:8b"]);
  });
}

/// A gateway that only lists [models].
class _Listing implements LlmGateway {
  const _Listing(this.listed);

  final List<llm.AIModel> listed;

  @override
  Future<List<llm.AIModel>> models(Connection connection) async => listed;

  @override
  Future<llm.ChatCapability> chat(
    Connection connection,
    ModelRef model, {
    required String system,
    ModelOptions options = const ModelOptions(),
    bool webSearch = false,
  }) => throw UnimplementedError();
}
