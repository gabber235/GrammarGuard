// Everything the assistant can see and do.
// Reads and tests run freely; setup edits only ever become proposals.
import "dart:convert";

import "package:collection/collection.dart";
import "package:dio/dio.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/instructions/prompt.dart";
import "package:grammar_guard/instructions/resolve.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/review/explain.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/review/word_diff.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/rewrite/text_edges.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:grammar_guard/session/session.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:yaml/yaml.dart";

part "tools.freezed.dart";

/// One item in a proposal: a setup change, or going back to an earlier setup.
@freezed
sealed class ProposalItem with _$ProposalItem {
  const factory ProposalItem.change(LibraryChange change) = ProposedChange;
  const factory ProposalItem.restore(ChangeLogEntry entry) = ProposedRestore;
}

/// What a tool call produced: text for the model, and maybe a proposal item.
@freezed
abstract class ToolOutcome with _$ToolOutcome {
  const factory ToolOutcome(String result, {ProposalItem? propose}) = _ToolOutcome;
}

/// A tool: its llm_dart definition plus what it does. New capabilities are
/// one more entry in [assistantTools].
class AssistantTool {
  const AssistantTool(this.name, this.description, this.run, {this.parameters = const {}, this.required = const []});

  final String name;
  final String description;
  final Map<String, llm.ParameterProperty> parameters;
  final List<String> required;

  /// [proposal] is everything proposed so far in this conversation, so new
  /// proposals are validated on top of it. [cancel] is the conversation's
  /// token: Esc stops tools that call a model too.
  final Future<ToolOutcome> Function(
    Ref ref,
    Map<String, Object?> args,
    List<ProposalItem> proposal,
    CancelToken cancel,
  )
  run;

  llm.Tool get definition => llm.Tool.function(
    name: name,
    description: description,
    parameters: llm.ParametersSchema(schemaType: "object", properties: parameters, required: required),
  );
}

const _text = llm.ParameterProperty(propertyType: "string", description: "");
llm.ParameterProperty _s(String d) => llm.ParameterProperty(propertyType: "string", description: d);
llm.ParameterProperty _n(String d) => llm.ParameterProperty(propertyType: "integer", description: d);
llm.ParameterProperty _list(String d) => llm.ParameterProperty(propertyType: "array", description: d, items: _text);

ToolOutcome _json(Object value) => ToolOutcome(jsonEncode(value));

Future<Library> _library(Ref ref) async => (await ref.read(libraryStoreProvider.future)).library;

/// Applies [item] on top of the proposal so far and validates the result,
/// so a mistake goes back to the model instead of to the user.
Future<ToolOutcome> _propose(Ref ref, List<ProposalItem> proposal, LibraryChange change) async {
  try {
    applyChanges(await _library(ref), [
      for (final p in proposal)
        if (p case ProposedChange(:final change)) change,
      change,
    ]);
    return ToolOutcome(
      "Proposed: ${change.summary}. The user reviews it before anything is saved.",
      propose: ProposalItem.change(change),
    );
  } on LibraryProblem catch (problem) {
    return ToolOutcome("Not proposed: ${problem.message} Fix it and try again.");
  }
}

ModelRef? _model(List<ModelInfo> models, Object? value) {
  final ref = value is String ? ModelRef.tryParse(value) : null;
  return models.any((m) => m.ref == ref) ? ref : null;
}

final assistantTools = <AssistantTool>[
  // ---- Read ----
  AssistantTool("read_setup", "The whole setup as library.yaml text, including what is proposed so far.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final file = await ref.read(libraryFileProvider.future);
    return ToolOutcome(await file.readAsString());
  }),
  AssistantTool("list_models", "Models the user can use, with price per million tokens and whether web search works.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final models = await ref.read(modelCatalogProvider.future);
    return _json([
      for (final m in models)
        {
          "ref": m.ref.toString(),
          "label": m.label,
          "in": m.price?.inputPerMillion,
          "out": m.price?.outputPerMillion,
          "search": m.ref.backend.canSearch,
        },
    ]);
  }),
  AssistantTool(
    "current_context",
    "The app the user came from (id, name, window title, browser URL), the profiles that matched, the text, its language and length, and the current result.",
    (ref, args, proposal, cancel) async {
      final session = ref.read(sessionProvider);
      final resolved = ref.read(resolvedProvider);
      final run = ref.read(currentRunProvider)?.value;
      final source = session.input?.source;
      return _json({
        "app": source?.name,
        "app_id": source?.id,
        "title": source?.windowTitle,
        "url": source?.url?.toString(),
        "profiles": [for (final p in resolved?.profiles ?? const <Profile>[]) p.name],
        "active": [for (final a in resolved?.active ?? const <ActiveInstruction>[]) a.instruction.id.value],
        "language": resolved?.signals.language,
        "words": resolved?.signals.words,
        "contains": [for (final c in resolved?.signals.contains ?? const <Object>{}) c.toString()],
        "text": session.input?.text,
        "result": run is Done ? run.text : null,
      });
    },
  ),
  AssistantTool(
    "read_history",
    "Recent delivered rewrites, newest first: app, profiles, instructions, what the user picked, typed requests, and which suggested edits they kept or undid.",
    parameters: {
      "app_id": _s("Only this app."),
      "query": _s("Only entries whose text contains this."),
      "limit": _n("At most 100."),
    },
    (ref, args, proposal, cancel) async {
      final app = args["app_id"] as String?;
      final query = (args["query"] as String?)?.toLowerCase();
      final limit = ((args["limit"] as num?)?.toInt() ?? 20).clamp(1, 100);
      final history = await ref.read(historyProvider.future);
      return _json([
        for (final e
            in history
                .where((e) => app == null || e.appId == app)
                .where(
                  (e) =>
                      query == null || e.input.toLowerCase().contains(query) || e.output.toLowerCase().contains(query),
                )
                .take(limit))
          {
            "at": e.at.toIso8601String(),
            "app": e.app,
            "profiles": e.profiles,
            "instructions": e.instructions,
            "picked": e.picked,
            "words": e.words,
            "input": e.input,
            "output": e.output,
            "kept": [
              for (final d in e.decisions)
                if (d.kept) "${d.before} -> ${d.after}",
            ],
            "undone": [
              for (final d in e.decisions)
                if (!d.kept) "${d.before} -> ${d.after}",
            ],
          },
      ]);
    },
  ),
  AssistantTool("usage_stats", "Rewrites, cost and most used instructions per app and per model, from history.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final history = await ref.read(historyProvider.future);
    Map<String, Object> summary(Iterable<HistoryEntry> entries) => {
      "rewrites": entries.length,
      "cost": entries.fold<double>(0, (sum, e) => sum + (e.cost ?? 0)),
      "top_picks":
          (entries.expand((e) => e.picked).groupFoldBy<String, int>((id) => id, (n, _) => (n ?? 0) + 1).entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value)))
              .take(5)
              .map((e) => e.key)
              .toList(),
    };
    return _json({
      "per_app": {
        for (final MapEntry(:key, :value) in history.groupListsBy((e) => e.app ?? "Clipboard").entries)
          key: summary(value),
      },
      "per_model": {
        for (final MapEntry(:key, :value) in history.groupListsBy((e) => e.model ?? "unknown").entries)
          key: summary(value),
      },
    });
  }),
  AssistantTool("list_apps", "Apps the user rewrote text in, with the ids profiles match on.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final history = await ref.read(historyProvider.future);
    return _json({
      for (final e in history)
        if (e.appId != null) e.appId!: e.app,
    });
  }),
  AssistantTool("read_change_log", "Earlier setup changes, newest first, with who made them.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final log = await ref.read(changeLogProvider.future);
    return _json([
      for (final (i, e) in log.take(30).indexed)
        {"index": i, "at": e.at.toIso8601String(), "by": e.author.name, "summary": e.summary},
    ]);
  }),

  // ---- Propose setup changes (validated, reviewed by the user) ----
  AssistantTool(
    "put_instruction",
    "Propose adding or changing an instruction. Reuse an existing id to change it.",
    parameters: {
      "id": _s("Lowercase words joined by hyphens."),
      "name": _s("Short name, shown in the bar."),
      "text": _s("What the rewrite model is told. One or two plain sentences."),
      "group": _s("Group id, such as edit, tone, format."),
      "excludes": _list("Instruction ids that cannot be on together with this one."),
    },
    required: ["id", "name", "text"],
    (ref, args, proposal, cancel) async {
      final library = await _library(ref);
      final id = InstructionId(args["id"]! as String);
      return _propose(
        ref,
        proposal,
        LibraryChange.putInstruction(
          Instruction(
            id: id,
            name: args["name"]! as String,
            text: args["text"]! as String,
            group: args["group"] is String ? GroupId(args["group"]! as String) : null,
            excludes: {for (final e in (args["excludes"] as List?) ?? const []) InstructionId(e as String)},
            pin: library[id]?.pin, // pins stay the user's choice
          ),
        ),
      );
    },
  ),
  AssistantTool(
    "put_profile",
    "Propose adding or changing a profile. All matching profiles apply, top to bottom. Set at least one condition.",
    parameters: {
      "name": _text,
      "apps": _list("App ids from current_context or list_apps."),
      "title": _s("Regex on the window title."),
      "url": _s("Regex on the browser URL."),
      "languages": _list("ISO 639-1 codes, such as nl."),
      "min_words": _n("Only texts with at least this many words."),
      "max_words": _n("Only texts with at most this many words."),
      "contains": _list("Any of code, markdown, latex, link, list."),
      "use": _list("Instruction ids, existing or proposed."),
      "model": _s("backend/id from list_models."),
      "keep_words": _list("Words to never change in this profile."),
      "deliver": _s("paste, paste_rich or copy."),
    },
    required: ["name", "use"],
    (ref, args, proposal, cancel) async {
      final models = await ref.read(modelCatalogProvider.future);
      if (args["model"] != null && _model(models, args["model"]) == null) {
        return ToolOutcome("Not proposed: ${args["model"]} is not in list_models.");
      }
      List<String> list(String key) => ((args[key] as List?) ?? const []).cast<String>();
      final yaml = {
        "name": args["name"],
        "when": {
          "apps": list("apps"),
          if (args["title"] != null) "title": args["title"],
          if (args["url"] != null) "url": args["url"],
          "languages": list("languages"),
          if (args["min_words"] != null) "min_words": args["min_words"],
          if (args["max_words"] != null) "max_words": args["max_words"],
          "contains": list("contains"),
        },
        "use": list("use"),
        if (args["model"] != null) "model": args["model"],
        "keep_words": list("keep_words"),
        if (args["deliver"] != null) "deliver": args["deliver"],
      };
      try {
        // Reuses the file reader, so the assistant can never write a shape
        // the file could not hold.
        return await _propose(ref, proposal, LibraryChange.putProfile(profileFromYaml(_toYaml(yaml))));
      } on LibraryProblem catch (problem) {
        return ToolOutcome("Not proposed: ${problem.message}");
      } on FormatException catch (error) {
        return ToolOutcome("Not proposed: bad regex. ${error.message}");
      }
    },
  ),
  AssistantTool(
    "put_group",
    "Propose adding or changing a group of instructions.",
    parameters: {
      "id": _text,
      "name": _text,
      "pick": _s("one or many."),
      "steps": llm.ParameterProperty(propertyType: "boolean", description: "Members are ordered levels."),
    },
    required: ["id", "name"],
    (ref, args, proposal, cancel) async {
      return _propose(
        ref,
        proposal,
        LibraryChange.putGroup(
          Group(
            id: GroupId(args["id"]! as String),
            name: args["name"]! as String,
            pick: args["pick"] == "many" ? Pick.many : Pick.one,
            steps: args["steps"] == true,
          ),
        ),
      );
    },
  ),
  AssistantTool(
    "remove_instruction",
    "Propose removing an instruction everywhere.",
    parameters: {"id": _text},
    required: ["id"],
    (ref, args, proposal, cancel) =>
        _propose(ref, proposal, LibraryChange.removeInstruction(InstructionId(args["id"]! as String))),
  ),
  AssistantTool(
    "remove_profile",
    "Propose removing a profile.",
    parameters: {"name": _text},
    required: ["name"],
    (ref, args, proposal, cancel) => _propose(ref, proposal, LibraryChange.removeProfile(args["name"]! as String)),
  ),
  AssistantTool(
    "remove_group",
    "Propose removing a group; its instructions stay.",
    parameters: {"id": _text},
    required: ["id"],
    (ref, args, proposal, cancel) => _propose(ref, proposal, LibraryChange.removeGroup(GroupId(args["id"]! as String))),
  ),
  AssistantTool(
    "set_defaults",
    "Propose what applies everywhere: default instructions, models and keep words.",
    parameters: {
      "use": _list("Instruction ids."),
      "model": _s("backend/id."),
      "assistant_model": _s("backend/id, must support tools."),
      "keep_words": _list(""),
    },
    (ref, args, proposal, cancel) async {
      final models = await ref.read(modelCatalogProvider.future);
      return _propose(
        ref,
        proposal,
        LibraryChange.setDefaults(
          use: (args["use"] as List?)?.map((id) => InstructionId(id as String)).toList(),
          model: _model(models, args["model"]),
          assistantModel: _model(models, args["assistant_model"]),
          keepWords: (args["keep_words"] as List?)?.cast<String>(),
        ),
      );
    },
  ),
  AssistantTool(
    "restore_setup",
    "Propose going back to the setup from before a change in read_change_log.",
    parameters: {"index": _n("index from read_change_log")},
    required: ["index"],
    (ref, args, proposal, cancel) async {
      final log = await ref.read(changeLogProvider.future);
      final entry = log.elementAtOrNull((args["index"]! as num).toInt());
      return entry == null
          ? const ToolOutcome("No such change.")
          : ToolOutcome("Proposed restoring the setup.", propose: ProposalItem.restore(entry));
    },
  ),

  // ---- The current rewrite (for now only, nothing saved) ----
  AssistantTool(
    "use_for_now",
    "Change only the current rewrite: turn instructions on or off, add a request, pick a model or a profile.",
    parameters: {
      "on": _list("Instruction ids to turn on."),
      "off": _list("Instruction ids to turn off."),
      "words": _text,
      "model": _s("backend/id."),
      "profile": _text,
    },
    (ref, args, proposal, cancel) async {
      final session = ref.read(sessionActionsProvider);
      final library = await _library(ref);
      final models = await ref.read(modelCatalogProvider.future);
      for (final id in ((args["on"] as List?) ?? const []).cast<String>()) {
        if (library[InstructionId(id)] case final i?
            when !(ref.read(resolvedProvider)?.active.any((a) => a.instruction.id == i.id) ?? false)) {
          session.toggle(i);
        }
      }
      for (final id in ((args["off"] as List?) ?? const []).cast<String>()) {
        if (library[InstructionId(id)] case final i?
            when ref.read(resolvedProvider)?.active.any((a) => a.instruction.id == i.id) ?? false) {
          session.toggle(i);
        }
      }
      if (args["words"] case final String words) session.setWords(words);
      if (_model(models, args["model"]) case final model?) session.useModel(model);
      if (args["profile"] case final String name) {
        final profile = library.profiles.firstWhereOrNull((p) => p.name.toLowerCase() == name.toLowerCase());
        if (profile == null) {
          return ToolOutcome("No profile named $name. Use a name from read_setup; nothing else was skipped.");
        }
        session.useProfile(profile.name);
      }
      return const ToolOutcome("Applied to this rewrite only. It reruns now.");
    },
  ),
  AssistantTool("read_changes", "The suggested edits in the current result, with index, before, after and status.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final changes = ref.read(reviewProvider)?.document.pendingChanges ?? const <PendingChange>[];
    return _json([
      for (final (i, c) in changes.indexed)
        {"index": i, "before": c.originalText, "after": c.newText, "status": c.status.name},
    ]);
  }),
  AssistantTool(
    "decide_changes",
    "Keep or undo suggested edits in the current result, by index.",
    parameters: {"keep": _list("Indexes to keep."), "undo": _list("Indexes to undo.")},
    (ref, args, proposal, cancel) async {
      final review = ref.read(reviewProvider.notifier);
      for (final i in ((args["keep"] as List?) ?? const [])) {
        review.keepAt(int.parse("$i"));
      }
      for (final i in ((args["undo"] as List?) ?? const [])) {
        review.undoAt(int.parse("$i"));
      }
      return const ToolOutcome("Done. The user can still change any of them before pressing Enter.");
    },
  ),
  AssistantTool("explain_changes", "Why each suggested edit in the current result was made.", (
    ref,
    args,
    proposal,
    cancel,
  ) async {
    final request = ref.read(runRequestProvider);
    if (request == null) return const ToolOutcome("There is no finished result.");
    // Listened, not read: read would let the auto dispose provider go away
    // while it is still asking the model.
    final subscription = ref.listen(explanationsProvider(request).future, (_, _) {});
    final Map<ChangeKey, String> reasons;
    try {
      reasons = await subscription.read();
    } finally {
      subscription.close();
    }
    return _json([
      for (final MapEntry(:key, :value) in reasons.entries) {"before": key.before, "after": key.after, "why": value},
    ]);
  }),

  // ---- Try before proposing ----
  AssistantTool(
    "try_rewrite",
    "Rewrite a text with given instructions and model without changing anything, to test a proposal on real examples such as texts from read_history.",
    parameters: {
      "text": _s("Defaults to the current text."),
      "instructions": _list("Instruction ids, existing or proposed."),
      "words": _text,
      "model": _s("backend/id. Defaults to the current model."),
    },
    (ref, args, proposal, cancel) async {
      final library = applyChanges(await _library(ref), [
        for (final p in proposal)
          if (p case ProposedChange(:final change)) change,
      ]);
      final input = args["text"] as String? ?? ref.read(sessionProvider).input?.text ?? "";
      if (input.isEmpty) return const ToolOutcome("No text to try.");
      final models = await ref.read(modelCatalogProvider.future);
      final model =
          models.firstWhereOrNull((m) => m.ref == _model(models, args["model"])) ??
          ref.read(runRequestProvider)?.model ??
          models.firstOrNull;
      if (model == null) return const ToolOutcome("No model available.");
      var choices = const RunChoices();
      for (final id in ((args["instructions"] as List?) ?? const []).cast<String>()) {
        choices = choices.turnOn(InstructionId(id));
      }
      final prompt = compose(
        resolve(library, null, input, choices.copyWith(words: args["words"] as String? ?? "")),
        input,
      );
      final connection = (await ref.read(connectionsProvider.future))[model.ref.backend]!;
      final chat = await ref.read(llmGatewayProvider).chat(connection, model.ref, system: prompt.system);
      final response = await chat.chat([llm.ChatMessage.user(prompt.user)], cancelToken: cancel);
      if (response.usage case final usage?) {
        await ref.read(usageTotalsProvider.notifier).add(usage, model.price?.cost(usage));
      }
      final output = restoreEdges(input, unwrapText(response.text ?? ""));
      final changed = wordDiff(input, output).where((d) => d.operation != 0).length;
      return _json({"model": model.ref.toString(), "output": output, "changed_parts": changed});
    },
  ),

  // ---- The web ----
  AssistantTool(
    "fetch_url",
    "Read a web page as plain text, for example a formatting guide. Works with every model.",
    parameters: {"url": _text},
    required: ["url"],
    (ref, args, proposal, cancel) async {
      try {
        final response = await ref
            .read(httpProvider)
            .get<String>(args["url"]! as String, options: Options(responseType: ResponseType.plain));
        final text = (response.data ?? "")
            .replaceAll(RegExp(r"<(script|style)[\s\S]*?</\1>", caseSensitive: false), " ")
            .replaceAll(RegExp("<[^>]+>"), " ")
            .replaceAll(RegExp(r"\s+"), " ");
        return ToolOutcome(text.length > 20000 ? "${text.substring(0, 20000)} [cut]" : text);
      } on DioException catch (error) {
        return ToolOutcome("Could not read the page: ${error.message}");
      }
    },
  ),
];

/// The tool maps arrive as JSON; parse them through the YAML reader so the
/// same validation and error messages apply.
YamlMap _toYaml(Map<String, Object?> map) => loadYaml(jsonEncode(map)) as YamlMap;
