import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/assistant/tools.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:url_launcher/url_launcher.dart";

/// The conversation and its proposal. Two focus spots, one meaning per key:
/// on the proposal n p y x Enter review it like a rewrite; Tab goes to the
/// reply field; Esc stops a running answer, then goes back (reply field,
/// then proposal, then closed). Slides in over the result from the right.
class AssistantView extends HookConsumerWidget {
  const AssistantView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assistantProvider);
    final assistant = ref.read(assistantProvider.notifier);
    final reply = useTextEditingController();
    final replyFocus = useFocusNode();
    final reviewFocus = useFocusNode();
    final hasProposal = state.proposal.isNotEmpty;

    useEffect(() {
      (hasProposal ? reviewFocus : replyFocus).requestFocus();
      return null;
    }, [hasProposal]);

    final gg = context.gg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, size: 18, color: gg.highlighter),
            const SizedBox(width: 8),
            Text("Assistant", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 10),
            Text("changes your setup, never your text", style: Theme.of(context).textTheme.bodySmall),
            const Spacer(),
            IconButton(
              tooltip: "Web search with the model's own search (max 3 per message, about 1 cent each). fetch_url always works.",
              isSelected: state.webSearch,
              selectedIcon: Icon(Icons.public, color: gg.highlighter),
              icon: const Icon(Icons.public),
              onPressed: assistant.toggleSearch,
            ),
            IconButton(tooltip: "New conversation", icon: const Icon(Icons.refresh), onPressed: assistant.reset),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              if (state.busy) const _Working(),
              for (final message in state.messages.reversed)
                switch ((message.role, message.messageType)) {
                  (_, llm.ToolUseMessage(:final toolCalls)) => _ToolLine(
                    names: [for (final c in toolCalls) c.function.name],
                  ),
                  (_, llm.ToolResultMessage()) => const SizedBox.shrink(),
                  (llm.ChatRole.user, _) => _Mine(text: message.content),
                  _ when message.content.isEmpty => const SizedBox.shrink(),
                  _ => _Answer(text: message.content).appear(context),
                },
            ],
          ),
        ),
        if (state.error case final error?)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 18, color: gg.removed),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(error, style: TextStyle(color: gg.removed)),
                ),
              ],
            ),
          ),
        if (hasProposal)
          CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.keyN): assistant.next,
              const SingleActivator(LogicalKeyboardKey.keyP): assistant.previous,
              const SingleActivator(LogicalKeyboardKey.keyY): assistant.keep,
              const SingleActivator(LogicalKeyboardKey.keyX): assistant.drop,
              const SingleActivator(LogicalKeyboardKey.enter): assistant.apply,
              const SingleActivator(LogicalKeyboardKey.tab): replyFocus.requestFocus,
              const SingleActivator(LogicalKeyboardKey.escape): assistant.close,
            },
            child: Focus(
              focusNode: reviewFocus,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ProposalCard(state: state, library: ref.watch(libraryStoreProvider).value?.library),
              ),
            ),
          ),
        CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.escape): () =>
                hasProposal ? reviewFocus.requestFocus() : assistant.close(),
          },
          child: TextField(
            controller: reply,
            focusNode: replyFocus,
            enabled: !state.busy,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hasProposal ? "Reply to change the proposal…" : "Ask or reply…",
              suffixIcon: const Padding(padding: EdgeInsets.all(10), child: KeyCap("Enter")),
              suffixIconConstraints: const BoxConstraints(),
            ),
            onSubmitted: (text) {
              if (text.trim().isEmpty) return;
              reply.clear();
              assistant.send(text.trim());
            },
          ),
        ),
      ],
    );
  }
}

/// What the assistant wants to change, reviewed like a rewrite: the pill
/// marks the current line, y and x keep or drop it, Enter applies.
class _ProposalCard extends StatelessWidget {
  const _ProposalCard({required this.state, required this.library});
  final AssistantState state;

  /// The saved setup, to tell new things from changed ones.
  final Library? library;

  @override
  Widget build(BuildContext context) {
    final count = state.proposal.length;
    return Panel(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                Text(
                  count == 1 ? "1 change to your setup" : "$count changes to your setup",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 10),
                Text("Nothing is saved until you press Enter", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          for (final (i, p) in state.proposal.indexed)
            PillRow(
              key: ValueKey(i),
              current: i == state.current,
              child: _ProposalLine(
                item: p.item,
                dropped: p.keep == false,
                adds: switch ((library, p.item)) {
                  (final library?, ProposedChange(:final change)) => addsTo(library, change),
                  _ => true,
                },
              ),
            ).stagger(context, i), // proposal lines stack in
        ],
      ),
    );
  }
}

class _ProposalLine extends StatelessWidget {
  const _ProposalLine({required this.item, required this.dropped, required this.adds});

  final ProposalItem item;
  final bool dropped;

  /// False when the change replaces something already in the setup.
  final bool adds;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final (icon, color) = switch (item) {
      ProposedChange(change: RemoveInstruction() || RemoveProfile() || RemoveGroup()) => (Icons.remove, gg.removed),
      ProposedRestore() => (Icons.history, gg.model),
      ProposedChange() when !adds => (Icons.edit, gg.added),
      ProposedChange() => (Icons.add, gg.added),
    };
    final detail = switch (item) {
      ProposedChange(change: PutInstruction(:final instruction)) => instruction.text,
      ProposedChange(change: PutProfile(:final profile)) => [
        ...profile.use.map((id) => id.value),
        if (profile.model != null) "model ${profile.model}",
        if (profile.deliver != null) "delivers ${profile.deliver!.name}",
      ].join(", "),
      _ => null,
    };
    final strike = dropped ? TextDecoration.lineThrough : null;
    return Opacity(
      opacity: dropped ? 0.5 : 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1, right: 12),
            width: 22,
            height: 22,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 16, color: color),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(switch (item) {
                  ProposedChange(:final change) => _title(change),
                  ProposedRestore(:final entry) => "Restore the setup from before: ${entry.summary.join(", ")}",
                }, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, decoration: strike)),
                if (detail != null && detail.isNotEmpty)
                  Text(
                    detail,
                    style: TextStyle(fontSize: 13, color: gg.muted, decoration: strike),
                  ),
              ],
            ),
          ),
          if (dropped) Text("dropped", style: TextStyle(fontSize: 12, color: gg.muted)),
        ],
      ),
    );
  }

  String _title(LibraryChange change) {
    final verb = adds ? "New" : "Change";
    return switch (change) {
      PutInstruction(:final instruction) => "$verb instruction ${instruction.name}",
      PutProfile(:final profile) => "$verb profile ${profile.name}",
      PutGroup(:final group) => "$verb group ${group.name}",
      _ => change.summary,
    };
  }
}

/// Your message: a tinted bubble on the right.
class _Mine extends StatelessWidget {
  const _Mine({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 120, top: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: gg.profile.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(GgTheme.radius),
        ),
        child: SelectableText(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

/// The assistant's answer: Markdown at reading width, no bubble, so long
/// answers read like a note rather than a chat. Web links open in the
/// browser. Images are left out: the answer can echo text the assistant read
/// from a selection or a page, and loading an image URL would send data out
/// without a click.
class _Answer extends StatelessWidget {
  const _Answer({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 120, top: 6, bottom: 6),
    child: SelectionArea(
      child: GptMarkdown(
        text,
        style: TextStyle(fontSize: 16, height: 1.5, color: context.gg.ink),
        onLinkTap: (url, _) {
          final uri = Uri.tryParse(url);
          if (uri != null && (uri.scheme == "https" || uri.scheme == "http")) launchUrl(uri);
        },
        imageBuilder: (_, _, _, _) => const SizedBox.shrink(),
      ),
    ),
  );
}

/// The tools it used, in one quiet line: "Read setup · Put profile".
class _ToolLine extends StatelessWidget {
  const _ToolLine({required this.names});
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    String label(String name) {
      final words = name.replaceAll("_", " ");
      return words[0].toUpperCase() + words.substring(1);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.build_outlined, size: 14, color: gg.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(names.map(label).join(" · "), style: TextStyle(fontSize: 13, color: gg.muted)),
          ),
        ],
      ),
    );
  }
}

/// While it works: a thin bar and one muted line.
class _Working extends StatelessWidget {
  const _Working();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        const SizedBox(width: 60, child: LinearProgressIndicator()),
        const SizedBox(width: 12),
        Text("Working…", style: TextStyle(fontSize: 13, color: context.gg.muted)),
      ],
    ),
  );
}
