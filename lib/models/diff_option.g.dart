// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diff_option.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DiffOption)
const diffOptionProvider = DiffOptionProvider._();

final class DiffOptionProvider
    extends $NotifierProvider<DiffOption, DiffOptions> {
  const DiffOptionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diffOptionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diffOptionHash();

  @$internal
  @override
  DiffOption create() => DiffOption();

  @$internal
  @override
  $NotifierProviderElement<DiffOption, DiffOptions> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiffOptions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<DiffOptions>(value),
    );
  }
}

String _$diffOptionHash() => r'e945954d3e2f01b5bb5305b117c393bcac6812ef';

abstract class _$DiffOption extends $Notifier<DiffOptions> {
  DiffOptions build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<DiffOptions>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<DiffOptions>, DiffOptions, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
