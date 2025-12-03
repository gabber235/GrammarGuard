import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gpt_markdown/custom_widgets/markdown_config.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:grammar_guard/hooks/delayed_execution.dart";
import "package:grammar_guard/hooks/text_size.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:grammar_guard/state/ai_rewrite_result.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class TextDisplay extends HookConsumerWidget {
  const TextDisplay({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewriteAsync = ref.watch(aiRewriteProvider);

    return rewriteAsync.when(
      data: (result) {
        switch (result) {
          case LoadingResult(message: final message):
            return LoadingDisplay(message: message);
          case ErrorResult(message: final message):
            return ErrorDisplay(error: message);
          case TextResult():
            return TextDisplayWidget(scrollController: scrollController);
          case ThinkingTextResult(thinking: final thinking, text: final text):
            return ThinkingTextDisplay(
              showText: text.isNotEmpty,
              thinking: thinking,
              scrollController: scrollController,
            );
        }
      },
      loading: () => const LoadingDisplay(message: "Initializing Rewrite..."),
      error: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        return ErrorDisplay(error: error.toString());
      },
    );
  }
}

class ThinkingTextDisplay extends HookWidget {
  const ThinkingTextDisplay({
    required this.thinking,
    required this.scrollController,
    required this.showText,
    super.key,
  });

  final String thinking;
  final ScrollController scrollController;
  final bool showText;

  static const _unFocusedHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    final isHoveringThinking = useState(false);
    final highlightThinking = isHoveringThinking.value || !showText;
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;

          final thinkingHeight = showText
              ? isHoveringThinking.value
                  ? maxHeight - _unFocusedHeight
                  : _unFocusedHeight
              : maxHeight;

          final textHeight = showText ? maxHeight - thinkingHeight : 0.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: ElasticOutCurve(0.9),
                height: thinkingHeight,
                child: MouseRegion(
                  onEnter: (event) => isHoveringThinking.value = true,
                  onExit: (event) => isHoveringThinking.value = false,
                  child: ThinkingDisplay(
                    thinking: thinking,
                    maxHeight: thinkingHeight,
                    maxWidth: constraints.maxWidth,
                    expand: highlightThinking,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: ElasticOutCurve(0.9),
                height: textHeight,
                child: TextDisplayWidget(
                  scrollController: highlightThinking ? null : scrollController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LoadingDisplay extends StatelessWidget {
  const LoadingDisplay({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({required this.error, super.key});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 36,
            ),
            const SizedBox(height: 12),
            Text(
              "An Error Occurred",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class ThinkingDisplay extends HookWidget {
  const ThinkingDisplay({
    required this.thinking,
    required this.maxWidth,
    required this.maxHeight,
    this.expand = false,
    super.key,
  });

  final String thinking;
  final double maxWidth;
  final double maxHeight;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final text = Text(
      thinking.trim(),
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: Colors.white70),
      maxLines: expand ? null : 1,
      overflow: expand ? null : TextOverflow.ellipsis,
    );

    useDelayedExecution(
      () {
        if (!scrollController.hasClients) return;

        scrollController.jumpTo(
          scrollController.position.maxScrollExtent,
        );
        return;
      },
      [thinking, scrollController, expand],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRect(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(expand ? 16 : 8),
          child: OverflowBox(
            maxHeight: double.infinity,
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: expand ? maxHeight - 32 : null,
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.psychology_alt_outlined,
                        size: 16,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                      Text(
                        "Reasoning",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                  if (expand)
                    Flexible(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: text,
                      ),
                    )
                  else
                    text,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextDisplayWidget extends HookConsumerWidget {
  const TextDisplayWidget({required this.scrollController, super.key});
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renderingMode = ref.watch(renderingModeProvider);

    final display = renderingMode == RenderingModeOption.markdown
        ? const MarkdownDisplay()
        : const RawDisplay();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: scrollController != null
          ? SingleChildScrollView(
              controller: scrollController,
              child: display,
            )
          : SizedBox(
              height: 50,
              child: display,
            ),
    );
  }
}

class MarkdownDisplay extends HookConsumerWidget {
  const MarkdownDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffString = ref.watch(diffStringProvider);
    return GptMarkdown(
      diffString,
      components: [
        ...MarkdownComponent.globalComponents,
        InsertMd(),
        DeleteMd(),
      ],
      inlineComponents: [
        ...MarkdownComponent.inlineComponents,
        InsertMd(),
        DeleteMd(),
      ],
    );
  }
}

class RawDisplay extends HookConsumerWidget {
  const RawDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffs = ref.watch(diffsProvider);

    final spans = <TextSpan>[];
    for (final diff in diffs) {
      switch (diff.operation) {
        case DIFF_INSERT:
          spans.add(
            TextSpan(
              text: diff.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.tertiary.withValues(alpha: 0.3),
              ),
            ),
          );
        case DIFF_DELETE:
          spans.add(
            TextSpan(
              text: diff.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                backgroundColor:
                    Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                decoration: TextDecoration.lineThrough,
                decorationColor: Theme.of(context).colorScheme.error,
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
          );
        case DIFF_EQUAL:
          spans.add(TextSpan(text: diff.text));
      }
    }

    return SelectableText.rich(TextSpan(children: spans));
  }
}

abstract class DiffMd extends InlineMd {
  @override
  bool get inline => false;

  String get tag;

  @override
  RegExp get exp => RegExp("<$tag>(.*?)</$tag>", multiLine: true, dotAll: true);

  TextStyle style(BuildContext context);

  @override
  InlineSpan span(
    BuildContext context,
    String text,
    GptMarkdownConfig config,
  ) {
    final childText = exp.firstMatch(text)?.group(1) ?? "";
    final children = MarkdownComponent.generate(
      context,
      childText,
      config,
      true,
    );
    final inheritStyle = config.style ?? const TextStyle();
    return TextSpan(
      children: children,
      style: inheritStyle.merge(style(context)),
    );
  }
}

class InsertMd extends DiffMd {
  @override
  String get tag => "insert";

  @override
  TextStyle style(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
        backgroundColor:
            Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3),
      );
}

class DeleteMd extends DiffMd {
  @override
  String get tag => "delete";

  @override
  TextStyle style(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.error,
        backgroundColor:
            Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        decoration: TextDecoration.lineThrough,
        decorationColor: Theme.of(context).colorScheme.error,
        decorationStyle: TextDecorationStyle.solid,
      );
}
