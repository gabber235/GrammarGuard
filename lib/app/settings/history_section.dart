import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/app/footer.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/inline_picker.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class HistorySection extends ConsumerWidget {
  const HistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(historyProvider).value ?? const [];
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
              const _LimitPicker(),
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

/// How many rewrites to keep: a preset or a number of your own. Anything
/// that would delete saved rewrites asks first, since they cannot come back.
class _LimitPicker extends HookConsumerWidget {
  const _LimitPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final limit = ref.watch(historyLimitProvider).value ?? HistoryLimit.standard;
    final isPreset = HistoryLimit.presets.contains(limit);
    final custom = useState(!isPreset);
    final typed = useTextEditingController(text: isPreset ? "" : "$limit");
    final problem = useState<String?>(null);
    final asking = useRef(false);

    Future<void> apply(int next) async {
      final notifier = ref.read(historyLimitProvider.notifier);
      final history = ref.read(historyProvider.notifier);
      final saved = (await ref.read(historyProvider.future)).length;
      final over = saved - next;
      if (over > 0) {
        if (!context.mounted) return;
        final remove = next == 0
            ? await _ask(
                context,
                title: "Stop saving rewrites",
                body: "Also delete the $saved saved ${saved == 1 ? "rewrite" : "rewrites"}? This cannot be undone.",
                keep: "Keep them",
                drop: "Delete them",
              )
            : await _ask(
                context,
                title: "Keep fewer rewrites",
                body: "This removes the $over oldest ${over == 1 ? "rewrite" : "rewrites"}. This cannot be undone.",
                keep: "Cancel",
                drop: "Remove them",
              );
        if (remove == null || (!remove && next != 0)) return; // stayed as it was
        if (remove) await history.trim(next);
      }
      await notifier.set(next);
    }

    Future<void> applyTyped() async {
      final next = int.tryParse(typed.text);
      if (next == null || next < 1 || next > HistoryLimit.max) {
        problem.value = "Use a whole number from 1 to ${HistoryLimit.max}.";
        return;
      }
      problem.value = null;
      // Enter also takes the focus away, and so does the question itself.
      if (next == limit || asking.value) return;
      asking.value = true;
      await apply(next);
      asking.value = false;
      // Cancelled: back to what holds, or leaving the field asks again.
      if (context.mounted && ref.read(historyLimitProvider).value != next) typed.text = "$limit";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InlinePicker<int?>(
            label: "Rewrites to keep on this computer",
            value: custom.value ? null : limit,
            hint: "Custom",
            options: [
              for (final preset in HistoryLimit.presets) PickerOption(preset, preset == 0 ? "Off" : "$preset"),
              const PickerOption(null, "Custom"),
            ],
            onPicked: (picked) {
              problem.value = null;
              custom.value = picked == null;
              if (picked == null) {
                typed.text = isPreset ? "" : "$limit";
              } else {
                unawaited(apply(picked));
              }
            },
          ),
          if (custom.value) ...[
            const SizedBox(height: 10),
            Focus(
              skipTraversal: true,
              canRequestFocus: false,
              onFocusChange: (focused) {
                if (!focused) unawaited(applyTyped());
              },
              child: TextField(
                controller: typed,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: "How many, up to ${HistoryLimit.max}", errorText: problem.value),
                onSubmitted: (_) => applyTyped(),
              ),
            ),
          ],
          if (limit > 0 && limit < _recentsReach) ...[
            const SizedBox(height: 8),
            Text(
              "With few rewrites, recent picks and the assistant have less to learn from.",
              style: TextStyle(fontSize: 13, color: gg.muted),
            ),
          ],
        ],
      ),
    );
  }
}

/// The bar's recents read this many rewrites per app.
const _recentsReach = 30;

/// True to delete, false to go on without deleting, null to change nothing.
Future<bool?> _ask(
  BuildContext context, {
  required String title,
  required String body,
  required String keep,
  required String drop,
}) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [
      TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(keep)),
      TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(drop)),
    ],
  ),
);
