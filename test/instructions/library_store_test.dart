import "dart:io" as io;

import "package:file/memory.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  late MemoryFileSystem files;
  late ProviderContainer container;

  setUp(() {
    files = MemoryFileSystem();
    container = ProviderContainer(
      overrides: [
        fileSystemProvider.overrideWithValue(files),
        appSupportDirProvider.overrideWith((ref) async => files.directory("/support")..createSync()),
        bundledAssetProvider.overrideWith((ref, key) async => io.File(key).readAsStringSync()),
      ],
    );
  });
  tearDown(() => container.dispose());

  Future<Library> library() async => (await container.read(libraryStoreProvider.future)).library;
  String file() => files.file("/support/library.yaml").readAsStringSync();
  LibraryStore store() => container.read(libraryStoreProvider.notifier);
  Future<List<ChangeLogEntry>> log() => container.read(changeLogProvider.future);
  LibraryChange put(String id, [String text = "t"]) =>
      LibraryChange.putInstruction(Instruction(id: InstructionId(id), name: id, text: text));

  /// Starts from a small file of the test's own instead of the bundled one.
  Future<void> start(String yaml) async {
    files.directory("/support").createSync();
    files.file("/support/library.yaml").writeAsStringSync(yaml);
    await library();
  }

  const twoItems = "instructions:\n  - {id: a, name: a, text: t}\n  - {id: b, name: b, text: t}\n";

  test("first launch copies the bundled library", () async {
    expect((await library()).instructions, isNotEmpty);
    expect(file(), contains("Discord markdown"));
  });

  test("apply keeps comments, logs the change and undo restores it", () async {
    await library();
    await container.read(libraryStoreProvider.notifier).apply([
      const LibraryChange.putInstruction(
        Instruction(id: InstructionId("british"), name: "British", text: "Use British spelling."),
      ),
    ], author: ChangeAuthor.assistant);
    expect((await library())[const InstructionId("british")], isNotNull);
    expect(file(), contains("# [ and ] step through"), reason: "comments survive app edits");

    final log = await container.read(changeLogProvider.future);
    expect(log.single.author, ChangeAuthor.assistant);
    expect(log.single.summary, ["Instruction British"]);

    await container.read(libraryStoreProvider.notifier).undo();
    expect((await library())[const InstructionId("british")], isNull);
    expect((await container.read(changeLogProvider.future)).first.author, ChangeAuthor.you);
  });

  test("an invalid change is refused and nothing is written", () async {
    await library();
    final before = file();
    await expectLater(
      container.read(libraryStoreProvider.notifier).apply([
        const LibraryChange.putProfile(
          Profile(
            name: "X",
            when: When(apps: {"x"}),
            use: [InstructionId("nope")],
          ),
        ),
      ], author: ChangeAuthor.you),
      throwsA(isA<LibraryProblem>()),
    );
    expect(file(), before);
  });

  test("a broken file falls back to the bundled library and reports the line", () async {
    await library();
    files.file("/support/library.yaml").writeAsStringSync("instructions: [");
    container.invalidate(libraryStoreProvider);
    final loaded = await container.read(libraryStoreProvider.future);
    expect(loaded.problem, isNotNull);
    expect(loaded.library.instructions, isNotEmpty);
  });

  test("a wrong value or a bad pattern in the file falls back instead of failing the store", () async {
    for (final broken in [
      "${twoItems}groups:\n  - {id: 5, name: G}\n",
      "instructions:\n  - {id: a, name: a, text: t, group: 5}\n",
      "instructions:\n  - {id: a, name: a, text: t, pin: x}\n",
      "${twoItems}profiles:\n  - {name: P, use: [a], when: {min_words: ten}}\n",
      "${twoItems}profiles:\n  - {name: P, use: [a], when: {title: \"(\"}}\n",
    ]) {
      files.directory("/support").createSync();
      files.file("/support/library.yaml").writeAsStringSync(broken);
      container.invalidate(libraryStoreProvider);
      final loaded = await container.read(libraryStoreProvider.future);
      expect(loaded.problem, isNotNull, reason: broken);
      expect(loaded.library.instructions, isNotEmpty, reason: broken);
    }
  });

  test("an empty name or text is refused before anything is written", () async {
    await start(twoItems);
    final before = file();
    for (final change in [
      const LibraryChange.putInstruction(Instruction(id: InstructionId("c"), name: "", text: "t")),
      const LibraryChange.putInstruction(Instruction(id: InstructionId("c"), name: "C", text: " ")),
      const LibraryChange.putProfile(
        Profile(
          name: "",
          when: When(apps: {"x"}),
        ),
      ),
    ]) {
      await expectLater(store().apply([change], author: ChangeAuthor.you), throwsA(isA<LibraryProblem>()));
    }
    expect(file(), before);
    expect(await log(), isEmpty);
  });

  test("the change log keeps as many entries as snapshots, and each one restores", () async {
    await start(twoItems);
    for (var n = 0; n < 25; n++) {
      await store().apply([put("a", "text $n")], author: ChangeAuthor.you);
    }
    final entries = await log();
    expect(entries, hasLength(20));
    expect(files.directory("/support/setup-history").listSync(), hasLength(20));
    expect(entries.every((e) => files.file(e.snapshot).existsSync()), isTrue);

    await store().restore(entries.last);
    expect((await library())[const InstructionId("a")]!.text, "text 4");
  });

  test("restoring a version whose snapshot is gone is a LibraryProblem", () async {
    await start(twoItems);
    await store().apply([put("c")], author: ChangeAuthor.you);
    final entry = (await log()).single;
    files.file(entry.snapshot).deleteSync();
    await expectLater(
      store().restore(entry),
      throwsA(isA<LibraryProblem>().having((p) => p.message, "message", contains("no longer kept"))),
    );
  });

  test("an edit made outside the app is not undone by the next apply", () async {
    await start(twoItems);
    // Saved in an editor; the watcher has not reloaded the store yet.
    files
        .file("/support/library.yaml")
        .writeAsStringSync(
          "instructions:\n  - {id: new, name: new, text: t}\n  - {id: a, name: a, text: t}\n  - {id: b, name: b, text: t}\n",
        );
    await store().apply([put("b", "changed")], author: ChangeAuthor.you);
    final now = await library();
    expect(now.instructions.map((i) => (i.id.value, i.text)), [("new", "t"), ("a", "t"), ("b", "changed")]);
  });

  test("overlapping applies run one after the other", () async {
    await start(twoItems);
    await Future.wait([
      store().apply([put("c")], author: ChangeAuthor.you),
      store().apply([put("d")], author: ChangeAuthor.you),
      store().apply([const LibraryChange.removeInstruction(InstructionId("a"))], author: ChangeAuthor.you),
    ]);
    expect((await library()).instructions.map((i) => i.id.value), ["b", "c", "d"]);
    expect(await log(), hasLength(3));
  });

  test("a restore with other changes is one write, and one undo reverts it", () async {
    await start(twoItems);
    await store().apply([put("c")], author: ChangeAuthor.you);
    final beforeApply = file();
    await store().apply([put("d")], author: ChangeAuthor.assistant, restoring: (await log()).single);
    expect((await library()).instructions.map((i) => i.id.value), ["a", "b", "d"]);
    final entries = await log();
    expect(entries, hasLength(2));
    expect(entries.first.summary, [startsWith("Restored the setup"), "Instruction d"]);

    await store().undo();
    expect(file(), beforeApply);
  });

  test("the watcher also reacts to a save by rename", () {
    const path = "/support/library.yaml";
    expect(touchesFile(io.FileSystemModifyEvent(path, false, true), path), isTrue);
    expect(touchesFile(io.FileSystemMoveEvent("/support/.library.yaml.tmp", false, path), path), isTrue);
    expect(touchesFile(io.FileSystemCreateEvent("/support/other.yaml", false), path), isFalse);
  });
}
