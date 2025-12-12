import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:grammar_guard/widgets/editor/editor_footer.dart";
import "package:grammar_guard/widgets/editor/selection_editor.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:window_manager/window_manager.dart";

class SelectionEditorPage extends HookConsumerWidget {
  const SelectionEditorPage({
    required this.diffs,
    super.key,
  });

  final List<Diff> diffs;

  static Future<String?> show(BuildContext context, List<Diff> diffs) {
    return Navigator.of(context).push<String?>(
      MaterialPageRoute(
        builder: (context) => SelectionEditorPage(diffs: diffs),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLineNumbers = useState(true);

    useEffect(
      () {
        Future.microtask(() {
          ref.read(selectionEditorProvider.notifier).initialize(diffs);
        });
        return null;
      },
      [],
    );

    final editorState = ref.watch(selectionEditorProvider);
    final hasUnsavedChanges = editorState?.hasUnsavedChanges ?? false;
    final pendingCount = editorState?.getPendingChangeCount() ?? 0;

    void confirmAndExit() {
      final navigator = Navigator.of(context);
      final notifier = ref.read(selectionEditorProvider.notifier)..acceptAll();
      final resultText = notifier.getCurrentText();
      if (resultText.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: resultText)).catchError((_) {});
      }
      navigator.pop(resultText);
      Future.delayed(const Duration(milliseconds: 150), () {
        windowManager.hide();
      });
    }

    void cancelAndExit() async {
      final navigator = Navigator.of(context);
      if (hasUnsavedChanges || pendingCount > 0) {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => _ExitConfirmationDialog(
            pendingCount: pendingCount,
            hasEdits: hasUnsavedChanges,
          ),
        );
        if (shouldExit != true) return;
      }
      navigator.pop(null);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selection Editor"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Back",
          onPressed: cancelAndExit,
        ),
        actions: [
          IconButton(
            icon: Icon(
              showLineNumbers.value
                  ? Icons.format_list_numbered
                  : Icons.format_list_numbered_rtl,
            ),
            tooltip: "Toggle line numbers (⌘L)",
            onPressed: () => showLineNumbers.value = !showLineNumbers.value,
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: confirmAndExit,
            icon: const Icon(Icons.check),
            label: const Text("Confirm"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SelectionEditor(
                showLineNumbers: showLineNumbers.value,
                onConfirm: confirmAndExit,
                onCancel: cancelAndExit,
              ),
            ),
            const SizedBox(height: 12),
            EditorFooter(
              onAccept: () => ref
                  .read(selectionEditorProvider.notifier)
                  .acceptCurrentChange(),
              onReject: () => ref
                  .read(selectionEditorProvider.notifier)
                  .rejectCurrentChange(),
              onConfirmAll: confirmAndExit,
              onCancel: cancelAndExit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExitConfirmationDialog extends StatelessWidget {
  const _ExitConfirmationDialog({
    required this.pendingCount,
    required this.hasEdits,
  });

  final int pendingCount;
  final bool hasEdits;

  @override
  Widget build(BuildContext context) {
    final messages = <String>[];
    if (pendingCount > 0) {
      messages
          .add("$pendingCount pending change${pendingCount > 1 ? "s" : ""}");
    }
    if (hasEdits) {
      messages.add("unsaved edits");
    }

    return AlertDialog(
      title: const Text("Discard changes?"),
      content: Text(
        "You have ${messages.join(" and ")}. "
        "Are you sure you want to discard and return to the main view?",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Discard"),
        ),
      ],
    );
  }
}
