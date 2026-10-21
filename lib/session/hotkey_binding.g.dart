// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey_binding.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Registers the user's shortcut and re-registers when it changes in
/// Settings. Its status decides popup or normal window.

@ProviderFor(HotkeyBinding)
final hotkeyBindingProvider = HotkeyBindingProvider._();

/// Registers the user's shortcut and re-registers when it changes in
/// Settings. Its status decides popup or normal window.
final class HotkeyBindingProvider extends $AsyncNotifierProvider<HotkeyBinding, HotkeyStatus> {
  /// Registers the user's shortcut and re-registers when it changes in
  /// Settings. Its status decides popup or normal window.
  HotkeyBindingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotkeyBindingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotkeyBindingHash();

  @$internal
  @override
  HotkeyBinding create() => HotkeyBinding();
}

String _$hotkeyBindingHash() => r'f22123e40f0d32fc7b538b6d69e561f32fade819';

/// Registers the user's shortcut and re-registers when it changes in
/// Settings. Its status decides popup or normal window.

abstract class _$HotkeyBinding extends $AsyncNotifier<HotkeyStatus> {
  FutureOr<HotkeyStatus> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HotkeyStatus>, HotkeyStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HotkeyStatus>, HotkeyStatus>,
              AsyncValue<HotkeyStatus>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
