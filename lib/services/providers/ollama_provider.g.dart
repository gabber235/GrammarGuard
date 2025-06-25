// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ollama_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(OllamaConfiguration)
const ollamaConfigurationProvider = OllamaConfigurationProvider._();

final class OllamaConfigurationProvider
    extends $AsyncNotifierProvider<OllamaConfiguration, OllamaConfig> {
  const OllamaConfigurationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'ollamaConfigurationProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ollamaConfigurationHash();

  @$internal
  @override
  OllamaConfiguration create() => OllamaConfiguration();

  @$internal
  @override
  $AsyncNotifierProviderElement<OllamaConfiguration, OllamaConfig>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$ollamaConfigurationHash() =>
    r'914f5dbf0a08e8d123f4c4d12e3da61439e0fb33';

abstract class _$OllamaConfiguration extends $AsyncNotifier<OllamaConfig> {
  FutureOr<OllamaConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<OllamaConfig>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<OllamaConfig>>,
        AsyncValue<OllamaConfig>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
