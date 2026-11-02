import "dart:convert";

import "package:file/file.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/settings/hotkey_setting.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "history.freezed.dart";
part "history.g.dart";

/// One delivered rewrite. Rich on purpose: the bar ranks recents per app
/// from [picked] and [words], profile suggestions count [picked], and the
/// assistant reads [decisions] to spot habits worth an instruction.
@freezed
abstract class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    required DateTime at,
    required String input,
    required String output,
    required List<String> profiles,
    required List<String> instructions,
    required List<String> picked,
    required String words,
    required List<Decision> decisions,
    String? appId,
    String? app,
    String? model,
    double? cost,
  }) = _HistoryEntry;

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => _$HistoryEntryFromJson(json);
}

/// The last delivered rewrites, as many as [HistoryLimit] says, stored only
/// on this computer in history.jsonl. Settings can clear it or turn it off.
@Riverpod(keepAlive: true)
class History extends _$History {
  @override
  Future<List<HistoryEntry>> build() async {
    final file = await _file();
    if (!file.existsSync()) return const [];
    return [for (final line in (await file.readAsLines()).reversed) ?_decode(line)];
  }

  Future<void> add(HistoryEntry entry) async {
    final limit = await ref.read(historyLimitProvider.future);
    if (limit == 0) return;
    await _write([entry, ...await future].take(limit).toList());
  }

  /// Drops the oldest rewrites beyond [limit].
  Future<void> trim(int limit) async {
    if (limit == 0) return clear();
    final entries = await future;
    if (entries.length <= limit) return;
    await _write(entries.take(limit).toList());
  }

  Future<void> _write(List<HistoryEntry> kept) async {
    await (await _file()).writeAsString("${kept.reversed.map((e) => jsonEncode(e.toJson())).join("\n")}\n");
    state = AsyncData(kept);
  }

  Future<void> clear() async {
    final file = await _file();
    if (file.existsSync()) await file.delete();
    state = const AsyncData([]);
  }

  Future<File> _file() async => (await ref.read(appSupportDirProvider.future)).childFile("history.jsonl");

  static HistoryEntry? _decode(String line) {
    try {
      return HistoryEntry.fromJson(jsonDecode(line) as Map<String, dynamic>);
    } on FormatException {
      return null; // one damaged line must not hide the rest
    } on TypeError {
      return null;
    }
  }
}
