import "dart:convert";
import "dart:io";

import "package:dio/dio.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/assistant/tools.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "assistant.freezed.dart";
part "assistant.g.dart";

/// High enough for real work (reading history, trying three variants,
/// fixing a rejected proposal); Esc stops it at any point.
const _maxSteps = 150;

const _system = """
You set up GrammarGuard, a tool that rewrites selected text with an AI model.
The setup has groups (instructions that replace each other, some with ordered
steps), instructions (a name and a short text for the rewrite model),
profiles (conditions on the app, title, URL, language, length or content,
plus instructions, a model, keep words and how to deliver; every matching
profile applies, top to bottom) and defaults (used everywhere).

Read before you change: read_setup first; current_context, read_history and
usage_stats when the user mentions their text, an app or their habits. Use
try_rewrite to test a new instruction on real examples before proposing it.
Every setup change you make is a proposal the user reviews; say briefly what
you proposed and why. Prefer changing an existing instruction over adding a
near duplicate. Instruction texts are one or two plain sentences.
If the user only wants something different for the current text, use
use_for_now or decide_changes instead of proposing. Answer in the user's
language.
""";

@freezed
abstract class Proposed with _$Proposed {
  const factory Proposed(ProposalItem item, {bool? keep}) = _Proposed;
}

@freezed
abstract class AssistantState with _$AssistantState {
  const factory AssistantState({
    /// Shown in place of the result while true.
    @Default(false) bool open,

    /// The conversation in llm_dart's own message types, tool calls included.
    @Default(<llm.ChatMessage>[]) List<llm.ChatMessage> messages,

    /// Pending items, reviewed with n, p, y, x and applied with Enter.
    @Default(<Proposed>[]) List<Proposed> proposal,
    @Default(0) int current,
    @Default(false) bool busy,

    /// The globe toggle. Off by default.
    @Default(false) bool webSearch,
    String? error,
  }) = _AssistantState;
}

@Riverpod(keepAlive: true)
class Assistant extends _$Assistant {
  CancelToken? _cancel;

  @override
  AssistantState build() => const AssistantState();

  /// From the bar (Tab, ? or the Ask row). Keeps an earlier conversation.
  Future<void> open(String message) async {
    state = state.copyWith(open: true);
    if (message.isNotEmpty) await send(message);
  }

  /// Esc: stops a running answer first, then closes.
  void close() {
    if (state.busy) {
      _cancel?.cancel();
      return;
    }
    state = state.copyWith(open: false);
  }

  void toggleSearch() => state = state.copyWith(webSearch: !state.webSearch);

  /// Starts over: new conversation, pending proposal dropped. A running
  /// answer stops and writes nothing into the new conversation.
  void reset() {
    _cancel?.cancel();
    state = AssistantState(open: state.open, webSearch: state.webSearch);
  }

  /// The agent loop on llm_dart: ask, run the tools it calls, feed the
  /// results back, until it answers in plain text.
  Future<void> send(String message) async {
    if (state.busy) return;
    final cancel = _cancel = CancelToken();
    state = state.copyWith(messages: [...state.messages, llm.ChatMessage.user(message)], busy: true, error: null);
    try {
      final library = (await ref.read(libraryStoreProvider.future)).library;
      final model = await _model(library);
      final connection = (await ref.read(connectionsProvider.future))[model.ref.backend]!;
      final chat = await ref
          .read(llmGatewayProvider)
          .chat(connection, model.ref, system: _system, webSearch: state.webSearch);
      final tools = {for (final t in assistantTools) t.name: t};

      for (var step = 0; step < _maxSteps && !cancel.isCancelled; step++) {
        final response = await chat.chatWithTools(state.messages, [
          for (final t in tools.values) t.definition,
        ], cancelToken: cancel);
        if (cancel.isCancelled) return;
        if (response.usage case final usage?) {
          await ref.read(usageTotalsProvider.notifier).add(usage, model.price?.cost(usage));
        }
        final calls = response.toolCalls ?? const <llm.ToolCall>[];
        final text = response.text ?? "";
        state = state.copyWith(
          messages: [
            ...state.messages,
            if (calls.isEmpty)
              llm.ChatMessage.assistant(text)
            else
              llm.ChatMessage.toolUse(toolCalls: calls, content: text),
          ],
        );
        if (calls.isEmpty) break;

        final results = <llm.ToolCall>[];
        for (final call in calls) {
          final outcome = await _runTool(tools[call.function.name], call, cancel);
          if (cancel.isCancelled) return;
          if (outcome.propose case final item?) _addToProposal(item);
          // llm_dart carries a tool result as a ToolCall whose arguments hold it.
          results.add(
            llm.ToolCall(
              id: call.id,
              callType: "function",
              function: llm.FunctionCall(name: call.function.name, arguments: outcome.result),
            ),
          );
        }
        state = state.copyWith(
          messages: [
            ...state.messages,
            llm.ChatMessage.toolResult(results: results),
          ],
        );
      }
    } on llm.CancelledError {
      // Esc or reset: a quiet stop, not an error.
    } on llm.LLMError catch (error) {
      if (!cancel.isCancelled) state = state.copyWith(error: error.message);
    } on DioException catch (error) {
      if (!CancelToken.isCancel(error)) state = state.copyWith(error: "The assistant failed: ${error.message}");
    } on Object catch (error) {
      if (!cancel.isCancelled) state = state.copyWith(error: "The assistant failed: $error");
    } finally {
      // After a reset a newer conversation may be running; leave it be.
      if (identical(_cancel, cancel)) state = state.copyWith(busy: false);
    }
  }

  /// Every tool call gets a result, even when the model sent bad arguments
  /// or the tool failed: a tool call without a result makes every later
  /// request fail on Anthropic.
  Future<ToolOutcome> _runTool(AssistantTool? tool, llm.ToolCall call, CancelToken cancel) async {
    if (tool == null) return ToolOutcome("Unknown tool ${call.function.name}.");
    try {
      final args = call.function.arguments.isEmpty ? const <String, Object?>{} : jsonDecodeMap(call.function.arguments);
      return await tool.run(ref, args, [for (final p in state.proposal) p.item], cancel);
    } on llm.CancelledError {
      rethrow;
    } on Object catch (error) {
      return ToolOutcome("Tool failed: $error. Check the arguments and try again.");
    }
  }

  // Proposal review: the same keys as reviewing a rewrite.
  void next() => state = state.copyWith(current: (state.current + 1).clamp(0, state.proposal.length - 1));
  void previous() => state = state.copyWith(current: (state.current - 1).clamp(0, state.proposal.length - 1));
  void keep() => _decide(keep: true);
  void drop() => _decide(keep: false);

  /// Enter: applies everything not dropped in one logged, undoable write.
  Future<void> apply() async {
    final kept = [
      for (final p in state.proposal)
        if (p.keep ?? true) p.item,
    ];
    if (kept.isEmpty) return;
    final store = ref.read(libraryStoreProvider.notifier);
    final restoring = [
      for (final item in kept)
        if (item case ProposedRestore(:final entry)) entry,
    ].lastOrNull;
    final changes = [
      for (final item in kept)
        if (item case ProposedChange(:final change)) change,
    ];
    try {
      // One write, so one undo reverts the restore and the changes together.
      await store.apply(changes, author: ChangeAuthor.assistant, restoring: restoring);
      state = state.copyWith(proposal: const [], current: 0);
    } on LibraryProblem catch (problem) {
      // Dropping one item can break another (a profile using a dropped
      // instruction). The whole apply is refused, so nothing was written.
      state = state.copyWith(error: problem.message);
    } on FileSystemException catch (error) {
      state = state.copyWith(error: "Not saved. ${error.message}: ${error.path}");
    }
  }

  void _decide({required bool keep}) {
    if (state.proposal.isEmpty) return;
    final proposal = [...state.proposal];
    proposal[state.current] = proposal[state.current].copyWith(keep: keep);
    state = state.copyWith(proposal: proposal);
    next();
  }

  /// A second proposal for the same instruction, profile or group replaces
  /// the first, so the review shows one line per thing.
  void _addToProposal(ProposalItem item) {
    String key(ProposalItem i) => switch (i) {
      ProposedChange(:final change) => change.key,
      ProposedRestore() => "restore",
    };
    state = state.copyWith(
      proposal: [
        for (final p in state.proposal)
          if (key(p.item) != key(item)) p,
        Proposed(item),
      ],
    );
  }

  /// The model chosen for the assistant in Settings. There is no automatic
  /// pick: the priciest model with tools can cost hundreds of dollars per
  /// million tokens (o1-pro), so the user chooses once.
  Future<ModelInfo> _model(Library library) async {
    final catalog = await ref.read(modelCatalogProvider.future);
    final chosen = catalog.where((m) => m.ref == library.assistantModel).firstOrNull;
    if (chosen != null) return chosen;
    throw llm.InvalidRequestError(
      library.assistantModel == null
          ? "Choose a model for the assistant in Settings, Models (Cmd or Ctrl+,)."
          : "The assistant's model ${library.assistantModel} is not available. "
                "Choose another in Settings, Models (Cmd or Ctrl+,).",
    );
  }
}

Map<String, Object?> jsonDecodeMap(String text) => (jsonDecode(text) as Map).cast<String, Object?>();
