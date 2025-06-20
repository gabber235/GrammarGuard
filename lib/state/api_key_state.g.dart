// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ApiKeyState)
const apiKeyStateProvider = ApiKeyStateProvider._();

final class ApiKeyStateProvider
    extends $AsyncNotifierProvider<ApiKeyState, Map<String, String>> {
  const ApiKeyStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'apiKeyStateProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$apiKeyStateHash();

  @$internal
  @override
  ApiKeyState create() => ApiKeyState();

  @$internal
  @override
  $AsyncNotifierProviderElement<ApiKeyState, Map<String, String>>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$apiKeyStateHash() => r'3801047f9ce96a48dd9e4148f0ded3e4c9f1cfd9';

abstract class _$ApiKeyState extends $AsyncNotifier<Map<String, String>> {
  FutureOr<Map<String, String>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Map<String, String>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, String>>>,
        AsyncValue<Map<String, String>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(apiKey)
const apiKeyProvider = ApiKeyFamily._();

final class ApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  const ApiKeyProvider._(
      {required ApiKeyFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'apiKeyProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$apiKeyHash();

  @override
  String toString() {
    return r'apiKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return apiKey(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ApiKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiKeyHash() => r'6200d5341cd77a61c62b14f6821aab359d2057a6';

final class ApiKeyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  const ApiKeyFamily._()
      : super(
          retry: null,
          name: r'apiKeyProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: false,
        );

  ApiKeyProvider call(
    String providerName,
  ) =>
      ApiKeyProvider._(argument: providerName, from: this);

  @override
  String toString() => r'apiKeyProvider';
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
