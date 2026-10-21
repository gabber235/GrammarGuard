// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tray.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Menu bar icon on macOS, tray icon on Windows and Linux: the app's only
/// visible presence while the popup is hidden.

@ProviderFor(tray)
final trayProvider = TrayProvider._();

/// Menu bar icon on macOS, tray icon on Windows and Linux: the app's only
/// visible presence while the popup is hidden.

final class TrayProvider extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Menu bar icon on macOS, tray icon on Windows and Linux: the app's only
  /// visible presence while the popup is hidden.
  TrayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trayHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return tray(ref);
  }
}

String _$trayHash() => r'7cf72223381bfdaa5549bd19a83169989c1ed252';
