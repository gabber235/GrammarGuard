// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generation_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GenerationStats)
final generationStatsProvider = GenerationStatsProvider._();

final class GenerationStatsProvider
    extends $NotifierProvider<GenerationStats, GenerationStatsSnapshot> {
  GenerationStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generationStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generationStatsHash();

  @$internal
  @override
  GenerationStats create() => GenerationStats();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenerationStatsSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenerationStatsSnapshot>(value),
    );
  }
}

String _$generationStatsHash() => r'048f3d9ea50a0c6f936461609810a1749039123d';

abstract class _$GenerationStats extends $Notifier<GenerationStatsSnapshot> {
  GenerationStatsSnapshot build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<GenerationStatsSnapshot, GenerationStatsSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GenerationStatsSnapshot, GenerationStatsSnapshot>,
              GenerationStatsSnapshot,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
