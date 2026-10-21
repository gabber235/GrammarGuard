// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(desktopWindow)
final desktopWindowProvider = DesktopWindowProvider._();

final class DesktopWindowProvider extends $FunctionalProvider<DesktopWindow, DesktopWindow, DesktopWindow>
    with $Provider<DesktopWindow> {
  DesktopWindowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'desktopWindowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$desktopWindowHash();

  @$internal
  @override
  $ProviderElement<DesktopWindow> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  DesktopWindow create(Ref ref) {
    return desktopWindow(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DesktopWindow value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<DesktopWindow>(value));
  }
}

String _$desktopWindowHash() => r'58121b1cd6b1655373c1e5ca32898841bc00e088';

@ProviderFor(globalHotkey)
final globalHotkeyProvider = GlobalHotkeyProvider._();

final class GlobalHotkeyProvider extends $FunctionalProvider<GlobalHotkey, GlobalHotkey, GlobalHotkey>
    with $Provider<GlobalHotkey> {
  GlobalHotkeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'globalHotkeyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalHotkeyHash();

  @$internal
  @override
  $ProviderElement<GlobalHotkey> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  GlobalHotkey create(Ref ref) {
    return globalHotkey(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalHotkey value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<GlobalHotkey>(value));
  }
}

String _$globalHotkeyHash() => r'be83ece597d9762f1cde571fb1b591550418cf55';

@ProviderFor(textBridge)
final textBridgeProvider = TextBridgeProvider._();

final class TextBridgeProvider extends $FunctionalProvider<TextBridge, TextBridge, TextBridge>
    with $Provider<TextBridge> {
  TextBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textBridgeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$textBridgeHash();

  @$internal
  @override
  $ProviderElement<TextBridge> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  TextBridge create(Ref ref) {
    return textBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TextBridge value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<TextBridge>(value));
  }
}

String _$textBridgeHash() => r'74c87f647e353a13b055145f530e0417b360e5cc';

@ProviderFor(preferences)
final preferencesProvider = PreferencesProvider._();

final class PreferencesProvider
    extends $FunctionalProvider<AsyncValue<SharedPreferences>, SharedPreferences, FutureOr<SharedPreferences>>
    with $FutureModifier<SharedPreferences>, $FutureProvider<SharedPreferences> {
  PreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return preferences(ref);
  }
}

String _$preferencesHash() => r'57e1ba25534b21d2e407640edea4d4f8a0c9f05b';

/// A text file bundled with the app (assets/...). Read as bytes and decoded
/// here, uncached: loadString hands large files to an isolate and caches a
/// future that outlives the zone that created it, which breaks widget tests.

@ProviderFor(bundledAsset)
final bundledAssetProvider = BundledAssetFamily._();

/// A text file bundled with the app (assets/...). Read as bytes and decoded
/// here, uncached: loadString hands large files to an isolate and caches a
/// future that outlives the zone that created it, which breaks widget tests.

final class BundledAssetProvider extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// A text file bundled with the app (assets/...). Read as bytes and decoded
  /// here, uncached: loadString hands large files to an isolate and caches a
  /// future that outlives the zone that created it, which breaks widget tests.
  BundledAssetProvider._({required BundledAssetFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'bundledAssetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bundledAssetHash();

  @override
  String toString() {
    return r'bundledAssetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return bundledAsset(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BundledAssetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bundledAssetHash() => r'8f5c02fd4635310e738ebda3611fa94b68ada99a';

/// A text file bundled with the app (assets/...). Read as bytes and decoded
/// here, uncached: loadString hands large files to an isolate and caches a
/// future that outlives the zone that created it, which breaks widget tests.

final class BundledAssetFamily extends $Family with $FunctionalFamilyOverride<FutureOr<String>, String> {
  BundledAssetFamily._()
    : super(
        retry: null,
        name: r'bundledAssetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// A text file bundled with the app (assets/...). Read as bytes and decoded
  /// here, uncached: loadString hands large files to an isolate and caches a
  /// future that outlives the zone that created it, which breaks widget tests.

  BundledAssetProvider call(String key) => BundledAssetProvider._(argument: key, from: this);

  @override
  String toString() => r'bundledAssetProvider';
}

/// Every file GrammarGuard reads or writes goes through this, so tests can
/// use an in-memory file system instead of the disk.

@ProviderFor(fileSystem)
final fileSystemProvider = FileSystemProvider._();

/// Every file GrammarGuard reads or writes goes through this, so tests can
/// use an in-memory file system instead of the disk.

final class FileSystemProvider extends $FunctionalProvider<FileSystem, FileSystem, FileSystem>
    with $Provider<FileSystem> {
  /// Every file GrammarGuard reads or writes goes through this, so tests can
  /// use an in-memory file system instead of the disk.
  FileSystemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileSystemProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileSystemHash();

  @$internal
  @override
  $ProviderElement<FileSystem> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  FileSystem create(Ref ref) {
    return fileSystem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileSystem value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<FileSystem>(value));
  }
}

String _$fileSystemHash() => r'9b96bb59d396159330bbfc15f1c8ea184af0a9b7';

/// Holds library.yaml, its history and history.jsonl.

@ProviderFor(appSupportDir)
final appSupportDirProvider = AppSupportDirProvider._();

/// Holds library.yaml, its history and history.jsonl.

final class AppSupportDirProvider extends $FunctionalProvider<AsyncValue<Directory>, Directory, FutureOr<Directory>>
    with $FutureModifier<Directory>, $FutureProvider<Directory> {
  /// Holds library.yaml, its history and history.jsonl.
  AppSupportDirProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSupportDirProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSupportDirHash();

  @$internal
  @override
  $FutureProviderElement<Directory> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Directory> create(Ref ref) {
    return appSupportDir(ref);
  }
}

String _$appSupportDirHash() => r'084f64f38f4c476591bd3e9d4b4dd953d68aae87';

/// Shared HTTP client for model lists. Tests give it an offline adapter.

@ProviderFor(http)
final httpProvider = HttpProvider._();

/// Shared HTTP client for model lists. Tests give it an offline adapter.

final class HttpProvider extends $FunctionalProvider<Dio, Dio, Dio> with $Provider<Dio> {
  /// Shared HTTP client for model lists. Tests give it an offline adapter.
  HttpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return http(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Dio>(value));
  }
}

String _$httpHash() => r'af56fc72b8247b2cff4b3363ddfe8d469bca0e13';

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends $FunctionalProvider<FlutterSecureStorage, FlutterSecureStorage, FlutterSecureStorage>
    with $Provider<FlutterSecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<FlutterSecureStorage>(value));
  }
}

String _$secureStorageHash() => r'05c700e9ff3a470ca99a092fb442709c08e0d332';
