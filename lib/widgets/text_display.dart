import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:gpt_markdown/custom_widgets/markdown_config.dart";
import "package:gpt_markdown/gpt_markdown.dart";
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
            if (text.isEmpty) {
              return ThinkingDisplay(thinking: thinking);
            }
            return Column(
              children: [
                ThinkingDisplay(thinking: thinking),
                Expanded(
                  child: TextDisplayWidget(scrollController: scrollController),
                ),
              ],
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

class ThinkingDisplay extends StatelessWidget {
  const ThinkingDisplay({required this.thinking, super.key});

  final String thinking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              thinking,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class TextDisplayWidget extends HookConsumerWidget {
  const TextDisplayWidget({required this.scrollController, super.key});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final renderingMode = ref.watch(renderingModeProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: renderingMode == RenderingModeOption.markdown
            ? const MarkdownDisplay()
            : const RawDisplay(),
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
      components: [...MarkdownComponent.components, InsertMd(), DeleteMd()],
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
