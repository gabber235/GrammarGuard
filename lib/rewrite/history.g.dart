// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryEntry _$HistoryEntryFromJson(Map<String, dynamic> json) => _HistoryEntry(
  at: DateTime.parse(json['at'] as String),
  input: json['input'] as String,
  output: json['output'] as String,
  profiles: (json['profiles'] as List<dynamic>).map((e) => e as String).toList(),
  instructions: (json['instructions'] as List<dynamic>).map((e) => e as String).toList(),
  picked: (json['picked'] as List<dynamic>).map((e) => e as String).toList(),
  words: json['words'] as String,
  decisions: (json['decisions'] as List<dynamic>).map((e) => Decision.fromJson(e as Map<String, dynamic>)).toList(),
  appId: json['appId'] as String?,
  app: json['app'] as String?,
  model: json['model'] as String?,
  cost: (json['cost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$HistoryEntryToJson(_HistoryEntry instance) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'input': instance.input,
  'output': instance.output,
  'profiles': instance.profiles,
  'instructions': instance.instructions,
  'picked': instance.picked,
  'words': instance.words,
  'decisions': instance.decisions,
  'appId': instance.appId,
  'app': instance.app,
  'model': instance.model,
  'cost': instance.cost,
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The last 100 delivered rewrites, stored only on this computer in
/// history.jsonl. Settings can clear it or turn it off.

@ProviderFor(History)
final historyProvider = HistoryProvider._();

/// The last 100 delivered rewrites, stored only on this computer in
/// history.jsonl. Settings can clear it or turn it off.
final class HistoryProvider extends $AsyncNotifierProvider<History, List<HistoryEntry>> {
  /// The last 100 delivered rewrites, stored only on this computer in
  /// history.jsonl. Settings can clear it or turn it off.
  HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  History create() => History();
}

String _$historyHash() => r'fb8f3aedbfa948f077a0c8d28577912633289a46';

/// The last 100 delivered rewrites, stored only on this computer in
/// history.jsonl. Settings can clear it or turn it off.

abstract class _$History extends $AsyncNotifier<List<HistoryEntry>> {
  FutureOr<List<HistoryEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<HistoryEntry>>, List<HistoryEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HistoryEntry>>, List<HistoryEntry>>,
              AsyncValue<List<HistoryEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
