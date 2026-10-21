// Replaces HomeScreen and options_group.dart
import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/app/compare_view.dart";
import "package:grammar_guard/app/footer.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/app/save_to_profile.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/assistant/assistant_view.dart";
import "package:grammar_guard/bar/command_bar.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/review/editor_page.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/review/review_spans.dart";
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

/// Every key of the main window in one table. Letters only act here; text
/// is typed in the bar (Space), so typing never triggers a shortcut.
/// The bar, compare and the assistant swap in their own, smaller set of
/// keys.
class RewriteScreen extends HookConsumerWidget {
  const RewriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionActionsProvider);
    final review = ref.read(reviewProvider.notifier);
    final library = ref.watch(libraryStoreProvider).value?.library;
    final view = useState(DiffView.inline);
    final preview = ref.watch(previewProvider);
    final assistantOpen = ref.watch(assistantProvider.select((a) => a.open));
    final bar = ref.watch(sessionProvider.select((s) => s.bar));
    // A text field has the keys: the bar's or the assistant's.
    final typing = assistantOpen || bar != null;
    final scroll = useScrollController();

    void scrollBy(double fraction) {
      // Only the inline review scrolls; other states have no scroll view.
      if (!scroll.hasClients) return;
      final position = scroll.position;
      scroll.jumpTo((position.pixels + position.viewportDimension * fraction).clamp(0, position.maxScrollExtent));
    }

    final comparing = ref.watch(sessionProvider.select((s) => s.compare != null));
    final settings = <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.comma, meta: true): () => SettingsPage.show(context),
      const SingleActivator(LogicalKeyboardKey.comma, control: true): () => SettingsPage.show(context),
    };
    final bindings = <ShortcutActivator, VoidCallback>{
      // Esc belongs to the assistant while it is open: stop it, then close.
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          assistantOpen ? ref.read(assistantProvider.notifier).close() : session.escape(),
      ...settings,
      // These shortcuts sit closer to the bar's and the assistant's text
      // field than the app's text editing keys, so while one is open every
      // other key must reach the field: letters, Space, Enter and Cmd+V.
      if (!typing && comparing) ...{
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => session.pickCompared(second: false),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => session.pickCompared(second: true),
      },
      if (!typing && !comparing) ...{
        // Pinned instructions, from library.yaml
        for (final (index, key) in _digits.indexed)
          if (library?.pinned(index + 1) case final instruction?)
            SingleActivator(key): () => session.toggle(instruction),
        // One level less or more in the stepped group (Fix … Rewrite)
        const SingleActivator(LogicalKeyboardKey.bracketLeft): () => session.step(-1),
        const SingleActivator(LogicalKeyboardKey.bracketRight): () => session.step(1),
        // The one place to type: search, requests, models, actions, assistant.
        const SingleActivator(LogicalKeyboardKey.space): session.openBar,
        const SingleActivator(LogicalKeyboardKey.keyM): () => session.openBar(const BarRequest(query: "@")),
        const SingleActivator(LogicalKeyboardKey.slash, shift: true, meta: true): () =>
            session.openBar(const BarRequest(query: "?")),
        // Review
        const SingleActivator(LogicalKeyboardKey.keyN): review.next,
        const SingleActivator(LogicalKeyboardKey.keyP): review.previous,
        const SingleActivator(LogicalKeyboardKey.keyY): review.keep,
        const SingleActivator(LogicalKeyboardKey.keyX): review.undo,
        const SingleActivator(LogicalKeyboardKey.keyU): review.undoLast,
        const SingleActivator(LogicalKeyboardKey.slash, shift: true): () =>
            ref.read(showReasonProvider.notifier).toggle(),
        const SingleActivator(LogicalKeyboardKey.tab): () => EditorPage.show(context),
        const SingleActivator(LogicalKeyboardKey.enter): session.deliver,
        // Run
        const SingleActivator(LogicalKeyboardKey.keyR): session.retry,
        const SingleActivator(LogicalKeyboardKey.keyS): () => saveToProfile(context, ref),
        const SingleActivator(LogicalKeyboardKey.keyC): () => session.openBar(const BarRequest(mode: BarMode.compare)),
        // View
        const SingleActivator(LogicalKeyboardKey.keyH): () =>
            view.value = view.value == DiffView.inline ? DiffView.sideBySide : DiffView.inline,
        const SingleActivator(LogicalKeyboardKey.keyV): () => ref.read(previewProvider.notifier).toggle(),
        const SingleActivator(LogicalKeyboardKey.keyJ): () => scrollBy(0.1),
        const SingleActivator(LogicalKeyboardKey.keyK): () => scrollBy(-0.1),
        const SingleActivator(LogicalKeyboardKey.keyD): () => scrollBy(0.5),
        // Explicit clipboard input, the way in without a hotkey
        const SingleActivator(LogicalKeyboardKey.keyV, meta: true): session.useClipboard,
        const SingleActivator(LogicalKeyboardKey.keyV, control: true): session.useClipboard,
      },
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
                      reverse: !typing && !comparing,
                      transitionBuilder: (child, animation, secondary) =>
                          LiftTransition(animation: animation, secondaryAnimation: secondary, child: child),
                      child: switch ((assistantOpen, bar, comparing)) {
                        (true, _, _) => const AssistantView(key: ValueKey("assistant")),
                        (_, final bar?, _) => CommandBar(key: ValueKey(bar), request: bar),
                        (_, _, true) => const CompareView(key: ValueKey("compare")),
                        _ => ResultView(
                          key: const ValueKey("result"),
                          view: view.value,
                          preview: preview,
                          scroll: scroll,
                        ),
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
