// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_settings_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProviderSettingsState)
final providerSettingsStateProvider = ProviderSettingsStateProvider._();

final class ProviderSettingsStateProvider
    extends
        $AsyncNotifierProvider<
          ProviderSettingsState,
          Map<String, ProviderSettings>
        > {
  ProviderSettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providerSettingsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providerSettingsStateHash();

  @$internal
  @override
  ProviderSettingsState create() => ProviderSettingsState();
}

String _$providerSettingsStateHash() =>
    r'743987a2462f71a1ab13bb9f1345b2eef6ddd1e3';

abstract class _$ProviderSettingsState
    extends $AsyncNotifier<Map<String, ProviderSettings>> {
  FutureOr<Map<String, ProviderSettings>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Map<String, ProviderSettings>>,
              Map<String, ProviderSettings>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, ProviderSettings>>,
                Map<String, ProviderSettings>
              >,
              AsyncValue<Map<String, ProviderSettings>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(providerSettingsForProvider)
final providerSettingsForProviderProvider =
    ProviderSettingsForProviderFamily._();

final class ProviderSettingsForProviderProvider
    extends
        $FunctionalProvider<
          ProviderSettings,
          ProviderSettings,
          ProviderSettings
        >
    with $Provider<ProviderSettings> {
  ProviderSettingsForProviderProvider._({
    required ProviderSettingsForProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'providerSettingsForProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$providerSettingsForProviderHash();

  @override
  String toString() {
    return r'providerSettingsForProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ProviderSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProviderSettings create(Ref ref) {
    final argument = this.argument as String;
    return providerSettingsForProvider(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProviderSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProviderSettings>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProviderSettingsForProviderProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$providerSettingsForProviderHash() =>
    r'585b678c8ac7a5baebdee924a464271da0f611f5';

final class ProviderSettingsForProviderFamily extends $Family
    with $FunctionalFamilyOverride<ProviderSettings, String> {
  ProviderSettingsForProviderFamily._()
    : super(
        retry: null,
        name: r'providerSettingsForProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProviderSettingsForProviderProvider call(String providerName) =>
      ProviderSettingsForProviderProvider._(argument: providerName, from: this);

  @override
  String toString() => r'providerSettingsForProviderProvider';
}
