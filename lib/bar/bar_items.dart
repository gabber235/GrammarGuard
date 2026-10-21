// What the bar offers for a query. Pure.
import "package:collection/collection.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/assistant/suggest.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/rewrite/history.dart";

part "bar_items.freezed.dart";

enum BarAction { settings, history, undoSetupChange, compare, retry, preview }

/// Every kind of row in the bar.
@freezed
sealed class BarItem with _$BarItem {
  const BarItem._();

  /// Enter turns it off when it is already [active].
  const factory BarItem.instruction(Instruction instruction, {required bool active}) = InstructionItem;
  const factory BarItem.profile(Profile profile) = ProfileItem;
  const factory BarItem.model(ModelInfo model) = ModelItem;
  const factory BarItem.action(BarAction action, String title) = ActionItem;

  /// "You always pick Shorter here. Make a Notion profile?" From local
  /// history, no model call.
  const factory BarItem.suggestion(PutProfile change) = SuggestionItem;

  /// The typed text as a request for this text. Enter clears it when it is
  /// already the [active] request.
  const factory BarItem.words(String words, {@Default(false) bool active}) = WordsItem;

  /// The typed text as a message to the assistant (also Tab).
  const factory BarItem.ask(String words) = AskItem;

  String get label => switch (this) {
    InstructionItem(:final instruction) => instruction.name,
    ProfileItem(:final profile) => profile.name,
    ModelItem(:final model) => model.label,
    ActionItem(:final title) => title,
    SuggestionItem(:final change) =>
      "Make a ${change.profile.name} profile with ${change.profile.use.map((id) => id.value).join(", ")}",
    WordsItem(:final words, active: true) => "\u201c$words\u201d",
    WordsItem(:final words) => "Use \u201c$words\u201d as a request",
    AskItem(:final words) => words.isEmpty ? "Ask the assistant" : "Ask \u201c$words\u201d",
  };
}

const _actions = [
  BarItem.action(BarAction.settings, "Settings"),
  BarItem.action(BarAction.history, "History and setup changes"),
  BarItem.action(BarAction.undoSetupChange, "Undo the last setup change"),
  BarItem.action(BarAction.compare, "Compare with another model"),
  BarItem.action(BarAction.retry, "Try again"),
  BarItem.action(BarAction.preview, "Preview the final text"),
];

/// Ranked rows for [query]. Prefixes narrow the kind: @ models, # profiles,
/// > actions, ? assistant. Empty query: what is on for this text (the
/// [active] instructions and the request [words]), then a suggestion,
/// recents for this app and pins. No row appears twice.
List<BarItem> barItems({
  required String query,
  required Library library,
  required Set<InstructionId> active,
  required String words,
  required List<ModelInfo> models,
  required List<HistoryEntry> history,
  required SourceApp? source,
}) {
  final trimmed = query.trim();
  if (trimmed.startsWith("?")) return [BarItem.ask(trimmed.substring(1).trim())];
  final (kind, text) = switch (trimmed.isEmpty ? "" : trimmed[0]) {
    "@" => (ModelItem, trimmed.substring(1).trim()),
    "#" => (ProfileItem, trimmed.substring(1).trim()),
    ">" => (ActionItem, trimmed.substring(1).trim()),
    _ => (null, trimmed),
  };

  if (kind == null && text.isEmpty) {
    final suggestion = source == null ? null : suggestProfile(library, source, history);
    return {
      for (final id in active)
        if (library[id] case final instruction?) BarItem.instruction(instruction, active: true),
      if (words.isNotEmpty) BarItem.words(words, active: true),
      if (suggestion != null) BarItem.suggestion(suggestion),
      ..._recents(library, active, history, source?.id).where((item) => item != BarItem.words(words)),
    }.toList();
  }

  final candidates = <BarItem>[
    if (kind == null || kind == InstructionItem)
      for (final i in library.instructions) BarItem.instruction(i, active: active.contains(i.id)),
    if (kind == null || kind == ProfileItem)
      for (final p in library.profiles) BarItem.profile(p),
    if (kind == null || kind == ModelItem)
      for (final m in models) BarItem.model(m),
    if (kind == null || kind == ActionItem) ..._actions,
  ];
  final ranked = candidates
      .map((item) => (item, _score(item.label, text)))
      .where((e) => e.$2 > 0)
      .sortedBy<num>((e) => -e.$2)
      .map((e) => e.$1)
      .take(8)
      .toList();
  // Free text is always usable: as a request, or as a question.
  if (kind == null) ranked.addAll([BarItem.words(text), BarItem.ask(text)]);
  return ranked;
}

/// Word starts beat substrings, which beat letters in order ("pf" finds
/// "Professional"). Zero means no match.
double _score(String label, String query) {
  final l = label.toLowerCase();
  final q = query.toLowerCase();
  if (q.isEmpty) return 1;
  if (l.startsWith(q)) return 4;
  if (l.split(RegExp(r"\s+")).any((w) => w.startsWith(q))) return 3;
  if (l.contains(q)) return 2;
  var at = 0;
  for (final c in q.split("")) {
    at = l.indexOf(c, at);
    if (at < 0) return 0;
    at++;
  }
  return 1;
}

/// What the user picked for this app before, most used first, then pins.
List<BarItem> _recents(Library library, Set<InstructionId> active, List<HistoryEntry> history, String? appId) {
  final here = history.where((e) => e.appId == appId).take(30);
  final counts = <String, int>{};
  for (final entry in here) {
    for (final id in entry.picked) {
      counts.update(id, (n) => n + 1, ifAbsent: () => 1);
    }
    if (entry.words.isNotEmpty) counts.update("words:${entry.words}", (n) => n + 1, ifAbsent: () => 1);
  }
  final recent = counts.entries.sortedBy<num>((e) => -e.value).take(4).map<BarItem?>((e) {
    if (e.key.startsWith("words:")) return BarItem.words(e.key.substring(6));
    final instruction = library[InstructionId(e.key)];
    return instruction == null ? null : BarItem.instruction(instruction, active: active.contains(instruction.id));
  }).nonNulls;
  return [
    ...recent,
    for (var pin = 1; pin <= 9; pin++)
      if (library.pinned(pin) case final i?) BarItem.instruction(i, active: active.contains(i.id)),
    const BarItem.ask(""),
  ];
}
