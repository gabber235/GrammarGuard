import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:grammar_guard/widgets/editor/editor_footer.dart";
import "package:grammar_guard/widgets/editor/selection_editor.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Tab: the Vim editor over the same review state as the main view, so
/// there is nothing to load, copy or hide here.
class EditorPage extends HookConsumerWidget {
  const EditorPage({super.key});

  static Future<void> show(BuildContext context) async {
    if (ProviderScope.containerOf(context).read(reviewProvider) == null) return; // still writing
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const EditorPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLineNumbers = useState(true);

    void confirmAndExit() {
      Navigator.of(context).pop();
      // Same delivery as Enter in the main view: paste back or copy.
      unawaited(ref.read(sessionActionsProvider).deliver());
    }

    // Edits stay in the review, so leaving keeps them; Enter in the main
    // view delivers them later.
    void back() => Navigator.of(context).pop();

    final gg = context.gg;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 20, 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), tooltip: "Back to the review (Esc)", onPressed: back),
                  const SizedBox(width: 4),
                  Text("Edit", style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(width: 10),
                  Text(
                    "Vim keys; suggestions stay open while you type",
                    style: TextStyle(fontSize: 13, color: gg.muted),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.format_list_numbered),
                    isSelected: showLineNumbers.value,
                    selectedIcon: Icon(Icons.format_list_numbered, color: gg.highlighter),
                    tooltip: "Line numbers",
                    onPressed: () => showLineNumbers.value = !showLineNumbers.value,
                  ),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: confirmAndExit, child: const Text("Paste back")),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SelectionEditor(
                    showLineNumbers: showLineNumbers.value,
                    onConfirm: confirmAndExit,
                    onCancel: back,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: EditorFooter(
                  onAccept: () => ref.read(reviewProvider.notifier).keep(),
                  onReject: () => ref.read(reviewProvider.notifier).undo(),
                  onConfirmAll: confirmAndExit,
                  onCancel: back,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
