import "dart:async";
import "dart:convert";

import "package:collection/collection.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "catalog.freezed.dart";
part "catalog.g.dart";

/// What the service said when the catalog last asked it for its models.
@freezed
sealed class ConnectionCheck with _$ConnectionCheck {
  const factory ConnectionCheck.checking() = CheckRunning;
  const factory ConnectionCheck.working(int models) = CheckWorking;

  /// The service refused the key.
  const factory ConnectionCheck.rejected() = CheckRejected;

  /// No answer about the key: offline, a server that is not running, or a
  /// service without a model list. The key may well be fine.
  const factory ConnectionCheck.unknown() = CheckUnknown;
}

/// The latest check per backend, written by [ModelCatalog], which asks each
/// service anyway. No entry means no check ran, such as for Apple's model.
@Riverpod(keepAlive: true)
class ConnectionChecks extends _$ConnectionChecks {
  @override
  Map<Backend, ConnectionCheck> build() => const {};

  void report(Backend backend, ConnectionCheck check) => state = {...state, backend: check};
}

/// Labels and prices from models.dev, bundled by `prices` (devenv). Also the
/// offline model list. Shape: {"anthropic": {"claude-haiku-4-5": {"label": ..., "in": 1, "out": 5}}}
typedef Bundled = Map<Backend, Map<String, ModelInfo>>;

@Riverpod(keepAlive: true)
Future<Bundled> bundledModels(Ref ref) async {
  return parseBundledModels(await ref.watch(bundledAssetProvider("assets/models.json").future));
}

Bundled parseBundledModels(String json) {
  final raw = jsonDecode(json) as Map<String, dynamic>;
  return {
    for (final MapEntry(:key, :value) in raw.entries)
      // Not `?key: value`: the value needs the backend too.
      // ignore: use_null_aware_elements
      if (Backend.values.asNameMap()[key] case final backend?)
        backend: {
          for (final MapEntry(key: id, value: m) in (value as Map<String, dynamic>).entries)
            if (!isEmbeddingModel(id))
              id: ModelInfo(
                ref: ModelRef(backend, id),
                label: m["label"] as String,
                price: Price(
                  inputPerMillion: (m["in"] as num).toDouble(),
                  outputPerMillion: (m["out"] as num).toDouble(),
                ),
                tools: m["tools"] as bool?,
              ),
        },
  };
}

/// Whether a model only turns text into vectors (for search) and cannot
/// write, so it must never be offered for a rewrite or the assistant.
/// Embedding models say so in their id almost everywhere: OpenAI's
/// "text-embedding-3-small", Google's "gemini-embedding-001", Ollama's
/// "nomic-embed-text" and "qwen3-embedding", LM Studio's
/// "text-embedding-nomic-embed-text-v1.5". The few that do not ("all-minilm",
/// "bge-m3" on Ollama) are BERT models, which Ollama names in their [family]
/// ("bert", "nomic-bert"). No chat model is either.
bool isEmbeddingModel(String id, {String? family}) =>
    id.toLowerCase().contains("embed") || (family?.toLowerCase().contains("bert") ?? false);

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then refreshes from each backend's own list
/// (llm_dart's ModelListingCapability) in the background.
@Riverpod(keepAlive: true)
class ModelCatalog extends _$ModelCatalog {
  @override
  Future<List<ModelInfo>> build() async {
    final connections = await ref.watch(connectionsProvider.future);
    final bundled = await ref.watch(bundledModelsProvider.future);
    final usable = connections.values.where((c) => c.isUsable).toList();
    unawaited(Future.microtask(() => _refresh(usable, bundled)));
    return [for (final c in usable) ..._fallback(c.backend, bundled)];
  }

  Future<void> _refresh(List<Connection> usable, Bundled bundled) async {
    final gateway = ref.read(llmGatewayProvider);
    final checks = ref.read(connectionChecksProvider.notifier);
    void report(Backend backend, ConnectionCheck check) {
      if (ref.mounted) checks.report(backend, check);
    }

    final lists = await Future.wait(
      usable.map((c) async {
        if (c.backend == Backend.apple) return _fallback(c.backend, bundled);
        report(c.backend, const ConnectionCheck.checking());
        try {
          final known = bundled[c.backend] ?? const {};
          final local = c.backend == Backend.ollama || c.backend == Backend.openaiCompatible;
          final listed = [
            for (final m in await gateway.models(c))
              // The big lists also hold audio, image and embedding models;
              // keep the ones we know prices for, or everything local that
              // can write. Only Ollama's description is a model family.
              if ((local || known.containsKey(m.id)) &&
                  !isEmbeddingModel(m.id, family: c.backend == Backend.ollama ? m.description : null))
                known[m.id] ?? ModelInfo(ref: ModelRef(c.backend, m.id), label: m.id, price: Price.free),
          ];
          report(c.backend, ConnectionCheck.working(listed.length));
          return listed;
        } on llm.AuthError {
          report(c.backend, const ConnectionCheck.rejected());
          return _fallback(c.backend, bundled);
        } on llm.LLMError {
          report(c.backend, const ConnectionCheck.unknown());
          return _fallback(c.backend, bundled); // offline, or no listing API
        }
      }),
    );
    if (!ref.mounted) return; // a newer build replaced this one
    state = AsyncData(lists.flattened.toList());
  }

  static List<ModelInfo> _fallback(Backend backend, Bundled bundled) => switch (backend) {
    Backend.apple => const [
      ModelInfo(ref: ModelRef(Backend.apple, "system"), label: "Apple on-device", price: Price.free),
    ],
    _ => bundled[backend]?.values.toList() ?? const [],
  };
}
