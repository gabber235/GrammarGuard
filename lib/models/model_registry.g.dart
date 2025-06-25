// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_registry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ModelRegistry)
const modelRegistryProvider = ModelRegistryProvider._();

final class ModelRegistryProvider
    extends $AsyncNotifierProvider<ModelRegistry, List<AiModel>> {
  const ModelRegistryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'modelRegistryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modelRegistryHash();

  @$internal
  @override
  ModelRegistry create() => ModelRegistry();

  @$internal
  @override
  $AsyncNotifierProviderElement<ModelRegistry, List<AiModel>> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$modelRegistryHash() => r'b047c1171e489ffcbd2f25fd571d94e3c9689f15';

abstract class _$ModelRegistry extends $AsyncNotifier<List<AiModel>> {
  FutureOr<List<AiModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<AiModel>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<AiModel>>>,
        AsyncValue<List<AiModel>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(defaultModel)
const defaultModelProvider = DefaultModelProvider._();

final class DefaultModelProvider extends $FunctionalProvider<AiModel?, AiModel?>
    with $Provider<AiModel?> {
  const DefaultModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'defaultModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$defaultModelHash();

  @$internal
  @override
  $ProviderElement<AiModel?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiModel? create(Ref ref) {
    return defaultModel(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiModel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AiModel?>(value),
    );
  }
}

String _$defaultModelHash() => r'f8b969dfb48d8ddee123d68e864a0e12b4ea4703';

@ProviderFor(configuredModels)
const configuredModelsProvider = ConfiguredModelsFamily._();

final class ConfiguredModelsProvider extends $FunctionalProvider<
        AsyncValue<List<AiModel>>, FutureOr<List<AiModel>>>
    with $FutureModifier<List<AiModel>>, $FutureProvider<List<AiModel>> {
  const ConfiguredModelsProvider._(
      {required ConfiguredModelsFamily super.from,
      required Set<String> super.argument})
      : super(
          retry: null,
          name: r'configuredModelsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$configuredModelsHash();

  @override
  String toString() {
    return r'configuredModelsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AiModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiModel>> create(Ref ref) {
    final argument = this.argument as Set<String>;
    return configuredModels(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ConfiguredModelsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$configuredModelsHash() => r'6a0dd972a286f3123b62a5991e33117e83317bb3';

final class ConfiguredModelsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AiModel>>, Set<String>> {
  const ConfiguredModelsFamily._()
      : super(
          retry: null,
          name: r'configuredModelsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ConfiguredModelsProvider call(
    Set<String> configuredProviders,
  ) =>
      ConfiguredModelsProvider._(argument: configuredProviders, from: this);

  @override
  String toString() => r'configuredModelsProvider';
}

@ProviderFor(model)
const modelProvider = ModelFamily._();

final class ModelProvider
    extends $FunctionalProvider<AsyncValue<AiModel?>, FutureOr<AiModel?>>
    with $FutureModifier<AiModel?>, $FutureProvider<AiModel?> {
  const ModelProvider._(
      {required ModelFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'modelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modelHash();

  @override
  String toString() {
    return r'modelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AiModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AiModel?> create(Ref ref) {
    final argument = this.argument as String;
    return model(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$modelHash() => r'69438b31262459709811e579c97d233b8eaa6850';

final class ModelFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AiModel?>, String> {
  const ModelFamily._()
      : super(
          retry: null,
          name: r'modelProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ModelProvider call(
    String name,
  ) =>
      ModelProvider._(argument: name, from: this);

  @override
  String toString() => r'modelProvider';
}

@ProviderFor(modelsForProvider)
const modelsForProviderProvider = ModelsForProviderFamily._();

final class ModelsForProviderProvider extends $FunctionalProvider<
        AsyncValue<List<AiModel>>, FutureOr<List<AiModel>>>
    with $FutureModifier<List<AiModel>>, $FutureProvider<List<AiModel>> {
  const ModelsForProviderProvider._(
      {required ModelsForProviderFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'modelsForProviderProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$modelsForProviderHash();

  @override
  String toString() {
    return r'modelsForProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AiModel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AiModel>> create(Ref ref) {
    final argument = this.argument as String;
    return modelsForProvider(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ModelsForProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$modelsForProviderHash() => r'f53251ad3a7d37488b9b558b2da4885eee828443';

final class ModelsForProviderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AiModel>>, String> {
  const ModelsForProviderFamily._()
      : super(
          retry: null,
          name: r'modelsForProviderProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ModelsForProviderProvider call(
    String providerName,
  ) =>
      ModelsForProviderProvider._(argument: providerName, from: this);

  @override
  String toString() => r'modelsForProviderProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
