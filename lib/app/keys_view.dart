import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:grammar_guard/app/command_runner.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/commands.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hotkey_manager/hotkey_manager.dart";

/// ?: every key that works right now, in place of the result. Each row does
/// what its key does, so the list works with a mouse too.
class KeysView extends ConsumerWidget {
  const KeysView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final input = ref.watch(sessionProvider.select((s) => s.input));
    final finished = ref.watch(currentRunProvider)?.value is Done;
    final library = ref.watch(libraryStoreProvider).value?.library;
    final runner = ref.read(commandRunnerProvider);
    final session = ref.read(sessionActionsProvider);

    bool works(AppCommand command) => switch (command.need) {
      CommandNeed.nothing => true,
      CommandNeed.text => input != null,
      CommandNeed.result => finished,
    };

    List<Widget> group(CommandGroup group, {List<Widget> extra = const []}) {
      final rows = [
        for (final command in AppCommand.values)
          if (command.group == group && command.keys.isNotEmpty && works(command))
            KeyRow(command.labels, command.title, onTap: () => unawaited(runner.run(command))),
        ...extra,
      ];
      return rows.isEmpty
          ? const []
          : [
              Padding(padding: const EdgeInsets.only(left: 10), child: SectionLabel(group.label)),
              const SizedBox(height: 4),
              ...rows,
            ];
    }

    final pins = [
      if (library != null && input != null)
        for (var pin = 1; pin <= 9; pin++)
          if (library.pinned(pin) case final Instruction instruction?)
            KeyRow(["$pin"], instruction.name, onTap: () => session.toggle(instruction)),
    ];
    final review = group(CommandGroup.review);
    final view = group(CommandGroup.view);
    // At the top even when short: the window's views stack centered.
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text(
                input == null ? "Keys" : "Keys for this rewrite",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review.isNotEmpty) Expanded(child: _Column(review)),
                Expanded(child: _Column(group(CommandGroup.rewrite, extra: pins))),
                Expanded(
                  child: _Column([
                    ...view,
                    if (view.isNotEmpty) const SizedBox(height: 14),
                    ...group(CommandGroup.window, extra: const [_GlobalKeys()]),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Column extends StatelessWidget {
  const _Column(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
  );
}

/// The keys that work from any app.
class _GlobalKeys extends ConsumerWidget {
  const _GlobalKeys();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mac = defaultTargetPlatform == TargetPlatform.macOS;
    final rewrite = ref.watch(hotkeySettingProvider).value;
    final choose = ref.watch(chooseFirstHotkeySettingProvider).value;
    Widget row(HotKey hotkey, String what) => KeyRow(hotkeyLabels(hotkey, mac: mac), what);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rewrite != null) row(rewrite, "Rewrite from any app"),
        if (choose != null) row(choose, "Choose the model first, from any app"),
      ],
    );
  }
}

/// Keys pressed together, then what they do. With [onTap] it does that too.
class KeyRow extends StatelessWidget {
  const KeyRow(this.keys, this.what, {this.onTap, super.key});

  final List<String> keys;
  final String what;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => PillRow(
    current: false,
    onTap: onTap,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: Row(
      children: [
        // The usual keys take the same width, so the names form one straight
        // column; a long chord pushes only its own name.
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 62, maxWidth: 170),
          child: Wrap(spacing: 3, runSpacing: 3, children: [for (final key in keys) KeyCap(key)]),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(what, style: TextStyle(fontSize: 14, color: context.gg.ink)),
        ),
      ],
    ),
  );
}

/// The full list in Settings: every view, whatever is on screen now.
class KeysSection extends ConsumerWidget {
  const KeysSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(libraryStoreProvider).value?.library;
    List<Widget> group(String label, List<Widget> rows) => [
      SectionLabel(label),
      Panel(
        padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows),
      ),
    ];

    return SettingsPageBody(
      title: "Keys",
      description: "Every key in one place. In the main window, press ? to see the ones that work right now.",
      children: [
        for (final commandGroup in CommandGroup.values)
          ...group(commandGroup.label, [
            for (final command in AppCommand.values)
              if (command.group == commandGroup && command.keys.isNotEmpty) KeyRow(command.labels, command.title),
            if (commandGroup == CommandGroup.rewrite && library != null)
              for (var pin = 1; pin <= 9; pin++)
                if (library.pinned(pin) case final Instruction instruction?) KeyRow(["$pin"], instruction.name),
            if (commandGroup == CommandGroup.window) const _GlobalKeys(),
          ]),
        for (final (label, entries) in otherKeyGroups)
          ...group(label, [for (final entry in entries) KeyRow(entry.labels, entry.what)]),
      ],
    );
  }
}
