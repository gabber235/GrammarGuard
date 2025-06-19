import "dart:convert";

import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/models/model_registry.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "ai_usage.freezed.dart";
part "ai_usage.g.dart";

@freezed
abstract class RequestUsage with _$RequestUsage {
  const factory RequestUsage({
    required int promptTokenCount,
    required int completionTokenCount,
    required String modelName,
    required String providerName,
    required double cost,
  }) = _RequestUsage;

  factory RequestUsage.fromJson(Map<String, dynamic> json) =>
      _$RequestUsageFromJson(json);
}

const _usageKey = "ai_usage_data_new";

@riverpod
class AiUsage extends _$AiUsage {
  @override
  Future<Map<String, RequestUsage>> build() async {
    final prefs = await SharedPreferences.getInstance();
    final usageJson = prefs.getString(_usageKey);

    if (usageJson == null) return {};

    try {
      final Map<String, dynamic> decoded = json.decode(usageJson);
      return decoded.map(
        (key, value) => MapEntry(key, RequestUsage.fromJson(value)),
      );
    } on Error catch (_) {
      return {};
    }
  }

  Future<void> recordUsage(
    String id,
    String modelName,
    int promptTokenCount,
    int completionTokenCount,
    String providerName,
  ) async {
    final model = ModelRegistry.getModel(modelName);
    var cost = 0.0;

    if (model != null) {
      cost = (promptTokenCount / 1000000 * model.pricePerMillionInputTokens) +
          (completionTokenCount / 1000000 * model.pricePerMillionOutputTokens);
    }

    final usage = RequestUsage(
      promptTokenCount: promptTokenCount,
      completionTokenCount: completionTokenCount,
      modelName: modelName,
      providerName: providerName,
      cost: cost,
    );

    final prefs = await SharedPreferences.getInstance();
    final current = state.valueOrNull ?? {};
    final updated = {...current, id: usage};
    state = AsyncValue.data(updated);

    final encoded = json.encode(
      updated.map((key, value) => MapEntry(key, value.toJson())),
    );

    await prefs.setString(_usageKey, encoded);
  }
}

@riverpod
int totalTokenCount(Ref ref) {
  final usage = ref.watch(aiUsageProvider);
  return usage.valueOrNull?.values.fold<int>(0, (prev, usage) {
        return prev + usage.promptTokenCount + usage.completionTokenCount;
      }) ??
      0;
}

@riverpod
double totalPrice(Ref ref) {
  final usage = ref.watch(aiUsageProvider);
  return usage.valueOrNull?.values
          .fold<double>(0, (prev, usage) => prev + usage.cost) ??
      0;
}
