// Replaces HomeScreen and options_group.dart
import "dart:async";

import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:grammar_guard/app/command_runner.dart";
import "package:grammar_guard/app/compare_view.dart";
import "package:grammar_guard/app/footer.dart";
import "package:grammar_guard/app/keys_view.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/assistant/assistant_view.dart";
import "package:grammar_guard/bar/command_bar.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/session/commands.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/widgets/always_focused.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

const _digits = [
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
  LogicalKeyboardKey.digit7,
  LogicalKeyboardKey.digit8,
  LogicalKeyboardKey.digit9,
];

/// The main window. Letters only act here; text is typed in the bar (Space),
/// so typing never triggers a shortcut. [AppCommand] says which key does what.
/// The bar, compare and the assistant swap in their own, smaller set of keys.
class RewriteScreen extends ConsumerWidget {
  const RewriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionActionsProvider);
    final runner = ref.read(commandRunnerProvider);
    final library = ref.watch(libraryStoreProvider).value?.library;
    final assistantOpen = ref.watch(assistantProvider.select((a) => a.open));
    final bar = ref.watch(sessionProvider.select((s) => s.bar));
    final showKeys = ref.watch(sessionProvider.select((s) => s.showKeys));
    final comparing = ref.watch(sessionProvider.select((s) => s.compare != null));
    // A text field has the keys: the bar's or the assistant's.
    final typing = assistantOpen || bar != null;

    final bindings = <ShortcutActivator, VoidCallback>{
      // These shortcuts sit closer to the bar's and the assistant's text
      // field than the app's text editing keys, so while one is open every
      // other key must reach the field: letters, Space, Enter and Cmd+V.
      for (final command in AppCommand.values)
        if (command.whileTyping || (!typing && !comparing))
          for (final activator in command.activators) activator: () => unawaited(runner.run(command)),
      if (!typing && comparing) ...{
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => session.pickCompared(second: false),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => session.pickCompared(second: true),
      },
      // Pinned instructions, from library.yaml
      if (!typing && !comparing)
        for (final (index, key) in _digits.indexed)
          if (library?.pinned(index + 1) case final instruction?)
            SingleActivator(key): () => session.toggle(instruction),
    };

    return CallbackShortcuts(
      bindings: bindings,
      child: AlwaysFocused(
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    // The bar, the assistant and compare lift in over the
                    // result; Esc drops them and the result springs back.
                    child: PageTransitionSwitcher(
                      duration: context.motion(Motion.lift),
                      reverse: !typing && !comparing && !showKeys,
                      transitionBuilder: (child, animation, secondary) =>
                          LiftTransition(animation: animation, secondaryAnimation: secondary, child: child),
                      child: switch ((assistantOpen, bar, comparing, showKeys)) {
                        (true, _, _, _) => const AssistantView(key: ValueKey("assistant")),
                        (_, final bar?, _, _) => CommandBar(key: ValueKey(bar), request: bar),
                        (_, _, true, _) => const CompareView(key: ValueKey("compare")),
                        (_, _, _, true) => const KeysView(key: ValueKey("keys")),
                        _ => const ResultView(key: ValueKey("result")),
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
