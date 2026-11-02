// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey_binding.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Registers the user's shortcuts and re-registers when one changes in
/// Settings. The rewrite shortcut's status decides popup or normal window.

@ProviderFor(HotkeyBinding)
final hotkeyBindingProvider = HotkeyBindingProvider._();

/// Registers the user's shortcuts and re-registers when one changes in
/// Settings. The rewrite shortcut's status decides popup or normal window.
final class HotkeyBindingProvider extends $AsyncNotifierProvider<HotkeyBinding, Map<HotkeyPurpose, HotkeyStatus>> {
  /// Registers the user's shortcuts and re-registers when one changes in
  /// Settings. The rewrite shortcut's status decides popup or normal window.
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

String _$hotkeyBindingHash() => r'c30b97c8230534d2507a587216b80d2b91884932';

/// Registers the user's shortcuts and re-registers when one changes in
/// Settings. The rewrite shortcut's status decides popup or normal window.

abstract class _$HotkeyBinding extends $AsyncNotifier<Map<HotkeyPurpose, HotkeyStatus>> {
  FutureOr<Map<HotkeyPurpose, HotkeyStatus>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Map<HotkeyPurpose, HotkeyStatus>>, Map<HotkeyPurpose, HotkeyStatus>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<HotkeyPurpose, HotkeyStatus>>, Map<HotkeyPurpose, HotkeyStatus>>,
              AsyncValue<Map<HotkeyPurpose, HotkeyStatus>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
