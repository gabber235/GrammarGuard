// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestUsage _$RequestUsageFromJson(Map<String, dynamic> json) =>
    _RequestUsage(
      promptTokenCount: (json['promptTokenCount'] as num).toInt(),
      completionTokenCount: (json['completionTokenCount'] as num).toInt(),
      modelName: json['modelName'] as String,
      providerName: json['providerName'] as String,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$RequestUsageToJson(_RequestUsage instance) =>
    <String, dynamic>{
      'promptTokenCount': instance.promptTokenCount,
      'completionTokenCount': instance.completionTokenCount,
      'modelName': instance.modelName,
      'providerName': instance.providerName,
      'cost': instance.cost,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(AiUsage)
const aiUsageProvider = AiUsageProvider._();

final class AiUsageProvider
    extends $AsyncNotifierProvider<AiUsage, Map<String, RequestUsage>> {
  const AiUsageProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'aiUsageProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$aiUsageHash();

  @$internal
  @override
  AiUsage create() => AiUsage();

  @$internal
  @override
  $AsyncNotifierProviderElement<AiUsage, Map<String, RequestUsage>>
      $createElement($ProviderPointer pointer) =>
          $AsyncNotifierProviderElement(pointer);
}

String _$aiUsageHash() => r'49984fa7697a2eec46d4db2bf9e4152310540e39';

abstract class _$AiUsage extends $AsyncNotifier<Map<String, RequestUsage>> {
  FutureOr<Map<String, RequestUsage>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Map<String, RequestUsage>>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Map<String, RequestUsage>>>,
        AsyncValue<Map<String, RequestUsage>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

@ProviderFor(totalTokenCount)
const totalTokenCountProvider = TotalTokenCountProvider._();

final class TotalTokenCountProvider extends $FunctionalProvider<int, int>
    with $Provider<int> {
  const TotalTokenCountProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'totalTokenCountProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalTokenCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return totalTokenCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<int>(value),
    );
  }
}

String _$totalTokenCountHash() => r'961093240deb860224daee6bb453765fea1d8e35';

@ProviderFor(totalPrice)
const totalPriceProvider = TotalPriceProvider._();

final class TotalPriceProvider extends $FunctionalProvider<double, double>
    with $Provider<double> {
  const TotalPriceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'totalPriceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalPriceHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return totalPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $ValueProvider<double>(value),
    );
  }
}

String _$totalPriceHash() => r'0c6f74ac5d08657528db409c79f32ffa93b23523';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
