// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// V toggles the rendered preview of the final text.

@ProviderFor(Preview)
final previewProvider = PreviewProvider._();

/// V toggles the rendered preview of the final text.
final class PreviewProvider extends $NotifierProvider<Preview, bool> {
  /// V toggles the rendered preview of the final text.
  PreviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'previewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$previewHash();

  @$internal
  @override
  Preview create() => Preview();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$previewHash() => r'2a06342dec6ed411dcd64b9e3ec3a2b51a266e2f';

/// V toggles the rendered preview of the final text.

abstract class _$Preview extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// W toggles the reason under the current change.

@ProviderFor(ShowReason)
final showReasonProvider = ShowReasonProvider._();

/// W toggles the reason under the current change.
final class ShowReasonProvider extends $NotifierProvider<ShowReason, bool> {
  /// W toggles the reason under the current change.
  ShowReasonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showReasonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showReasonHash();

  @$internal
  @override
  ShowReason create() => ShowReason();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$showReasonHash() => r'4601997bc8ba8214ecd72e8e82f3ebe8af6ada17';

/// W toggles the reason under the current change.

abstract class _$ShowReason extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// H switches the review between inline and side by side.

@ProviderFor(ReviewLayout)
final reviewLayoutProvider = ReviewLayoutProvider._();

/// H switches the review between inline and side by side.
final class ReviewLayoutProvider extends $NotifierProvider<ReviewLayout, DiffView> {
  /// H switches the review between inline and side by side.
  ReviewLayoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewLayoutProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewLayoutHash();

  @$internal
  @override
  ReviewLayout create() => ReviewLayout();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiffView value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DiffView>(value));
  }
}

String _$reviewLayoutHash() => r'5a650793f86b73487ccdf5fc59bb6736a1240617';

/// H switches the review between inline and side by side.

abstract class _$ReviewLayout extends $Notifier<DiffView> {
  DiffView build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DiffView, DiffView>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<DiffView, DiffView>, DiffView, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// The inline review's scroll position, moved by J, K and D.

@ProviderFor(reviewScroll)
final reviewScrollProvider = ReviewScrollProvider._();

/// The inline review's scroll position, moved by J, K and D.

final class ReviewScrollProvider extends $FunctionalProvider<ScrollController, ScrollController, ScrollController>
    with $Provider<ScrollController> {
  /// The inline review's scroll position, moved by J, K and D.
  ReviewScrollProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewScrollProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewScrollHash();

  @$internal
  @override
  $ProviderElement<ScrollController> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ScrollController create(Ref ref) {
    return reviewScroll(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScrollController value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ScrollController>(value));
  }
}

String _$reviewScrollHash() => r'bbf55e3fb07dd4234f1a7707250e546aa5afb068';
