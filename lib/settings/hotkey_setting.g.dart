// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey_setting.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HotkeySetting)
final hotkeySettingProvider = HotkeySettingProvider._();

final class HotkeySettingProvider extends $AsyncNotifierProvider<HotkeySetting, HotKey> {
  HotkeySettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotkeySettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotkeySettingHash();

  @$internal
  @override
  HotkeySetting create() => HotkeySetting();
}

String _$hotkeySettingHash() => r'b8bf89ce6933956b0d872dc38a2736b8e4a6d02d';

abstract class _$HotkeySetting extends $AsyncNotifier<HotKey> {
  FutureOr<HotKey> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HotKey>, HotKey>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AsyncValue<HotKey>, HotKey>, AsyncValue<HotKey>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// How many rewrites stay on this computer; zero keeps none. Stored once
/// here, and an older "off" switch still counts.

@ProviderFor(HistoryLimit)
final historyLimitProvider = HistoryLimitProvider._();

/// How many rewrites stay on this computer; zero keeps none. Stored once
/// here, and an older "off" switch still counts.
final class HistoryLimitProvider extends $AsyncNotifierProvider<HistoryLimit, int> {
  /// How many rewrites stay on this computer; zero keeps none. Stored once
  /// here, and an older "off" switch still counts.
  HistoryLimitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyLimitProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyLimitHash();

  @$internal
  @override
  HistoryLimit create() => HistoryLimit();
}

String _$historyLimitHash() => r'f9d740c9a631af225f7650e4b92f6d3114da69bb';

/// How many rewrites stay on this computer; zero keeps none. Stored once
/// here, and an older "off" switch still counts.

abstract class _$HistoryLimit extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// The size of the review text, in logical pixels. Large by default for
/// easy reading; Settings, General moves it between [min] and [max].

@ProviderFor(ReadingSize)
final readingSizeProvider = ReadingSizeProvider._();

/// The size of the review text, in logical pixels. Large by default for
/// easy reading; Settings, General moves it between [min] and [max].
final class ReadingSizeProvider extends $AsyncNotifierProvider<ReadingSize, double> {
  /// The size of the review text, in logical pixels. Large by default for
  /// easy reading; Settings, General moves it between [min] and [max].
  ReadingSizeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingSizeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingSizeHash();

  @$internal
  @override
  ReadingSize create() => ReadingSize();
}

String _$readingSizeHash() => r'9a5afe53fc73d47513f4da586a7ac7aab5a4e87c';

/// The size of the review text, in logical pixels. Large by default for
/// easy reading; Settings, General moves it between [min] and [max].

abstract class _$ReadingSize extends $AsyncNotifier<double> {
  FutureOr<double> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<double>, double>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AsyncValue<double>, double>, AsyncValue<double>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
