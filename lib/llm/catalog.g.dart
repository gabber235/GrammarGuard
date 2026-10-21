// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bundledModels)
final bundledModelsProvider = BundledModelsProvider._();

final class BundledModelsProvider extends $FunctionalProvider<AsyncValue<Bundled>, Bundled, FutureOr<Bundled>>
    with $FutureModifier<Bundled>, $FutureProvider<Bundled> {
  BundledModelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bundledModelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bundledModelsHash();

  @$internal
  @override
  $FutureProviderElement<Bundled> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Bundled> create(Ref ref) {
    return bundledModels(ref);
  }
}

String _$bundledModelsHash() => r'93e1c9ff54a5d1660833af9e08de78ad90a66a11';

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then refreshes from each backend's own list
/// (llm_dart's ModelListingCapability) in the background.

@ProviderFor(ModelCatalog)
final modelCatalogProvider = ModelCatalogProvider._();

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then refreshes from each backend's own list
/// (llm_dart's ModelListingCapability) in the background.
final class ModelCatalogProvider extends $AsyncNotifierProvider<ModelCatalog, List<ModelInfo>> {
  /// Every model the user can pick. Starts from the bundled list so the window
  /// never waits on the network, then refreshes from each backend's own list
  /// (llm_dart's ModelListingCapability) in the background.
  ModelCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelCatalogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelCatalogHash();

  @$internal
  @override
  ModelCatalog create() => ModelCatalog();
}

String _$modelCatalogHash() => r'347eb907bbd803c93a3602dd5dfe5065c40e8aae';

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then refreshes from each backend's own list
/// (llm_dart's ModelListingCapability) in the background.

abstract class _$ModelCatalog extends $AsyncNotifier<List<ModelInfo>> {
  FutureOr<List<ModelInfo>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<ModelInfo>>, List<ModelInfo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ModelInfo>>, List<ModelInfo>>,
              AsyncValue<List<ModelInfo>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
