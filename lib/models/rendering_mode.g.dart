// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RenderingMode)
final renderingModeProvider = RenderingModeProvider._();

final class RenderingModeProvider
    extends $NotifierProvider<RenderingMode, RenderingModeOption> {
  RenderingModeProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'renderingModeProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$renderingModeHash();

  @$internal
  @override
  RenderingMode create() => RenderingMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RenderingModeOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RenderingModeOption>(value),
    );
  }
}

String _$renderingModeHash() => r'ab997e630ba0d0484d9fb37eb2a928b5cafb849e';

abstract class _$RenderingMode extends $Notifier<RenderingModeOption> {
  RenderingModeOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RenderingModeOption, RenderingModeOption>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RenderingModeOption, RenderingModeOption>,
        RenderingModeOption,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
