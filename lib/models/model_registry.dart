import "package:collection/collection.dart";
import "package:grammar_guard/models/ai_model.dart";
import "package:grammar_guard/services/provider_registry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "model_registry.g.dart";

@Riverpod(keepAlive: true)
class ModelRegistry extends _$ModelRegistry {
  @override
  Future<List<AiModel>> build() async {
    final providers = ref.watch(providerRegistryProvider);
    final models = await Future.wait(
      providers.map((provider) => provider.fetchAvailableModels(ref)),
    );
    return models.expand((m) => m).toList();
  }
}

@Riverpod(keepAlive: true)
AiModel? defaultModel(Ref ref) {
  return ref.watch(modelRegistryProvider).value?.firstOrNull;
}

@riverpod
Future<List<AiModel>> configuredModels(
  Ref ref,
  Set<String> configuredProviders,
) async {
  final models = await ref.watch(modelRegistryProvider.future);
  return models.where((model) {
    return configuredProviders.contains(model.provider.name);
  }).toList();
}

@riverpod
Future<AiModel?> model(Ref ref, String name) async {
  final models = await ref.watch(modelRegistryProvider.future);
  return models.firstWhereOrNull((model) => model.name == name);
}

@riverpod
Future<List<AiModel>> modelsForProvider(Ref ref, String providerName) async {
  final models = await ref.watch(modelRegistryProvider.future);
  return models.where((model) => model.provider.name == providerName).toList();
}
