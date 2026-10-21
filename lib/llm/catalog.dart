import "dart:async";
import "dart:convert";

import "package:collection/collection.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "catalog.g.dart";

/// Labels and prices from models.dev, bundled by `just prices`. Also the
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
    final lists = await Future.wait(
      usable.map((c) async {
        if (c.backend == Backend.apple) return _fallback(c.backend, bundled);
        try {
          final known = bundled[c.backend] ?? const {};
          final local = c.backend == Backend.ollama || c.backend == Backend.openaiCompatible;
          return [
            for (final m in await gateway.models(c))
              // The big lists also hold audio, image and embedding models;
              // keep the ones we know prices for, or everything local.
              if (local || known.containsKey(m.id))
                known[m.id] ?? ModelInfo(ref: ModelRef(c.backend, m.id), label: m.id, price: Price.free),
          ];
        } on llm.LLMError {
          return _fallback(c.backend, bundled); // offline, wrong key, or no listing API
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
