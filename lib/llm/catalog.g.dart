// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The latest check per backend, written by [ModelCatalog], which asks each
/// service anyway. No entry means no check ran, such as for Apple's model.

@ProviderFor(ConnectionChecks)
final connectionChecksProvider = ConnectionChecksProvider._();

/// The latest check per backend, written by [ModelCatalog], which asks each
/// service anyway. No entry means no check ran, such as for Apple's model.
final class ConnectionChecksProvider extends $NotifierProvider<ConnectionChecks, Map<Backend, ConnectionCheck>> {
  /// The latest check per backend, written by [ModelCatalog], which asks each
  /// service anyway. No entry means no check ran, such as for Apple's model.
  ConnectionChecksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionChecksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionChecksHash();

  @$internal
  @override
  ConnectionChecks create() => ConnectionChecks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<Backend, ConnectionCheck> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Map<Backend, ConnectionCheck>>(value));
  }
}

String _$connectionChecksHash() => r'c26c74c208cf6d77f8cfc8ddc9df6ba55c6423cf';

/// The latest check per backend, written by [ModelCatalog], which asks each
/// service anyway. No entry means no check ran, such as for Apple's model.

abstract class _$ConnectionChecks extends $Notifier<Map<Backend, ConnectionCheck>> {
  Map<Backend, ConnectionCheck> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<Backend, ConnectionCheck>, Map<Backend, ConnectionCheck>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<Backend, ConnectionCheck>, Map<Backend, ConnectionCheck>>,
              Map<Backend, ConnectionCheck>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

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
/// never waits on the network, then lists each backend's own models
/// (llm_dart's ModelListingCapability) in the background: after a connection
/// changes, and on every [refresh].

@ProviderFor(ModelCatalog)
final modelCatalogProvider = ModelCatalogProvider._();

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then lists each backend's own models
/// (llm_dart's ModelListingCapability) in the background: after a connection
/// changes, and on every [refresh].
final class ModelCatalogProvider extends $AsyncNotifierProvider<ModelCatalog, List<ModelInfo>> {
  /// Every model the user can pick. Starts from the bundled list so the window
  /// never waits on the network, then lists each backend's own models
  /// (llm_dart's ModelListingCapability) in the background: after a connection
  /// changes, and on every [refresh].
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

String _$modelCatalogHash() => r'c482aa3a3a8b6991288c0ff7a44ab140a733222b';

/// Every model the user can pick. Starts from the bundled list so the window
/// never waits on the network, then lists each backend's own models
/// (llm_dart's ModelListingCapability) in the background: after a connection
/// changes, and on every [refresh].

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
