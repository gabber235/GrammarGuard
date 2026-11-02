// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_tips.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One quiet tip per rewrite, for a key not used yet. Tips take turns, so a
/// key someone ignores does not stay in the footer forever.

@ProviderFor(KeyTips)
final keyTipsProvider = KeyTipsProvider._();

/// One quiet tip per rewrite, for a key not used yet. Tips take turns, so a
/// key someone ignores does not stay in the footer forever.
final class KeyTipsProvider extends $AsyncNotifierProvider<KeyTips, KeyTipState> {
  /// One quiet tip per rewrite, for a key not used yet. Tips take turns, so a
  /// key someone ignores does not stay in the footer forever.
  KeyTipsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keyTipsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keyTipsHash();

  @$internal
  @override
  KeyTips create() => KeyTips();
}

String _$keyTipsHash() => r'69766550b2d44e8420aec3989c363896d84ca90b';

/// One quiet tip per rewrite, for a key not used yet. Tips take turns, so a
/// key someone ignores does not stay in the footer forever.

abstract class _$KeyTips extends $AsyncNotifier<KeyTipState> {
  FutureOr<KeyTipState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<KeyTipState>, KeyTipState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<KeyTipState>, KeyTipState>,
              AsyncValue<KeyTipState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
