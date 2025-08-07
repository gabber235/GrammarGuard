// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rendering_mode.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(RenderingMode)
const renderingModeProvider = RenderingModeProvider._();

final class RenderingModeProvider
    extends $NotifierProvider<RenderingMode, RenderingModeOption> {
  const RenderingModeProvider._()
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
    final created = build();
    final ref = this.ref as $Ref<RenderingModeOption, RenderingModeOption>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RenderingModeOption, RenderingModeOption>,
        RenderingModeOption,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
