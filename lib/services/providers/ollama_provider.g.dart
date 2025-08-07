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
}

String _$ollamaConfigurationHash() =>
    r'4fdd3365deeb69d0fb6240e8eefa54b285d2a5b1';

abstract class _$OllamaConfiguration extends $AsyncNotifier<OllamaConfig> {
  FutureOr<OllamaConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<OllamaConfig>, OllamaConfig>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<OllamaConfig>, OllamaConfig>,
        AsyncValue<OllamaConfig>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
