// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Decision _$DecisionFromJson(Map<String, dynamic> json) =>
    _Decision(before: json['before'] as String, after: json['after'] as String, kept: json['kept'] as bool);

Map<String, dynamic> _$DecisionToJson(_Decision instance) => <String, dynamic>{
  'before': instance.before,
  'after': instance.after,
  'kept': instance.kept,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The word diff of the finished result, computed once per run. Null
/// while there is no finished result.

@ProviderFor(reviewDiff)
final reviewDiffProvider = ReviewDiffProvider._();

/// The word diff of the finished result, computed once per run. Null
/// while there is no finished result.

final class ReviewDiffProvider extends $FunctionalProvider<List<Diff>?, List<Diff>?, List<Diff>?>
    with $Provider<List<Diff>?> {
  /// The word diff of the finished result, computed once per run. Null
  /// while there is no finished result.
  ReviewDiffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewDiffProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewDiffHash();

  @$internal
  @override
  $ProviderElement<List<Diff>?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<Diff>? create(Ref ref) {
    return reviewDiff(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Diff>? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<Diff>?>(value));
  }
}

String _$reviewDiffHash() => r'7c6e597c8dcb094f3626f9f26ab7df034223e2de';

/// The single review of the finished result. The main view (n, p, y, x) and
/// the Vim editor (Tab) edit this same state, so there is one undo history
/// and one text to deliver. Rebuilt from scratch when a new run finishes.

@ProviderFor(Review)
final reviewProvider = ReviewProvider._();

/// The single review of the finished result. The main view (n, p, y, x) and
/// the Vim editor (Tab) edit this same state, so there is one undo history
/// and one text to deliver. Rebuilt from scratch when a new run finishes.
final class ReviewProvider extends $NotifierProvider<Review, SelectionEditorState?> {
  /// The single review of the finished result. The main view (n, p, y, x) and
  /// the Vim editor (Tab) edit this same state, so there is one undo history
  /// and one text to deliver. Rebuilt from scratch when a new run finishes.
  ReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewHash();

  @$internal
  @override
  Review create() => Review();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectionEditorState? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SelectionEditorState?>(value));
  }
}

String _$reviewHash() => r'a725605bb04dbe5222e33ac40303ea588ac63529';

/// The single review of the finished result. The main view (n, p, y, x) and
/// the Vim editor (Tab) edit this same state, so there is one undo history
/// and one text to deliver. Rebuilt from scratch when a new run finishes.

abstract class _$Review extends $Notifier<SelectionEditorState?> {
  SelectionEditorState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SelectionEditorState?, SelectionEditorState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectionEditorState?, SelectionEditorState?>,
              SelectionEditorState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
