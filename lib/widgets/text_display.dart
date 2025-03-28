import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:gpt_markdown/custom_widgets/markdown_config.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:grammar_guard/models/rendering_mode.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class TextDisplay extends HookConsumerWidget {
  const TextDisplay({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewrite = ref.watch(aiRewriteProvider);

    return rewrite.when(
      data: (_) => TextDisplayWidget(scrollController: scrollController),
      loading:
          () => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
      error: (error, stackTrace) => Text("Error: $error"),
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
        child:
            renderingMode == RenderingModeOption.markdown
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
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.3),
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

    return Text.rich(TextSpan(children: spans));
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
  InlineSpan span(BuildContext context, String text, GptMarkdownConfig config) {
    final childText = exp.firstMatch(text)?.group(1) ?? "";
    final children = MarkdownComponent.generate(
      context,
      childText,
      config,
      true,
    );
    final inheritStyle = config.style ?? TextStyle();
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
    backgroundColor: Theme.of(
      context,
    ).colorScheme.tertiary.withValues(alpha: 0.3),
  );
}

class DeleteMd extends DiffMd {
  @override
  String get tag => "delete";

  @override
  TextStyle style(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.error,
    backgroundColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
    decoration: TextDecoration.lineThrough,
    decorationColor: Theme.of(context).colorScheme.error,
    decorationStyle: TextDecorationStyle.solid,
  );
}
