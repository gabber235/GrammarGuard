import "package:flutter/material.dart";
import "package:grammar_guard/app/footer.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class HistorySection extends ConsumerWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(historyProvider).value ?? const [];
    final enabled = ref.watch(historyEnabledProvider).value ?? true;
    final usage = ref.watch(usageTotalsProvider).value;

    final gg = context.gg;
    final changes = ref.watch(changeLogProvider).value ?? const <ChangeLogEntry>[];
    return SettingsPageBody(
      title: "History",
      description: "Your past rewrites and every change to your setup, with a way back.",
      children: [
        Panel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Keep the last 100 rewrites on this computer"),
                value: enabled,
                onChanged: (on) => ref.read(historyEnabledProvider.notifier).set(enabled: on),
              ),
              Divider(color: gg.hairline, indent: 16, endIndent: 16),
              ListTile(
                title: Text("${usage?.tokens ?? 0} tokens, ${costLabel(usage?.cost ?? 0)} in total"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () => ref.read(usageTotalsProvider.notifier).reset(),
                      child: const Text("Reset count"),
                    ),
                    TextButton(
                      onPressed: () => ref.read(historyProvider.notifier).clear(),
                      child: const Text("Clear history"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Setup changes, apart from the chat: who changed what, and a way back.
        const SectionLabel("Setup changes"),
        Panel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: changes.isEmpty
              ? const ListTile(title: Text("No changes yet."))
              : Column(
                  children: [
                    for (final change in changes)
                      ListTile(
                        leading: Icon(
                          change.author == ChangeAuthor.assistant ? Icons.auto_awesome : Icons.person_outline,
                          color: change.author == ChangeAuthor.assistant ? gg.highlighter : gg.muted,
                        ),
                        title: Text(change.summary.join(", ")),
                        subtitle: Text(change.at.toLocal().toString().substring(0, 16)),
                        trailing: TextButton(
                          onPressed: () => writeLibrary(
                            ScaffoldMessenger.of(context),
                            () => ref.read(libraryStoreProvider.notifier).restore(change),
                          ),
                          child: const Text("Restore before this"),
                        ),
                      ),
                  ],
                ),
        ),
        const SectionLabel("Rewrites"),
        Panel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: entries.isEmpty
              ? const ListTile(title: Text("No rewrites yet."))
              : Column(
                  children: [
                    for (final entry in entries)
                      ExpansionTile(
                        title: Text(entry.output, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(
                          [entry.app ?? "Clipboard", entry.model ?? "", ...entry.instructions].join(" · "),
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionLabel("Before"),
                          SelectableText(entry.input),
                          const SizedBox(height: 10),
                          const SectionLabel("After"),
                          SelectableText(entry.output),
                        ],
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
