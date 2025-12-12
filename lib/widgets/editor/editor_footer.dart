import "package:flutter/material.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class EditorFooter extends ConsumerWidget {
  const EditorFooter({
    this.onAccept,
    this.onReject,
    this.onConfirmAll,
    this.onCancel,
    super.key,
  });

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onConfirmAll;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(selectionEditorProvider);

    if (editorState == null) {
      return const SizedBox.shrink();
    }

    final vimState = editorState.vimState;
    final pendingCount = editorState.getPendingChangeCount();
    final totalCount = editorState.getTotalChangeCount();
    final (line, column) =
        editorState.document.positionToLineColumn(vimState.cursorPosition);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ModeIndicator(mode: vimState.mode),
          const SizedBox(width: 16),
          _KeybindHints(
            onAccept: onAccept,
            onReject: onReject,
            onConfirmAll: onConfirmAll,
            onCancel: onCancel,
          ),
          const Spacer(),
          if (totalCount > 0)
            _ChangeCounter(pending: pendingCount, total: totalCount),
          const SizedBox(width: 16),
          _CursorPosition(line: line + 1, column: column + 1),
        ],
      ),
    );
  }
}

class _ModeIndicator extends StatelessWidget {
  const _ModeIndicator({required this.mode});

  final VimMode mode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final (color, bgColor) = switch (mode) {
      VimMode.normal => (
          isDark ? Colors.blue.shade200 : Theme.of(context).colorScheme.primary,
          isDark
              ? Colors.blue.shade900.withValues(alpha: 0.6)
              : Theme.of(context).colorScheme.primaryContainer,
        ),
      VimMode.insert => (
          isDark ? Colors.green.shade300 : Colors.green.shade700,
          isDark
              ? Colors.green.shade900.withValues(alpha: 0.6)
              : Colors.green.shade100,
        ),
      VimMode.visual => (
          isDark ? Colors.purple.shade300 : Colors.purple.shade700,
          isDark
              ? Colors.purple.shade900.withValues(alpha: 0.6)
              : Colors.purple.shade100,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        mode.displayName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: "monospace",
        ),
      ),
    );
  }
}

class _KeybindHints extends StatelessWidget {
  const _KeybindHints({
    this.onAccept,
    this.onReject,
    this.onConfirmAll,
    this.onCancel,
  });

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onConfirmAll;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KeyHint(keys: "⌘Y", action: "Accept", onTap: onAccept),
        const SizedBox(width: 12),
        _KeyHint(keys: "⌘N", action: "Reject", onTap: onReject),
        const SizedBox(width: 12),
        _KeyHint(keys: "Enter", action: "Confirm all", onTap: onConfirmAll),
        const SizedBox(width: 12),
        _KeyHint(keys: "Esc", action: "Cancel", onTap: onCancel),
      ],
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({
    required this.keys,
    required this.action,
    this.onTap,
  });

  final String keys;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                keys,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: "monospace",
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              action,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeCounter extends StatelessWidget {
  const _ChangeCounter({
    required this.pending,
    required this.total,
  });

  final int pending;
  final int total;

  @override
  Widget build(BuildContext context) {
    final resolved = total - pending;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          pending == 0 ? Icons.check_circle : Icons.pending,
          size: 16,
          color: pending == 0
              ? Colors.green.shade700
              : Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          "$resolved/$total changes",
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CursorPosition extends StatelessWidget {
  const _CursorPosition({
    required this.line,
    required this.column,
  });

  final int line;
  final int column;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Ln $line, Col $column",
      style: TextStyle(
        fontSize: 12,
        fontFamily: "monospace",
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
