// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_rewrite.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SelectedModel)
const selectedModelProvider = SelectedModelProvider._();

final class SelectedModelProvider
    extends $AsyncNotifierProvider<SelectedModel, AiModel?> {
  const SelectedModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedModelHash();

  @$internal
  @override
  SelectedModel create() => SelectedModel();

  @$internal
  @override
  $AsyncNotifierProviderElement<SelectedModel, AiModel?> $createElement(
          $ProviderPointer pointer) =>
      $AsyncNotifierProviderElement(pointer);
}

String _$selectedModelHash() => r'4cb27e08f2d4bef5ec4051e372223cdc407cba8b';

abstract class _$SelectedModel extends $AsyncNotifier<AiModel?> {
  FutureOr<AiModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AiModel?>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AiModel?>>,
        AsyncValue<AiModel?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(AiRewrite)
const aiRewriteProvider = AiRewriteProvider._();

final class AiRewriteProvider
    extends $StreamNotifierProvider<AiRewrite, AiRewriteResult> {
  const AiRewriteProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiRewriteProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiRewriteHash();

  @$internal
  @override
  AiRewrite create() => AiRewrite();

  @$internal
  @override
  $StreamNotifierProviderElement<AiRewrite, AiRewriteResult> $createElement(
          $ProviderPointer pointer) =>
      $StreamNotifierProviderElement(pointer);
}

String _$aiRewriteHash() => r'16acf055e9e02f816bd5982c49ad3fb515c43e94';

abstract class _$AiRewrite extends $StreamNotifier<AiRewriteResult> {
  Stream<AiRewriteResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AiRewriteResult>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AiRewriteResult>>,
        AsyncValue<AiRewriteResult>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(diffs)
const diffsProvider = DiffsProvider._();

final class DiffsProvider extends $FunctionalProvider<List<Diff>, List<Diff>>
    with $Provider<List<Diff>> {
  const DiffsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diffsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diffsHash();

  @$internal
  @override
  $ProviderElement<List<Diff>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Diff> create(Ref ref) {
    return diffs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Diff> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<List<Diff>>(value),
    );
  }
}

String _$diffsHash() => r'616348107892e74f8228db5cf0325903ab1f6c12';

@ProviderFor(diffString)
const diffStringProvider = DiffStringProvider._();

final class DiffStringProvider extends $FunctionalProvider<String, String>
    with $Provider<String> {
  const DiffStringProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'diffStringProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$diffStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return diffString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<String>(value),
    );
  }
}

String _$diffStringHash() => r'dfaa5c3266fcac0b6f97772b749c24ac76457acd';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
