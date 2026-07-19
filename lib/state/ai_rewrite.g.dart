// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_rewrite.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RewriteGenerationActivity)
final rewriteGenerationActivityProvider = RewriteGenerationActivityProvider._();

final class RewriteGenerationActivityProvider
    extends $NotifierProvider<RewriteGenerationActivity, bool> {
  RewriteGenerationActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewriteGenerationActivityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewriteGenerationActivityHash();

  @$internal
  @override
  RewriteGenerationActivity create() => RewriteGenerationActivity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$rewriteGenerationActivityHash() =>
    r'89241cf10766ae84c1766e6f1b4a7ae52be4c472';

abstract class _$RewriteGenerationActivity extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedModel)
final selectedModelProvider = SelectedModelProvider._();

final class SelectedModelProvider
    extends $AsyncNotifierProvider<SelectedModel, AiModel?> {
  SelectedModelProvider._()
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
}

String _$selectedModelHash() => r'7bbc7414c7553d540d4214d78a45fa8d7259a274';

abstract class _$SelectedModel extends $AsyncNotifier<AiModel?> {
  FutureOr<AiModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AiModel?>, AiModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiModel?>, AiModel?>,
              AsyncValue<AiModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AiRewrite)
final aiRewriteProvider = AiRewriteProvider._();

final class AiRewriteProvider
    extends $StreamNotifierProvider<AiRewrite, AiRewriteResult> {
  AiRewriteProvider._()
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
}

String _$aiRewriteHash() => r'b99766bd094ba46b8c53cb6f6055e93502e5579a';

abstract class _$AiRewrite extends $StreamNotifier<AiRewriteResult> {
  Stream<AiRewriteResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AiRewriteResult>, AiRewriteResult>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AiRewriteResult>, AiRewriteResult>,
              AsyncValue<AiRewriteResult>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(diffs)
final diffsProvider = DiffsProvider._();

final class DiffsProvider
    extends $FunctionalProvider<List<Diff>, List<Diff>, List<Diff>>
    with $Provider<List<Diff>> {
  DiffsProvider._()
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
      providerOverride: $SyncValueProvider<List<Diff>>(value),
    );
  }
}

String _$diffsHash() => r'730d4ce5b3b2b61a515cc40be6850bdf15073b6b';

@ProviderFor(leftPanelDiffs)
final leftPanelDiffsProvider = LeftPanelDiffsProvider._();

final class LeftPanelDiffsProvider
    extends $FunctionalProvider<List<Diff>, List<Diff>, List<Diff>>
    with $Provider<List<Diff>> {
  LeftPanelDiffsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leftPanelDiffsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leftPanelDiffsHash();

  @$internal
  @override
  $ProviderElement<List<Diff>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Diff> create(Ref ref) {
    return leftPanelDiffs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Diff> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Diff>>(value),
    );
  }
}

String _$leftPanelDiffsHash() => r'107c15806ba1ca529dd1762b0b3e1922de212b85';

@ProviderFor(rightPanelDiffs)
final rightPanelDiffsProvider = RightPanelDiffsProvider._();

final class RightPanelDiffsProvider
    extends $FunctionalProvider<List<Diff>, List<Diff>, List<Diff>>
    with $Provider<List<Diff>> {
  RightPanelDiffsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rightPanelDiffsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rightPanelDiffsHash();

  @$internal
  @override
  $ProviderElement<List<Diff>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Diff> create(Ref ref) {
    return rightPanelDiffs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Diff> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Diff>>(value),
    );
  }
}

String _$rightPanelDiffsHash() => r'6372c31b0770bb2c6d54abbbae7a6d98cafef634';

@ProviderFor(diffString)
final diffStringProvider = DiffStringProvider._();

final class DiffStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DiffStringProvider._()
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
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$diffStringHash() => r'dfaa5c3266fcac0b6f97772b749c24ac76457acd';

@ProviderFor(leftPanelDiffString)
final leftPanelDiffStringProvider = LeftPanelDiffStringProvider._();

final class LeftPanelDiffStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  LeftPanelDiffStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leftPanelDiffStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leftPanelDiffStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return leftPanelDiffString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$leftPanelDiffStringHash() =>
    r'd281603c28a7007d6fb1a0e6a62714fc2bb1a7ce';

@ProviderFor(rightPanelDiffString)
final rightPanelDiffStringProvider = RightPanelDiffStringProvider._();

final class RightPanelDiffStringProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  RightPanelDiffStringProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rightPanelDiffStringProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rightPanelDiffStringHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return rightPanelDiffString(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$rightPanelDiffStringHash() =>
    r'3af1f67aec04f1239d94cb74806e2b3b02aa6fb1';
