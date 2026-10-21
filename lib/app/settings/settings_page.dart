import "dart:async";

// Replaces provider_configuration.dart,
// api_key_configuration.dart, api_key_checker.dart and the Ollama widget in
// ollama_provider.dart:270.
import "package:animations/animations.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/app/settings/connection_tile.dart";
import "package:grammar_guard/app/settings/history_section.dart";
import "package:grammar_guard/app/settings/library_section.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/session/hotkey_binding.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:hotkey_manager/hotkey_manager.dart";

enum SettingsSection { models, instructions, profiles, general, history }

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({this.initial = SettingsSection.models, super.key});

  final SettingsSection initial;

  static Future<void> show(BuildContext context, [SettingsSection initial = SettingsSection.models]) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => SettingsPage(initial: initial)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = useState(initial);
    final gg = context.gg;
    return Scaffold(
      body: SafeArea(
        child: CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.of(context).maybePop()},
          child: Focus(
            autofocus: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 210,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              tooltip: "Back (Esc)",
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(width: 4),
                            Text("Settings", style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 14),
                        for (final s in SettingsSection.values)
                          PillRow(
                            current: s == section.value,
                            onTap: () => section.value = s,
                            child: Row(
                              children: [
                                Icon(s.icon, size: 18, color: s == section.value ? gg.ink : gg.muted),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    s.label,
                                    style: TextStyle(fontSize: 15, color: gg.ink),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(color: gg.hairline),
                Expanded(
                  child: PageTransitionSwitcher(
                    duration: context.motion(Motion.lift),
                    transitionBuilder: (child, animation, secondary) => LiftTransition(
                      animation: animation,
                      secondaryAnimation: secondary,
                      lift: Lift.sideways,
                      child: child,
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(section.value),
                      child: switch (section.value) {
                        SettingsSection.models => const _ModelsSection(),
                        SettingsSection.instructions => const InstructionsSection(),
                        SettingsSection.profiles => const ProfilesSection(),
                        SettingsSection.general => const _GeneralSection(),
                        SettingsSection.history => const HistorySection(),
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on SettingsSection {
  String get label => switch (this) {
    SettingsSection.models => "Models",
    SettingsSection.instructions => "Instructions",
    SettingsSection.profiles => "Profiles",
    SettingsSection.general => "General",
    SettingsSection.history => "History",
  };

  IconData get icon => switch (this) {
    SettingsSection.models => Icons.memory,
    SettingsSection.instructions => Icons.tune,
    SettingsSection.profiles => Icons.apps,
    SettingsSection.general => Icons.keyboard,
    SettingsSection.history => Icons.history,
  };
}

/// One settings page: a title, one line on what it is for, then panels.
class SettingsPageBody extends StatelessWidget {
  const SettingsPageBody({required this.title, required this.description, required this.children, super.key});

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(28, 22, 28, 28),
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20)),
      const SizedBox(height: 4),
      Text(description, style: TextStyle(fontSize: 14, color: context.gg.muted)),
      const SizedBox(height: 20),
      for (final (i, child) in children.indexed) ...[if (i > 0) const SizedBox(height: 14), child],
    ],
  );
}

class _ModelsSection extends StatelessWidget {
  const _ModelsSection();

  @override
  Widget build(BuildContext context) => const SettingsPageBody(
    title: "Models",
    description: "Where rewrites run. Add a key for a cloud service, or turn on a server on your computer.",
    children: [_AssistantModelPicker(), SectionLabel("Connections"), ConnectionList()],
  );
}

class _GeneralSection extends ConsumerWidget {
  const _GeneralSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final status = ref.watch(hotkeyBindingProvider).value;
    final hotkey = ref.watch(hotkeySettingProvider).value;
    final size = ref.watch(readingSizeProvider).value ?? ReadingSize.standard;
    final mac = defaultTargetPlatform == TargetPlatform.macOS;
    return SettingsPageBody(
      title: "General",
      description: "The shortcut that opens GrammarGuard, and how large the text is.",
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Shortcut", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text("Opens GrammarGuard from any app.", style: TextStyle(fontSize: 13, color: gg.muted)),
              const SizedBox(height: 12),
              _ShortcutRecorder(current: hotkey, mac: mac),
              if (status case HotkeyUnavailable(:final reason)) ...[
                const SizedBox(height: 10),
                Text(reason, style: TextStyle(color: gg.removed)),
              ],
            ],
          ),
        ),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text("Reading size", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  Text("${size.round()}", style: TextStyle(fontSize: 15, color: gg.muted)),
                ],
              ),
              const SizedBox(height: 8),
              Slider(
                value: size,
                min: ReadingSize.min,
                max: ReadingSize.max,
                divisions: (ReadingSize.max - ReadingSize.min).round(),
                onChanged: (value) => ref.read(readingSizeProvider.notifier).set(value),
              ),
              const SizedBox(height: 8),
              Text(
                "Hey team, I think we should have shipped this Friday.",
                style: TextStyle(fontSize: size, height: 1.7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The assistant's model, chosen once. Only models that can call tools are
/// offered; unknown ones (a local server's list) are offered too.
class _AssistantModelPicker extends ConsumerWidget {
  const _AssistantModelPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(libraryStoreProvider).value?.library.assistantModel;
    final models = [
      for (final m in ref.watch(modelCatalogProvider).value ?? const <ModelInfo>[])
        if (m.tools != false && m.ref.backend != Backend.apple) m,
    ];
    return Panel(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Assistant model", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text(
                  "Sets up instructions and profiles for you. It calls tools, so pick a capable model.",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<ModelRef>(
            value: models.any((m) => m.ref == current) ? current : null,
            hint: const Text("Choose a model"),
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(GgTheme.smallRadius),
            items: [for (final m in models) DropdownMenuItem(value: m.ref, child: Text(m.label))],
            onChanged: (model) => writeLibrary(
              ScaffoldMessenger.of(context),
              () => ref.read(libraryStoreProvider.notifier).apply([
                LibraryChange.setDefaults(assistantModel: model),
              ], author: ChangeAuthor.you),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows the shortcut; Change listens for exactly one new one. Only while
/// recording are keys taken, a modifier is required (a bare letter would
/// steal that letter in every app), and Esc cancels.
class _ShortcutRecorder extends HookConsumerWidget {
  const _ShortcutRecorder({required this.current, required this.mac});

  final HotKey? current;
  final bool mac;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final recording = useState(false);
    final hint = useState<String?>(null);
    final focus = useFocusNode();

    KeyEventResult onKey(FocusNode _, KeyEvent event) {
      if (!recording.value || event is! KeyDownEvent) return KeyEventResult.ignored;
      final key = event.physicalKey;
      if (key == PhysicalKeyboardKey.escape) {
        recording.value = false;
        hint.value = null;
        return KeyEventResult.handled;
      }
      final pressed = HardwareKeyboard.instance.physicalKeysPressed;
      final isModifier = HotKeyModifier.values.any((m) => m.physicalKeys.contains(key));
      if (isModifier) return KeyEventResult.handled; // wait for the main key
      final modifiers = [
        for (final m in HotKeyModifier.values)
          if (m != HotKeyModifier.capsLock && m.physicalKeys.any(pressed.contains)) m,
      ];
      if (modifiers.isEmpty) {
        hint.value = "Hold Cmd, Option, Ctrl or Shift too.";
        return KeyEventResult.handled;
      }
      recording.value = false;
      hint.value = null;
      unawaited(
        ref.read(hotkeySettingProvider.notifier).set(HotKey(key: key, modifiers: modifiers, scope: HotKeyScope.system)),
      );
      return KeyEventResult.handled;
    }

    return Focus(
      focusNode: focus,
      onKeyEvent: onKey,
      child: Row(
        children: [
          if (recording.value)
            Text("Press the new shortcut…", style: TextStyle(fontSize: 15, color: gg.highlighter))
          else if (current case final hotkey?)
            Wrap(spacing: 4, children: [for (final k in hotkeyLabels(hotkey, mac: mac)) KeyCap(k, size: 15)]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(hint.value ?? "", style: TextStyle(fontSize: 13, color: gg.muted)),
          ),
          TextButton(
            onPressed: () {
              recording.value = !recording.value;
              hint.value = null;
              if (recording.value) focus.requestFocus();
            },
            child: Text(recording.value ? "Cancel" : "Change"),
          ),
        ],
      ),
    );
  }
}
