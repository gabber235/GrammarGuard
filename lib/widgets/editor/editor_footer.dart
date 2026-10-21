import "package:flutter/material.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// The Vim editor's status line: mode, the keys that work, how many
/// suggestions are still open, and where the cursor is.
class EditorFooter extends ConsumerWidget {
  const EditorFooter({this.onAccept, this.onReject, this.onConfirmAll, this.onCancel, super.key});

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onConfirmAll;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(reviewProvider);
    if (editorState == null) return const SizedBox.shrink();

    final gg = context.gg;
    final vimState = editorState.vimState;
    final pending = editorState.getPendingChangeCount();
    final (line, column) = editorState.document.positionToLineColumn(vimState.cursorPosition);
    final quiet = TextStyle(fontSize: 13, color: gg.muted);

    return Row(
      children: [
        _ModeBadge(mode: vimState.mode),
        const SizedBox(width: 16),
        Expanded(
          child: KeyHints([
            KeyHint([primaryKey, "Y"], "keep", onTap: onAccept),
            KeyHint([primaryKey, "N"], "undo", onTap: onReject),
            KeyHint(const ["Enter"], "paste back", onTap: onConfirmAll),
            KeyHint(const ["Esc"], "back", onTap: onCancel),
          ]),
        ),
        Text(pending == 0 ? "All decided" : "$pending open", style: quiet),
        const SizedBox(width: 16),
        Text("Line ${line + 1}, column ${column + 1}", style: quiet.copyWith(fontFamily: "Atkinson Hyperlegible Mono")),
      ],
    );
  }
}

/// NORMAL, INSERT or VISUAL, each in its own theme color.
class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.mode});

  final VimMode mode;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final color = switch (mode) {
      VimMode.normal => gg.model,
      VimMode.insert => gg.added,
      VimMode.visual => gg.profile,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(GgTheme.smallRadius),
      ),
      child: Text(
        mode.displayName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
          fontFamily: "Atkinson Hyperlegible Mono",
        ),
      ),
    );
  }
}
