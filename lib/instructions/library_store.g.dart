// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeLogEntry _$ChangeLogEntryFromJson(Map<String, dynamic> json) => _ChangeLogEntry(
  at: DateTime.parse(json['at'] as String),
  author: $enumDecode(_$ChangeAuthorEnumMap, json['author']),
  summary: (json['summary'] as List<dynamic>).map((e) => e as String).toList(),
  snapshot: json['snapshot'] as String,
);

Map<String, dynamic> _$ChangeLogEntryToJson(_ChangeLogEntry instance) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'author': _$ChangeAuthorEnumMap[instance.author]!,
  'summary': instance.summary,
  'snapshot': instance.snapshot,
};

const _$ChangeAuthorEnumMap = {ChangeAuthor.you: 'you', ChangeAuthor.assistant: 'assistant'};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryFile)
final libraryFileProvider = LibraryFileProvider._();

final class LibraryFileProvider extends $FunctionalProvider<AsyncValue<File>, File, FutureOr<File>>
    with $FutureModifier<File>, $FutureProvider<File> {
  LibraryFileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryFileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryFileHash();

  @$internal
  @override
  $FutureProviderElement<File> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<File> create(Ref ref) {
    return libraryFile(ref);
  }
}

String _$libraryFileHash() => r'973977eb0a64f7ce25f95f905740b0f801f473f4';

@ProviderFor(LibraryStore)
final libraryStoreProvider = LibraryStoreProvider._();

final class LibraryStoreProvider extends $AsyncNotifierProvider<LibraryStore, LoadedLibrary> {
  LibraryStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryStoreHash();

  @$internal
  @override
  LibraryStore create() => LibraryStore();
}

String _$libraryStoreHash() => r'0a75eb618358cf9904cfc0325a6047aa33404d50';

abstract class _$LibraryStore extends $AsyncNotifier<LoadedLibrary> {
  FutureOr<LoadedLibrary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LoadedLibrary>, LoadedLibrary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LoadedLibrary>, LoadedLibrary>,
              AsyncValue<LoadedLibrary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Runs every write to library.yaml one at a time, each against the file as
/// it is on disk at that moment. It lives apart from [LibraryStore] because
/// that notifier is recreated on every reload, which would drop a queue kept
/// there.

@ProviderFor(LibraryWrites)
final libraryWritesProvider = LibraryWritesProvider._();

/// Runs every write to library.yaml one at a time, each against the file as
/// it is on disk at that moment. It lives apart from [LibraryStore] because
/// that notifier is recreated on every reload, which would drop a queue kept
/// there.
final class LibraryWritesProvider extends $NotifierProvider<LibraryWrites, void> {
  /// Runs every write to library.yaml one at a time, each against the file as
  /// it is on disk at that moment. It lives apart from [LibraryStore] because
  /// that notifier is recreated on every reload, which would drop a queue kept
  /// there.
  LibraryWritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'libraryWritesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryWritesHash();

  @$internal
  @override
  LibraryWrites create() => LibraryWrites();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$libraryWritesHash() => r'3de4bc6b2902a31c021b78b842f0202b9ba2deb8';

/// Runs every write to library.yaml one at a time, each against the file as
/// it is on disk at that moment. It lives apart from [LibraryStore] because
/// that notifier is recreated on every reload, which would drop a queue kept
/// there.

abstract class _$LibraryWrites extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Newest first. Settings, History shows it with a Restore button per line.

@ProviderFor(changeLog)
final changeLogProvider = ChangeLogProvider._();

/// Newest first. Settings, History shows it with a Restore button per line.

final class ChangeLogProvider
    extends $FunctionalProvider<AsyncValue<List<ChangeLogEntry>>, List<ChangeLogEntry>, FutureOr<List<ChangeLogEntry>>>
    with $FutureModifier<List<ChangeLogEntry>>, $FutureProvider<List<ChangeLogEntry>> {
  /// Newest first. Settings, History shows it with a Restore button per line.
  ChangeLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changeLogProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changeLogHash();

  @$internal
  @override
  $FutureProviderElement<List<ChangeLogEntry>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChangeLogEntry>> create(Ref ref) {
    return changeLog(ref);
  }
}

String _$changeLogHash() => r'd6f35c3b7c98ad480e4aec339d6aa3219aab1d62';
