import "dart:convert";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/llm/connections.dart";
import "package:grammar_guard/llm/gateway.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/word_diff.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/rewrite/usage.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "explain.freezed.dart";
part "explain.g.dart";

/// A change as the user sees it. Reasons are keyed by content, not by
/// index, because editing renumbers the changes.
@freezed
abstract class ChangeKey with _$ChangeKey {
  const factory ChangeKey({required String before, required String after}) = _ChangeKey;

  factory ChangeKey.of(PendingChange change) => ChangeKey(before: change.originalText, after: change.newText);
}

const _system =
    "You explain edits made to a text. For each numbered change give one reason of at most "
    "15 words, in the language of the text. Answer with JSON only: "
    '{"reasons": [{"id": 0, "reason": "..."}]}';

/// One short reason per change, from one extra call to the same model.
/// Asked the first time the user presses ?, then cached with the run.
@riverpod
Future<Map<ChangeKey, String>> explanations(Ref ref, RunRequest request) async {
  final done = await ref.watch(runProvider(request).future);
  if (done is! Done) return const {};
  final changes = EditorDocument.fromDiffs(wordDiff(request.input, done.text)).pendingChanges;
  if (changes.isEmpty) return const {};

  final connection = (await ref.read(connectionsProvider.future))[request.model.ref.backend]!;
  final chat = await ref.read(llmGatewayProvider).chat(connection, request.model.ref, system: _system);
  final response = await chat.chat([
    llm.ChatMessage.user(
      jsonEncode({
        "text": request.input,
        "changes": [
          for (final (id, c) in changes.indexed) {"id": id, "before": c.originalText, "after": c.newText},
        ],
      }),
    ),
  ]);
  if (response.usage case final usage?) {
    await ref.read(usageTotalsProvider.notifier).add(usage, request.model.price?.cost(usage));
  }
  ref.keepAlive();
  return parseReasons(response.text ?? "", changes);
}

/// Tolerates code fences and extra text around the JSON object.
Map<ChangeKey, String> parseReasons(String reply, List<PendingChange> changes) {
  final start = reply.indexOf("{");
  final end = reply.lastIndexOf("}");
  if (start < 0 || end <= start) return const {};
  final Object? decoded;
  try {
    decoded = jsonDecode(reply.substring(start, end + 1));
  } on FormatException {
    return const {};
  }
  if (decoded case {"reasons": final List<Object?> reasons}) {
    return {
      for (final item in reasons)
        if (item case {"id": final int id, "reason": final String reason} when id >= 0 && id < changes.length)
          ChangeKey.of(changes[id]): reason,
    };
  }
  return const {};
}
