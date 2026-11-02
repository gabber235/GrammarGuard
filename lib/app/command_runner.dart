import "dart:async";

import "package:grammar_guard/app/navigation.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/app/save_to_profile.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/review/editor_page.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/session/commands.dart";
import "package:grammar_guard/session/key_tips.dart";
import "package:grammar_guard/session/session.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "command_runner.g.dart";

@Riverpod(keepAlive: true)
CommandRunner commandRunner(Ref ref) => CommandRunner(ref);

/// Does what a command means, however it was asked for: its key, a click on
/// its hint, or its row in the Keys view or the bar.
class CommandRunner {
  CommandRunner(this.ref);

  final Ref ref;

  Future<void> run(AppCommand command) async {
    unawaited(ref.read(keyTipsProvider.notifier).markUsed(command));
    final session = ref.read(sessionActionsProvider);
    final review = ref.read(reviewProvider.notifier);
    // Every other command is what the Keys view was opened to find.
    if (command != AppCommand.allKeys && command != AppCommand.back) session.closeKeys();

    switch (command) {
      case AppCommand.next:
        review.next();
      case AppCommand.previous:
        review.previous();
      case AppCommand.accept:
        review.keep();
      case AppCommand.reject:
        review.undo();
      case AppCommand.undoDecision:
        review.undoLast();
      case AppCommand.why:
        ref.read(showReasonProvider.notifier).toggle();
      case AppCommand.paste:
        await session.deliver();
      case AppCommand.openBar:
        session.openBar();
      case AppCommand.changeModel:
        session.openBar(const BarRequest(query: "@"));
      case AppCommand.less:
        session.step(-1);
      case AppCommand.more:
        session.step(1);
      case AppCommand.compare:
        session.openBar(const BarRequest(mode: BarMode.compare));
      case AppCommand.retry:
        session.retry();
      case AppCommand.saveForApp:
        if (appNavigator.currentContext case final context?) await saveToProfile(context, ref);
      case AppCommand.ask:
        session.openBar(const BarRequest(query: "?"));
      case AppCommand.sideBySide:
        ref.read(reviewLayoutProvider.notifier).toggle();
      case AppCommand.preview:
        ref.read(previewProvider.notifier).toggle();
      case AppCommand.editor:
        if (appNavigator.currentContext case final context?) await EditorPage.show(context);
      case AppCommand.scrollDown:
        _scrollBy(0.1);
      case AppCommand.scrollUp:
        _scrollBy(-0.1);
      case AppCommand.pageDown:
        _scrollBy(0.5);
      case AppCommand.allKeys:
        session.toggleKeys();
      case AppCommand.clipboard:
        await session.useClipboard();
      case AppCommand.settings:
        await openSettings();
      case AppCommand.back:
        if (ref.read(assistantProvider).open) {
          ref.read(assistantProvider.notifier).close();
        } else {
          await session.escape();
        }
      case AppCommand.history:
        await openSettings(SettingsSection.history);
      case AppCommand.undoSetupChange:
        await ref.read(libraryStoreProvider.notifier).undo();
    }
  }

  void _scrollBy(double fraction) {
    final scroll = ref.read(reviewScrollProvider);
    // Only the inline review scrolls; other states have no scroll view.
    if (!scroll.hasClients) return;
    final position = scroll.position;
    scroll.jumpTo((position.pixels + position.viewportDimension * fraction).clamp(0, position.maxScrollExtent));
  }
}
