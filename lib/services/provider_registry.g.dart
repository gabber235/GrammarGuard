// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_registry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ProviderRegistry)
const providerRegistryProvider = ProviderRegistryProvider._();

final class ProviderRegistryProvider
    extends $NotifierProvider<ProviderRegistry, List<AiProvider>> {
  const ProviderRegistryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'providerRegistryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$providerRegistryHash();

  @$internal
  @override
  ProviderRegistry create() => ProviderRegistry();

  @$internal
  @override
  $NotifierProviderElement<ProviderRegistry, List<AiProvider>> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AiProvider> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<AiProvider>>(value),
    );
  }
}

String _$providerRegistryHash() => r'df642d03f027eab30cdb69a6448bfc6d29e51c4e';

abstract class _$ProviderRegistry extends $Notifier<List<AiProvider>> {
  List<AiProvider> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<AiProvider>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<AiProvider>>, List<AiProvider>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(provider)
const providerProvider = ProviderFamily._();

final class ProviderProvider
    extends $FunctionalProvider<AiProvider?, AiProvider?>
    with $Provider<AiProvider?> {
  const ProviderProvider._(
      {required ProviderFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'providerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$providerHash();

  @override
  String toString() {
    return r'providerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AiProvider?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AiProvider? create(Ref ref) {
    final argument = this.argument as String;
    return provider(
      ref,
      argument,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AiProvider? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<AiProvider?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$providerHash() => r'5cf3b356ca14cbd792106be8ad5b683cdde5a549';

final class ProviderFamily extends $Family
    with $FunctionalFamilyOverride<AiProvider?, String> {
  const ProviderFamily._()
      : super(
          retry: null,
          name: r'providerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  ProviderProvider call(
    String name,
  ) =>
      ProviderProvider._(argument: name, from: this);

  @override
  String toString() => r'providerProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
