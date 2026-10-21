// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assistant.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Assistant)
final assistantProvider = AssistantProvider._();

final class AssistantProvider extends $NotifierProvider<Assistant, AssistantState> {
  AssistantProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assistantProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assistantHash();

  @$internal
  @override
  Assistant create() => Assistant();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssistantState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AssistantState>(value));
  }
}

String _$assistantHash() => r'd7c676c32d170d3236a584b41ca04ced6b4fd26d';

abstract class _$Assistant extends $Notifier<AssistantState> {
  AssistantState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AssistantState, AssistantState>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AssistantState, AssistantState>, AssistantState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
