// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammar_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(GrammarState)
const grammarStateProvider = GrammarStateProvider._();

final class GrammarStateProvider
    extends $NotifierProvider<GrammarState, GrammarStateData> {
  const GrammarStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'grammarStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$grammarStateHash();

  @$internal
  @override
  GrammarState create() => GrammarState();

  @$internal
  @override
  $NotifierProviderElement<GrammarState, GrammarStateData> $createElement(
          $ProviderPointer pointer) =>
      $NotifierProviderElement(pointer);

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GrammarStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<GrammarStateData>(value),
    );
  }
}

String _$grammarStateHash() => r'2739869768a5e5d8e8d41f8e6bed0174fb2f2113';

abstract class _$GrammarState extends $Notifier<GrammarStateData> {
  GrammarStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<GrammarStateData>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<GrammarStateData>, GrammarStateData, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
