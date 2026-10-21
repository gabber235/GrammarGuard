// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connections.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Saved connection settings. Keys live in secure storage, everything else
/// in preferences as JSON. Replaces api_key_state.dart,
/// provider_settings_state.dart and the Ollama query string config (B1).

@ProviderFor(Connections)
final connectionsProvider = ConnectionsProvider._();

/// Saved connection settings. Keys live in secure storage, everything else
/// in preferences as JSON. Replaces api_key_state.dart,
/// provider_settings_state.dart and the Ollama query string config (B1).
final class ConnectionsProvider extends $AsyncNotifierProvider<Connections, Map<Backend, Connection>> {
  /// Saved connection settings. Keys live in secure storage, everything else
  /// in preferences as JSON. Replaces api_key_state.dart,
  /// provider_settings_state.dart and the Ollama query string config (B1).
  ConnectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionsHash();

  @$internal
  @override
  Connections create() => Connections();
}

String _$connectionsHash() => r'd4be79a852d57c4ed3f6512fa7500641b2c2164d';

/// Saved connection settings. Keys live in secure storage, everything else
/// in preferences as JSON. Replaces api_key_state.dart,
/// provider_settings_state.dart and the Ollama query string config (B1).

abstract class _$Connections extends $AsyncNotifier<Map<Backend, Connection>> {
  FutureOr<Map<Backend, Connection>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Map<Backend, Connection>>, Map<Backend, Connection>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<Backend, Connection>>, Map<Backend, Connection>>,
              AsyncValue<Map<Backend, Connection>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
