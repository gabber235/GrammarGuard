// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gateway.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(llmGateway)
final llmGatewayProvider = LlmGatewayProvider._();

final class LlmGatewayProvider extends $FunctionalProvider<LlmGateway, LlmGateway, LlmGateway>
    with $Provider<LlmGateway> {
  LlmGatewayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'llmGatewayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$llmGatewayHash();

  @$internal
  @override
  $ProviderElement<LlmGateway> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  LlmGateway create(Ref ref) {
    return llmGateway(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LlmGateway value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<LlmGateway>(value));
  }
}

String _$llmGatewayHash() => r'c264d2c5000e2e935e0ea4fd336dca70095fa8a3';
