import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/config/desktop_window.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SelectionEditor extends HookConsumerWidget {
  const SelectionEditor({
    required this.showLineNumbers,
    this.onConfirm,
    this.onCancel,
    super.key,
  });

  final bool showLineNumbers;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(selectionEditorProvider);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, [],);

    if (editorState == null) {
      return const Center(child: Text("No document loaded"));
    }

    return Focus(
      focusNode: focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }

        final key = event.logicalKey;
        final shift = HardwareKeyboard.instance.isShiftPressed;
        final ctrl = HardwareKeyboard.instance.isControlPressed;
        final meta = HardwareKeyboard.instance.isMetaPressed;
        final primaryModifier = usesPaletteWindow ? meta : ctrl;
        final vimMode = editorState.vimState.mode;
        final isNormalMode = vimMode == VimMode.normal;

        if (key == LogicalKeyboardKey.enter && isNormalMode) {
          onConfirm?.call();
          return KeyEventResult.handled;
        }

        if (key == LogicalKeyboardKey.escape && isNormalMode) {
          onCancel?.call();
          return KeyEventResult.handled;
        }

        if (primaryModifier && shift && key == LogicalKeyboardKey.keyY) {
          ref.read(selectionEditorProvider.notifier).acceptAll();
          return KeyEventResult.handled;
        }

        if (primaryModifier && shift && key == LogicalKeyboardKey.keyN) {
          ref.read(selectionEditorProvider.notifier).rejectAll();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyY) {
          ref.read(selectionEditorProvider.notifier).acceptCurrentChange();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyN) {
          ref.read(selectionEditorProvider.notifier).rejectCurrentChange();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyZ) {
          if (shift) {
            ref.read(selectionEditorProvider.notifier).redo();
          } else {
            ref.read(selectionEditorProvider.notifier).undo();
          }
          return KeyEventResult.handled;
        }

        ref.read(selectionEditorProvider.notifier).handleKey(
              key,
              shift: shift,
              ctrl: ctrl,
              meta: meta,
            );

        return KeyEventResult.handled;
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers)
                _LineNumbers(
                  lineCount: editorState.document.getLineCount(),
                ),
              Expanded(
                child: _EditorContent(
                  state: editorState,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineNumbers extends StatelessWidget {
  const _LineNumbers({
    required this.lineCount,
  });

  final int lineCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(lineCount, (index) {
          return SizedBox(
            height: 21,
            child: Text(
              "${index + 1}",
              style: TextStyle(
                fontFamily: "monospace",
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _EditorContent extends StatelessWidget {
  const _EditorContent({
    required this.state,
  });

  final SelectionEditorState state;

  @override
  Widget build(BuildContext context) {
    final document = state.document;
    final vimState = state.vimState;
    final text = document.getText();

    return Text.rich(
      _buildTextSpan(context, document, vimState, text),
      style: const TextStyle(
        fontFamily: "monospace",
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  TextSpan _buildTextSpan(
    BuildContext context,
    EditorDocument document,
    VimState vimState,
    String text,
  ) {
    final spans = <InlineSpan>[];
    var position = 0;

    for (final segment in document.segments) {
      if (segment.isText) {
        spans.addAll(_buildTextSegmentSpans(
          context,
          segment.text,
          position,
          vimState,
        ),);
        position += segment.text.length;
      } else if (segment.isChange) {
        final change = document.pendingChanges[segment.changeIndex!];
        spans.addAll(_buildChangeSpans(
          context,
          change,
          position,
          vimState,
        ),);
        position += change.totalDisplayLength;
      }
    }

    if (position == vimState.cursorPosition && position == text.length) {
      spans.add(_buildCursorSpan(context, vimState, " "));
    }

    return TextSpan(children: spans);
  }

  List<InlineSpan> _buildTextSegmentSpans(
    BuildContext context,
    String text,
    int startPosition,
    VimState vimState,
  ) {
    final spans = <InlineSpan>[];
    final cursorPos = vimState.cursorPosition;
    final visualStart = vimState.visualStart;
    final isVisual = vimState.mode == VimMode.visual;

    for (var i = 0; i < text.length; i++) {
      final globalPos = startPosition + i;
      final char = text[i];

      final isSelected = isVisual &&
          visualStart != null &&
          _isInSelection(globalPos, cursorPos, visualStart);

      if (globalPos == cursorPos) {
        spans.add(_buildCursorSpan(context, vimState, char));
      } else if (isSelected) {
        spans.add(TextSpan(
          text: char,
          style: TextStyle(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),);
      } else {
        spans.add(TextSpan(text: char));
      }
    }

    return spans;
  }

  List<InlineSpan> _buildChangeSpans(
    BuildContext context,
    PendingChange change,
    int startPosition,
    VimState vimState,
  ) {
    final spans = <InlineSpan>[];

    if (change.status == ChangeStatus.pending) {
      for (var i = 0; i < change.originalText.length; i++) {
        final globalPos = startPosition + i;
        final char = change.originalText[i];

        if (globalPos == vimState.cursorPosition) {
          spans.add(_buildCursorSpan(
            context,
            vimState,
            char,
            isDeleted: true,
          ),);
        } else {
          spans.add(TextSpan(
            text: char,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              decoration: TextDecoration.lineThrough,
              decorationColor: Theme.of(context).colorScheme.error,
            ),
          ),);
        }
      }

      for (var i = 0; i < change.newText.length; i++) {
        final globalPos = startPosition + change.originalText.length + i;
        final char = change.newText[i];

        if (globalPos == vimState.cursorPosition) {
          spans.add(_buildCursorSpan(
            context,
            vimState,
            char,
            isInserted: true,
          ),);
        } else {
          spans.add(TextSpan(
            text: char,
            style: TextStyle(
              color: Colors.green.shade700,
              backgroundColor: Colors.green.withValues(alpha: 0.1),
            ),
          ),);
        }
      }
    } else {
      final resultText = change.resultText ?? "";
      for (var i = 0; i < resultText.length; i++) {
        final globalPos = startPosition + i;
        final char = resultText[i];

        if (globalPos == vimState.cursorPosition) {
          spans.add(_buildCursorSpan(context, vimState, char));
        } else {
          spans.add(TextSpan(text: char));
        }
      }
    }

    return spans;
  }

  InlineSpan _buildCursorSpan(
    BuildContext context,
    VimState vimState,
    String char, {
    bool isDeleted = false,
    bool isInserted = false,
  }) {
    final isBlock = vimState.mode != VimMode.insert;

    if (isBlock) {
      var bgColor = Theme.of(context).colorScheme.primary;
      var fgColor = Theme.of(context).colorScheme.onPrimary;

      if (isDeleted) {
        bgColor = Theme.of(context).colorScheme.error;
        fgColor = Theme.of(context).colorScheme.onError;
      } else if (isInserted) {
        bgColor = Colors.green.shade700;
        fgColor = Colors.white;
      }

      return TextSpan(
        text: char == "\n" ? " \n" : char,
        style: TextStyle(
          backgroundColor: bgColor,
          color: fgColor,
          decoration: isDeleted ? TextDecoration.lineThrough : null,
        ),
      );
    } else {
      return WidgetSpan(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
          ),
          child: Text(
            char,
            style: TextStyle(
              fontFamily: "monospace",
              fontSize: 14,
              color: isDeleted
                  ? Theme.of(context).colorScheme.error
                  : isInserted
                      ? Colors.green.shade700
                      : null,
              decoration: isDeleted ? TextDecoration.lineThrough : null,
              backgroundColor:
                  isInserted ? Colors.green.withValues(alpha: 0.1) : null,
            ),
          ),
        ),
      );
    }
  }

  bool _isInSelection(int position, int cursorPos, int visualStart) {
    final start = visualStart < cursorPos ? visualStart : cursorPos;
    final end = visualStart < cursorPos ? cursorPos : visualStart;
    return position >= start && position <= end;
  }
}
