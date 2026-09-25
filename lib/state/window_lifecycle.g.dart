// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'window_lifecycle.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WindowLifecycle)
final windowLifecycleProvider = WindowLifecycleProvider._();

final class WindowLifecycleProvider
    extends $NotifierProvider<WindowLifecycle, WindowLifecycleState> {
  WindowLifecycleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowLifecycleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowLifecycleHash();

  @$internal
  @override
  WindowLifecycle create() => WindowLifecycle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowLifecycleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowLifecycleState>(value),
    );
  }
}

String _$windowLifecycleHash() => r'3dc4f25ccfa46b60eacb281a18247f4e2465157d';

abstract class _$WindowLifecycle extends $Notifier<WindowLifecycleState> {
  WindowLifecycleState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<WindowLifecycleState, WindowLifecycleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WindowLifecycleState, WindowLifecycleState>,
              WindowLifecycleState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(windowLifecyclePolicy)
final windowLifecyclePolicyProvider = WindowLifecyclePolicyProvider._();

final class WindowLifecyclePolicyProvider
    extends
        $FunctionalProvider<
          WindowLifecyclePolicy,
          WindowLifecyclePolicy,
          WindowLifecyclePolicy
        >
    with $Provider<WindowLifecyclePolicy> {
  WindowLifecyclePolicyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'windowLifecyclePolicyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$windowLifecyclePolicyHash();

  @$internal
  @override
  $ProviderElement<WindowLifecyclePolicy> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WindowLifecyclePolicy create(Ref ref) {
    return windowLifecyclePolicy(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WindowLifecyclePolicy value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WindowLifecyclePolicy>(value),
    );
  }
}

String _$windowLifecyclePolicyHash() =>
    r'71c3e0e4be360239cb1b754cf64d857dedd0eaf1';
