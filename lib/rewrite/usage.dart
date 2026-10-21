// Replaces lib/state/ai_usage.dart
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "usage.freezed.dart";
part "usage.g.dart";

const _tokensKey = "usage_tokens";
const _costKey = "usage_cost";

@freezed
abstract class UsageSummary with _$UsageSummary {
  const factory UsageSummary({required int tokens, required double cost}) = _UsageSummary;
}

/// Lifetime totals, shown in the footer and reset from Settings.
@Riverpod(keepAlive: true)
class UsageTotals extends _$UsageTotals {
  @override
  Future<UsageSummary> build() async {
    final prefs = await ref.watch(preferencesProvider.future);
    return UsageSummary(tokens: prefs.getInt(_tokensKey) ?? 0, cost: prefs.getDouble(_costKey) ?? 0);
  }

  /// [cost] is null for models without a known price; tokens still count.
  Future<void> add(llm.UsageInfo usage, double? cost) async {
    final current = await future;
    final next = UsageSummary(
      tokens: current.tokens + (usage.promptTokens ?? 0) + (usage.completionTokens ?? 0),
      cost: current.cost + (cost ?? 0),
    );
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.setInt(_tokensKey, next.tokens);
    await prefs.setDouble(_costKey, next.cost);
    state = AsyncData(next);
  }

  Future<void> reset() async {
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.remove(_tokensKey);
    await prefs.remove(_costKey);
    state = const AsyncData(UsageSummary(tokens: 0, cost: 0));
  }
}
