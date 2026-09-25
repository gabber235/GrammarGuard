// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diff_option.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DiffOption)
final diffOptionProvider = DiffOptionProvider._();

final class DiffOptionProvider
    extends $NotifierProvider<DiffOption, DiffOptions> {
  DiffOptionProvider._()
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiffOptions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiffOptions>(value),
    );
  }
}

String _$diffOptionHash() => r'e945954d3e2f01b5bb5305b117c393bcac6812ef';

abstract class _$DiffOption extends $Notifier<DiffOptions> {
  DiffOptions build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DiffOptions, DiffOptions>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DiffOptions, DiffOptions>,
              DiffOptions,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
