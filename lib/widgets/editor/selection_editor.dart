import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// The editor font: Atkinson Hyperlegible Mono, so the columns line up and
/// the letters stay as easy to tell apart as in the review.
const _mono = TextStyle(fontFamily: "Atkinson Hyperlegible Mono", fontSize: 15, height: 1.6);
const _lineHeight = 15 * 1.6;

class SelectionEditor extends HookConsumerWidget {
  const SelectionEditor({required this.showLineNumbers, this.onConfirm, this.onCancel, super.key});

  final bool showLineNumbers;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(reviewProvider);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

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
        final primaryModifier = defaultTargetPlatform == TargetPlatform.macOS ? meta : ctrl;
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
          ref.read(reviewProvider.notifier).keepAll();
          return KeyEventResult.handled;
        }

        if (primaryModifier && shift && key == LogicalKeyboardKey.keyN) {
          ref.read(reviewProvider.notifier).undoAll();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyY) {
          ref.read(reviewProvider.notifier).keep();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyN) {
          ref.read(reviewProvider.notifier).undo();
          return KeyEventResult.handled;
        }

        if (primaryModifier && key == LogicalKeyboardKey.keyZ) {
          if (shift) {
            ref.read(reviewProvider.notifier).redoLast();
          } else {
            ref.read(reviewProvider.notifier).undoLast();
          }
          return KeyEventResult.handled;
        }

        ref
            .read(reviewProvider.notifier)
            .handleKey(key, shift: shift, ctrl: ctrl, meta: meta, character: event.character);

        return KeyEventResult.handled;
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.gg.raised,
          borderRadius: BorderRadius.circular(GgTheme.radius),
          border: Border.all(color: context.gg.hairline),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers) _LineNumbers(lineCount: editorState.document.getLineCount()),
              Expanded(child: _EditorContent(state: editorState)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineNumbers extends StatelessWidget {
  const _LineNumbers({required this.lineCount});

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
            height: _lineHeight,
            child: Text("${index + 1}", style: _mono.copyWith(color: context.gg.pin)),
          );
        }),
      ),
    );
  }
}

class _EditorContent extends StatelessWidget {
  const _EditorContent({required this.state});

  final SelectionEditorState state;

  @override
  Widget build(BuildContext context) {
    final document = state.document;
    final vimState = state.vimState;
    final text = document.getText();

    return Text.rich(_buildTextSpan(context, document, vimState, text), style: _mono.copyWith(color: context.gg.ink));
  }

  TextSpan _buildTextSpan(BuildContext context, EditorDocument document, VimState vimState, String text) {
    final spans = <InlineSpan>[];
    var position = 0;

    for (final segment in document.segments) {
      switch (segment) {
        case TextSegment(:final text):
          spans.addAll(_buildTextSegmentSpans(context, text, position, vimState));
          position += text.length;
        case ChangeSegment(:final changeIndex):
          final change = document.pendingChanges[changeIndex];
          spans.addAll(_buildChangeSpans(context, change, position, vimState));
          position += change.totalDisplayLength;
      }
    }

    if (position == vimState.cursorPosition && position == text.length) {
      spans.add(_buildCursorSpan(context, vimState, " "));
    }

    return TextSpan(children: spans);
  }

  List<InlineSpan> _buildTextSegmentSpans(BuildContext context, String text, int startPosition, VimState vimState) {
    final spans = <InlineSpan>[];
    final cursorPos = vimState.cursorPosition;
    final visualStart = vimState.visualStart;
    final isVisual = vimState.mode == VimMode.visual;

    for (var i = 0; i < text.length; i++) {
      final globalPos = startPosition + i;
      final char = text[i];

      final isSelected = isVisual && visualStart != null && _isInSelection(globalPos, cursorPos, visualStart);

      if (globalPos == cursorPos) {
        spans.add(_buildCursorSpan(context, vimState, char));
      } else if (isSelected) {
        spans.add(
          TextSpan(
            text: char,
            style: TextStyle(backgroundColor: context.gg.current),
          ),
        );
      } else {
        spans.add(TextSpan(text: char));
      }
    }

    return spans;
  }

  List<InlineSpan> _buildChangeSpans(BuildContext context, PendingChange change, int startPosition, VimState vimState) {
    final spans = <InlineSpan>[];

    if (change.status == ChangeStatus.pending) {
      for (var i = 0; i < change.originalText.length; i++) {
        final globalPos = startPosition + i;
        final char = change.originalText[i];

        if (globalPos == vimState.cursorPosition) {
          spans.add(_buildCursorSpan(context, vimState, char, isDeleted: true));
        } else {
          spans.add(
            TextSpan(
              text: char,
              style: TextStyle(
                color: context.gg.removed,
                decoration: TextDecoration.lineThrough,
                decorationColor: context.gg.removed,
              ),
            ),
          );
        }
      }

      for (var i = 0; i < change.newText.length; i++) {
        final globalPos = startPosition + change.originalText.length + i;
        final char = change.newText[i];

        if (globalPos == vimState.cursorPosition) {
          spans.add(_buildCursorSpan(context, vimState, char, isInserted: true));
        } else {
          spans.add(
            TextSpan(
              text: char,
              style: TextStyle(color: context.gg.added, backgroundColor: context.gg.added.withValues(alpha: 0.12)),
            ),
          );
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
      final gg = context.gg;
      // The block cursor is the highlighter, like the current change.
      final bgColor = isDeleted
          ? gg.removed
          : isInserted
          ? gg.added
          : gg.highlighter;
      const fgColor = Color(0xFF1D2330);

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
            border: Border(left: BorderSide(color: context.gg.highlighter, width: 2)),
          ),
          child: Text(
            char,
            style: _mono.copyWith(
              color: isDeleted
                  ? context.gg.removed
                  : isInserted
                  ? context.gg.added
                  : context.gg.ink,
              decoration: isDeleted ? TextDecoration.lineThrough : null,
              backgroundColor: isInserted ? context.gg.added.withValues(alpha: 0.12) : null,
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
