// (profiles part)
import "package:file/file.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/app/navigation.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/instructions/scopes.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/inline_picker.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

class ProfilesSection extends ConsumerWidget {
  const ProfilesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaded = ref.watch(libraryStoreProvider).value;
    if (loaded == null) return const Center(child: CircularProgressIndicator());
    final library = loaded.library;
    final problem = loaded.problem;
    // The app that was in front at the last hotkey, for "Add this app".
    final lastSource = ref.watch(sessionProvider.select((s) => s.input?.source));
    // Every edit here is a LibraryChange: validated, logged and undoable,
    // exactly like the assistant's.
    Future<void> save(LibraryChange change) => writeLibrary(
      ScaffoldMessenger.of(context),
      () => ref.read(libraryStoreProvider.notifier).apply([change], author: ChangeAuthor.you),
    );

    final gg = context.gg;
    return SettingsPageBody(
      title: "Profiles",
      description: "Instructions that switch on by themselves, for an app, a site, a language or a kind of text.",
      children: [
        if (problem != null) _Problem(problem),
        Panel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (final (i, profile) in library.profiles.indexed) ...[
                if (i > 0) Divider(color: gg.hairline, indent: 16, endIndent: 16),
                ExpansionTile(
                  title: Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    [
                      ...profile.when.apps,
                      if (profile.when.title != null) "title: ${profile.when.title!.pattern}",
                      ...profile.when.languages.map((l) => "language: $l"),
                    ].join(", "),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel("Uses"),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final instruction in library.instructions)
                          FilterChip(
                            label: Text(instruction.name),
                            selected: profile.use.contains(instruction.id),
                            side: BorderSide(
                              color: profile.use.contains(instruction.id) ? gg.profile : gg.hairline,
                              width: profile.use.contains(instruction.id) ? 1.5 : 1,
                            ),
                            onSelected: problem != null
                                ? null
                                : (on) => save(
                                    LibraryChange.putProfile(
                                      profile.copyWith(
                                        use: [
                                          for (final i in library.instructions)
                                            if (i.id == instruction.id ? on : profile.use.contains(i.id)) i.id,
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (lastSource != null && !profile.when.apps.contains(lastSource.id))
                          TextButton(
                            onPressed: () => save(
                              LibraryChange.putProfile(
                                profile.copyWith(
                                  when: profile.when.copyWith(apps: {...profile.when.apps, lastSource.id}),
                                ),
                              ),
                            ),
                            child: Text("Also use it in ${lastSource.name}"),
                          ),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(foregroundColor: gg.removed),
                          onPressed: () => save(LibraryChange.removeProfile(profile.name)),
                          child: const Text("Delete profile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (lastSource != null)
              FilledButton(
                onPressed: () => save(LibraryChange.putProfile(newAppProfile(library, lastSource))),
                child: Text("New profile for ${lastSource.name}"),
              ),
            TextButton(onPressed: () => askAssistant(ref), child: const Text("Set up profiles with the assistant")),
            TextButton(onPressed: () => openLibraryFile(ref), child: const Text("Open library.yaml")),
          ],
        ),
      ],
    );
  }
}

/// library.yaml did not load: why, that the built-in setup is used, and
/// the two ways out (fix the file by hand, or start over from the built-in
/// setup).
class _Problem extends ConsumerWidget {
  const _Problem(this.problem);

  final LibraryProblem problem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    return Panel(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: gg.removed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "library.yaml has a problem, so the built-in setup is used.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text("$problem"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => _useBuiltIn(context, ref),
                      child: const Text("Use the built-in setup"),
                    ),
                    TextButton(onPressed: () => openLibraryFile(ref), child: const Text("Open library.yaml")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _useBuiltIn(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    File? backup;
    final written = await writeLibrary(messenger, () async {
      backup = await ref.read(libraryStoreProvider.notifier).useBuiltIn();
    });
    if (!written) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          backup == null
              ? "Now using the built-in setup."
              : "Now using the built-in setup. Your old file is ${backup!.basename}.",
        ),
      ),
    );
  }
}

/// Opens library.yaml in the user's default editor; hand edits apply at once.
Future<void> openLibraryFile(WidgetRef ref) async {
  final file = await ref.read(libraryFileProvider.future);
  await launchUrl(Uri.file(file.path));
}

/// Every instruction, grouped like the bar shows them, with an editor.
class InstructionsSection extends ConsumerWidget {
  const InstructionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaded = ref.watch(libraryStoreProvider).value;
    if (loaded == null) return const Center(child: CircularProgressIndicator());
    final library = loaded.library;
    final groups = <GroupId?, List<Instruction>>{};
    for (final instruction in library.instructions) {
      groups.putIfAbsent(instruction.group, () => []).add(instruction);
    }

    final gg = context.gg;
    return SettingsPageBody(
      title: "Instructions",
      description: "What the model is told. Pinned ones are on the number keys; click one to edit it.",
      children: [
        if (loaded.problem case final problem?) _Problem(problem),
        for (final MapEntry(key: groupId, value: members) in groups.entries) ...[
          SectionLabel(groupId == null ? "Not in a group" : library.group(groupId)?.name ?? groupId.value),
          Panel(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                for (final (i, instruction) in members.indexed) ...[
                  if (i > 0) Divider(color: gg.hairline, indent: 16, endIndent: 16),
                  ListTile(
                    title: Text(instruction.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(instruction.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: instruction.pin == null ? null : KeyCap("${instruction.pin}"),
                    onTap: loaded.problem != null ? null : () => _edit(context, ref, library, instruction),
                  ),
                ],
              ],
            ),
          ),
        ],
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              onPressed: loaded.problem != null ? null : () => _edit(context, ref, library, null),
              child: const Text("New instruction"),
            ),
            TextButton(onPressed: () => askAssistant(ref), child: const Text("Write one with the assistant")),
          ],
        ),
      ],
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Library library, Instruction? existing) async {
    final changes = await showDialog<List<LibraryChange>>(
      context: context,
      builder: (_) => _InstructionDialog(library: library, existing: existing),
    );
    if (changes == null || changes.isEmpty || !context.mounted) return;
    await writeLibrary(
      ScaffoldMessenger.of(context),
      () => ref.read(libraryStoreProvider.notifier).apply(changes, author: ChangeAuthor.you),
    );
  }
}

class _InstructionDialog extends HookWidget {
  const _InstructionDialog({required this.library, this.existing});

  final Library library;
  final Instruction? existing;

  @override
  Widget build(BuildContext context) {
    final name = useTextEditingController(text: existing?.name ?? "");
    final text = useTextEditingController(text: existing?.text ?? "");
    final group = useState(existing?.group);
    final error = useState<String?>(null);

    void save() {
      final current = existing;
      final instruction = current == null
          ? wordsInstruction(library, name.text.trim()).copyWith(text: text.text.trim(), group: group.value)
          : current.copyWith(name: name.text.trim(), text: text.text.trim(), group: group.value);
      final change = LibraryChange.putInstruction(instruction);
      try {
        applyChanges(library, [change]); // same checks as the file and the assistant
        Navigator.of(context).pop([change]);
      } on LibraryProblem catch (problem) {
        error.value = problem.message;
      }
    }

    return AlertDialog(
      // The group list opens inside the dialog, which may then outgrow a
      // small window.
      scrollable: true,
      title: Text(existing == null ? "New instruction" : "Edit ${existing!.name}"),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              autofocus: true,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: text,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: "What the model is told", alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            InlinePicker<GroupId?>(
              label: "Group",
              value: group.value,
              options: [
                const PickerOption(null, "No group"),
                for (final g in library.groups) PickerOption(g.id, g.name),
              ],
              onPicked: (value) => group.value = value,
            ),
            if (error.value case final message?)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
          ],
        ),
      ),
      actions: [
        if (existing != null)
          TextButton(
            style: TextButton.styleFrom(foregroundColor: context.gg.removed),
            onPressed: () => Navigator.of(context).pop([LibraryChange.removeInstruction(existing!.id)]),
            child: const Text("Delete"),
          ),
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
        FilledButton(onPressed: save, child: const Text("Save")),
      ],
    );
  }
}
