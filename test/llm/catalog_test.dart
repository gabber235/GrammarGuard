import "dart:async";
import "dart:convert";
import "dart:io";

import "package:clock/clock.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/apple_model.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/connections.dart";
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

  group("refreshing", () {
    const llama = llm.AIModel(id: "llama3.2:latest");
    const qwen = llm.AIModel(id: "qwen3:8b");

    /// A catalog that finished its first listing from [gateway].
    Future<ProviderContainer> catalogFrom(_Changing gateway) async {
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
          llmGatewayProvider.overrideWithValue(gateway),
        ],
      );
      addTearDown(container.dispose);
      container.listen(modelCatalogProvider, (_, _) {});
      await container.read(modelCatalogProvider.future);
      await pumpEventQueue();
      return container;
    }

    List<String>? ids(ProviderContainer app) => app.read(modelCatalogProvider).value?.map((m) => m.ref.id).toList();
    Future<void> refresh(ProviderContainer app) => app.read(modelCatalogProvider.notifier).refresh();

    test("a server started after the app brings its models", () async {
      final gateway = _Changing()..failure = const llm.HttpError("refused");
      final app = await catalogFrom(gateway);
      expect(ids(app), isEmpty);
      expect(app.read(connectionChecksProvider)[Backend.ollama], const ConnectionCheck.unknown());

      gateway
        ..failure = null
        ..listed = [llama];
      await refresh(app);

      expect(ids(app), ["llama3.2:latest"]);
      expect(app.read(connectionChecksProvider)[Backend.ollama], const ConnectionCheck.working(1));
    });

    test("a pulled model joins the end and a removed one leaves, so the default stays put", () async {
      final gateway = _Changing()..listed = [llama];
      final app = await catalogFrom(gateway);

      // Ollama lists the newest first.
      gateway.listed = [qwen, llama];
      await refresh(app);
      expect(ids(app), ["llama3.2:latest", "qwen3:8b"]);

      gateway.listed = [qwen];
      await refresh(app);
      expect(ids(app), ["qwen3:8b"]);
    });

    test("a server that stops answering keeps its models, so a pick does not move to another service", () async {
      final gateway = _Changing()..listed = [llama];
      final app = await catalogFrom(gateway);

      gateway.failure = const llm.HttpError("refused");
      await refresh(app);

      expect(ids(app), ["llama3.2:latest"]);
      expect(app.read(connectionChecksProvider)[Backend.ollama], const ConnectionCheck.unknown());
    });

    test("an unchanged list is not news and the status does not flash", () async {
      final gateway = _Changing()..listed = [llama];
      final app = await catalogFrom(gateway);
      var catalogChanges = 0;
      final checks = <ConnectionCheck?>[];
      app
        ..listen(modelCatalogProvider, (_, _) => catalogChanges++)
        ..listen(connectionChecksProvider, (_, next) => checks.add(next[Backend.ollama]));

      await refresh(app);

      expect(catalogChanges, 0);
      expect(checks, isNot(contains(const ConnectionCheck.checking())));
    });

    test("refreshes that overlap ask once", () async {
      final gateway = _Changing()..listed = [llama];
      final app = await catalogFrom(gateway);
      final before = gateway.asked;

      await Future.wait([refresh(app), refresh(app)]);

      expect(gateway.asked, before + 1);
    });

    test("a listing a settings change replaced says nothing", () async {
      final gateway = _Changing()..listed = [llama];
      final app = await catalogFrom(gateway);

      final slow = Completer<void>();
      gateway.hold = slow;
      unawaited(refresh(app));
      await pumpEventQueue();
      await app.read(connectionsProvider.notifier).save(const Connection(backend: Backend.ollama, enabled: false));
      await app.read(modelCatalogProvider.future);
      await pumpEventQueue();

      slow.complete();
      await pumpEventQueue();

      expect(ids(app), isEmpty);
    });

    test("a cloud service that could not answer at launch keeps the shown order and is asked again", () async {
      final gateway = _Changing()..failure = const llm.HttpError("offline");
      FlutterSecureStorage.setMockInitialValues({"claude_api_key": "key"});
      SharedPreferences.setMockInitialValues({
        "connections_v2": jsonEncode({
          "anthropic": {"enabled": true},
        }),
      });
      final app = ProviderContainer(
        overrides: [
          appleModelAvailableProvider.overrideWith((ref) async => false),
          bundledAssetProvider.overrideWith((ref, key) async => File(key).readAsStringSync()),
          llmGatewayProvider.overrideWithValue(gateway),
        ],
      );
      addTearDown(app.dispose);
      app.listen(modelCatalogProvider, (_, _) {});
      await app.read(modelCatalogProvider.future);
      await pumpEventQueue();
      final shown = ids(app)!;
      expect(shown.length, greaterThan(1));

      gateway
        ..failure = null
        ..listed = [for (final id in shown.reversed) llm.AIModel(id: id)];
      await refresh(app);

      expect(gateway.asked, 2);
      expect(ids(app), shown);
    });

    test("a cloud service is asked again only after a while, a local server every time", () async {
      final gateway = _Changing()..listed = [const llm.AIModel(id: "claude-haiku-4-5")];
      final start = DateTime(2026, 11, 5, 12);
      FlutterSecureStorage.setMockInitialValues({"claude_api_key": "key"});
      SharedPreferences.setMockInitialValues({
        "connections_v2": jsonEncode({
          "anthropic": {"enabled": true},
          "ollama": {"enabled": true},
        }),
      });
      final app = ProviderContainer(
        overrides: [
          appleModelAvailableProvider.overrideWith((ref) async => false),
          bundledAssetProvider.overrideWith((ref, key) async => File(key).readAsStringSync()),
          llmGatewayProvider.overrideWithValue(gateway),
        ],
      );
      addTearDown(app.dispose);

      await withClock(Clock.fixed(start), () async {
        app.listen(modelCatalogProvider, (_, _) {});
        await app.read(modelCatalogProvider.future);
        await pumpEventQueue();
      });
      expect(gateway.askedBackends, unorderedEquals([Backend.anthropic, Backend.ollama]));

      gateway.askedBackends.clear();
      await withClock(Clock.fixed(start.add(const Duration(minutes: 1))), () => refresh(app));
      expect(gateway.askedBackends, [Backend.ollama]);

      gateway.askedBackends.clear();
      await withClock(Clock.fixed(start.add(const Duration(minutes: 6))), () => refresh(app));
      expect(gateway.askedBackends, unorderedEquals([Backend.anthropic, Backend.ollama]));
    });
  });
}

/// A gateway whose list can change between refreshes, as a real server's does.
class _Changing implements LlmGateway {
  List<llm.AIModel> listed = const [];
  llm.LLMError? failure;

  /// Keeps the next listing waiting until completed.
  Completer<void>? hold;
  final askedBackends = <Backend>[];
  int get asked => askedBackends.length;

  @override
  Future<List<llm.AIModel>> models(Connection connection) async {
    askedBackends.add(connection.backend);
    await hold?.future;
    if (failure case final error?) throw error;
    return listed;
  }

  @override
  Future<llm.ChatCapability> chat(
    Connection connection,
    ModelRef model, {
    required String system,
    ModelOptions options = const ModelOptions(),
    bool webSearch = false,
  }) => throw UnimplementedError();
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
