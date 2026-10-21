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

/// ? toggles the reason under the current change.

@ProviderFor(ShowReason)
final showReasonProvider = ShowReasonProvider._();

/// ? toggles the reason under the current change.
final class ShowReasonProvider extends $NotifierProvider<ShowReason, bool> {
  /// ? toggles the reason under the current change.
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

/// ? toggles the reason under the current change.

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
