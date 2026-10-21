import "dart:async";
import "dart:convert";
import "dart:io" show FileSystemMoveEvent;

import "package:clock/clock.dart";
import "package:collection/collection.dart";
import "package:file/file.dart";
import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:yaml/yaml.dart";
import "package:yaml_edit/yaml_edit.dart";

part "library_store.freezed.dart";
part "library_store.g.dart";

/// The library in use, plus the problem in the user's file if it is broken.
/// A broken file never blocks a rewrite: the bundled library is used instead.
@freezed
abstract class LoadedLibrary with _$LoadedLibrary {
  const factory LoadedLibrary(Library library, {LibraryProblem? problem}) = _LoadedLibrary;
}

enum ChangeAuthor { you, assistant }

/// One line in Settings, History. [snapshot] is the file as it was before.
@freezed
abstract class ChangeLogEntry with _$ChangeLogEntry {
  const factory ChangeLogEntry({
    required DateTime at,
    required ChangeAuthor author,
    required List<String> summary,
    required String snapshot,
  }) = _ChangeLogEntry;

  factory ChangeLogEntry.fromJson(Map<String, dynamic> json) => _$ChangeLogEntryFromJson(json);
}

const _keepSnapshots = 20;

@Riverpod(keepAlive: true)
Future<File> libraryFile(Ref ref) async {
  final folder = await ref.watch(appSupportDirProvider.future);
  final file = folder.childFile("library.yaml");
  if (!file.existsSync()) {
    await file.writeAsString(await ref.read(bundledAssetProvider("assets/library.yaml").future));
  }
  return file;
}

@Riverpod(keepAlive: true)
class LibraryStore extends _$LibraryStore {
  @override
  Future<LoadedLibrary> build() async {
    final file = await ref.watch(libraryFileProvider.future);
    // Hand edits in any editor apply without a restart.
    try {
      final watch = file.parent.watch().where((e) => touchesFile(e, file.path)).listen((_) => ref.invalidateSelf());
      ref.onDispose(watch.cancel);
    } on UnsupportedError {
      // In-memory file systems in tests cannot watch.
    }

    try {
      return LoadedLibrary(parseLibrary(await file.readAsString()));
    } on Exception catch (error) {
      // The parser only throws LibraryProblem; anything else is the file
      // itself (gone halfway through an editor's save, not UTF-8).
      final problem = error is LibraryProblem ? error : LibraryProblem("library.yaml could not be read: $error");
      final bundled = await ref.read(bundledAssetProvider("assets/library.yaml").future);
      return LoadedLibrary(parseLibrary(bundled), problem: problem);
    }
  }

  /// The single write path. Validates the result first (throws
  /// [LibraryProblem] and writes nothing), keeps a snapshot for undo, edits
  /// the YAML in place so comments survive, and logs who changed what.
  ///
  /// With [restoring], the changes apply on top of that earlier setup, and
  /// the whole thing is still one write, so one undo reverts it.
  Future<void> apply(List<LibraryChange> changes, {required ChangeAuthor author, ChangeLogEntry? restoring}) =>
      ref.read(libraryWritesProvider.notifier).apply(changes, author: author, restoring: restoring);

  /// Puts back the file from before the latest change. Logged too, so an
  /// undo can itself be undone.
  Future<void> undo() => ref.read(libraryWritesProvider.notifier).undo();

  Future<void> restore(ChangeLogEntry entry) => apply(const [], author: ChangeAuthor.you, restoring: entry);

  /// The way out of a file that does not load: puts the built-in setup in
  /// place of library.yaml and keeps the old file next to it. Returns that
  /// copy, or null when there was no file to keep.
  Future<File?> useBuiltIn() => ref.read(libraryWritesProvider.notifier).useBuiltIn();
}

/// Whether a watch event on the library's folder concerns the library.
/// Editors that save by writing a temporary file and renaming it over the
/// original report a move whose destination is the library.
@visibleForTesting
bool touchesFile(FileSystemEvent event, String path) =>
    event.path == path || (event is FileSystemMoveEvent && event.destination == path);

/// Runs every write to library.yaml one at a time, each against the file as
/// it is on disk at that moment. It lives apart from [LibraryStore] because
/// that notifier is recreated on every reload, which would drop a queue kept
/// there.
@Riverpod(keepAlive: true)
class LibraryWrites extends _$LibraryWrites {
  Future<void> _last = Future.value();

  @override
  void build() {}

  Future<void> apply(List<LibraryChange> changes, {required ChangeAuthor author, ChangeLogEntry? restoring}) =>
      _queued(() => _apply(changes, author: author, restoring: restoring));

  Future<void> undo() => _queued(() async {
    final file = await ref.read(libraryFileProvider.future);
    final last = (await _readLog(file)).firstOrNull;
    if (last != null) await _apply(const [], author: ChangeAuthor.you, restoring: last);
  });

  Future<File?> useBuiltIn() => _queued(() async {
    final file = await ref.read(libraryFileProvider.future);
    // Not a logged change: the old file may not load, so History could not
    // restore it. The copy, named for the moment it was set aside, is the
    // way back: library.yaml.broken-2026-10-21T12-30-00.
    File? backup;
    if (file.existsSync()) {
      final stamp = clock.now().toIso8601String().substring(0, 19).replaceAll(":", "-");
      final name = "${file.basename}.broken-$stamp";
      var free = file.parent.childFile(name);
      for (var n = 1; free.existsSync(); n++) {
        free = file.parent.childFile("$name-$n");
      }
      backup = await file.copy(free.path);
    }
    await file.writeAsString(await ref.read(bundledAssetProvider("assets/library.yaml").future));
    ref.invalidate(libraryStoreProvider);
    return backup;
  });

  Future<T> _queued<T>(Future<T> Function() write) {
    final done = _last.then((_) => write());
    _last = done.then((_) {}, onError: (Object _) {});
    return done;
  }

  Future<void> _apply(List<LibraryChange> changes, {required ChangeAuthor author, ChangeLogEntry? restoring}) async {
    if (changes.isEmpty && restoring == null) return;
    final file = await ref.read(libraryFileProvider.future);
    final current = await file.readAsString();
    // The edits are computed against the very text they are applied to, not
    // against the loaded library, which may lag behind a hand edit.
    final base = restoring == null ? current : await _snapshotText(file, restoring);
    final Library was;
    try {
      was = parseLibrary(base);
    } on LibraryProblem catch (problem) {
      throw LibraryProblem(
        restoring == null ? "Fix library.yaml first: $problem" : "That version does not load: $problem",
      );
    }
    final editor = YamlEditor(base);
    _sync(editor, was, applyChanges(was, changes));
    await _write(file, current, editor.toString(), author, [
      if (restoring != null) "Restored the setup from before: ${restoring.summary.join(", ")}",
      for (final c in changes) c.summary,
    ]);
  }

  Future<String> _snapshotText(File file, ChangeLogEntry entry) async {
    final snapshot = file.fileSystem.file(entry.snapshot);
    if (!snapshot.existsSync()) throw const LibraryProblem("That version is no longer kept.");
    return snapshot.readAsString();
  }

  Future<void> _write(File file, String before, String after, ChangeAuthor author, List<String> summary) async {
    parseLibrary(after); // never write a file that does not load
    final folder = file.parent.childDirectory("setup-history")..createSync(recursive: true);
    final now = clock.now();
    var snapshot = folder.childFile("${now.millisecondsSinceEpoch}.yaml");
    for (var n = 1; snapshot.existsSync(); n++) {
      snapshot = folder.childFile("${now.millisecondsSinceEpoch}-$n.yaml");
    }
    await snapshot.writeAsString(before);
    await file.writeAsString(after);

    // The log and the snapshots are trimmed together, so every line in
    // History can still be restored.
    final log = [
      ChangeLogEntry(at: now, author: author, summary: summary, snapshot: snapshot.path),
      ...await _readLog(file),
    ].take(_keepSnapshots).toList();
    await _logFile(file).writeAsString(log.reversed.map((e) => "${jsonEncode(e.toJson())}\n").join());
    final kept = {for (final e in log) e.snapshot};
    for (final old in folder.listSync().whereType<File>().where((f) => !kept.contains(f.path))) {
      old.deleteSync();
    }
    ref
      ..invalidate(libraryStoreProvider)
      ..invalidate(changeLogProvider);
  }

  /// Brings the YAML in line with [next] using the smallest edits, so the
  /// user's comments and order stay where they were. [before] must be parsed
  /// from the editor's own text, so list positions line up.
  void _sync(YamlEditor editor, Library before, Library next) {
    void syncList<T>(
      String key,
      List<T> was,
      List<T> now,
      String Function(T) id,
      Map<String, Object?> Function(T) yaml,
    ) {
      // A missing or empty key (`profiles:`) has no list to edit yet.
      if (editor.parseAt([key], orElse: () => YamlScalar.wrap(null)) is! YamlList) {
        if (now.isNotEmpty) editor.update([key], [for (final item in now) yaml(item)]);
        return;
      }
      final eq = const DeepCollectionEquality();
      for (final item in now) {
        final at = was.indexWhere((w) => id(w) == id(item));
        if (at < 0) {
          editor.appendToList([key], yaml(item));
        } else if (!eq.equals(yaml(was[at]), yaml(item))) {
          editor.update([key, at], yaml(item));
        }
      }
      // Remove from the end so earlier indexes stay valid.
      for (final (at, item) in was.indexed.toList().reversed) {
        if (!now.any((n) => id(n) == id(item))) editor.remove([key, at]);
      }
    }

    syncList("groups", before.groups, next.groups, (g) => g.id.value, groupToYaml);
    syncList("instructions", before.instructions, next.instructions, (i) => i.id.value, instructionToYaml);
    syncList("profiles", before.profiles, next.profiles, (p) => p.name, profileToYaml);
    if (!const ListEquality<InstructionId>().equals(before.defaults, next.defaults)) {
      editor.update(["defaults"], [for (final id in next.defaults) id.value]);
    }
    if (before.defaultModel != next.defaultModel) {
      editor.update(["default_model"], next.defaultModel?.toString());
    }
    if (before.assistantModel != next.assistantModel) {
      editor.update(["assistant_model"], next.assistantModel?.toString());
    }
    if (!const ListEquality<String>().equals(before.keepWords, next.keepWords)) {
      editor.update(["keep_words"], next.keepWords);
    }
  }
}

File _logFile(File library) => library.parent.childFile("setup-changes.jsonl");

/// Newest first.
Future<List<ChangeLogEntry>> _readLog(File library) async {
  final log = _logFile(library);
  if (!log.existsSync()) return const [];
  return [
    for (final line in (await log.readAsLines()).reversed)
      if (line.trim().isNotEmpty) ChangeLogEntry.fromJson(jsonDecode(line) as Map<String, dynamic>),
  ];
}

/// Newest first. Settings, History shows it with a Restore button per line.
@Riverpod(keepAlive: true)
Future<List<ChangeLogEntry>> changeLog(Ref ref) async => _readLog(await ref.watch(libraryFileProvider.future));
