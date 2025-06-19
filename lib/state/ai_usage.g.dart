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

String _$totalTokenCountHash() => r'a6cb796c7ed700ecda54cef71e8617338e493b46';

/// See also [totalTokenCount].
@ProviderFor(totalTokenCount)
final totalTokenCountProvider = AutoDisposeProvider<int>.internal(
  totalTokenCount,
  name: r'totalTokenCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalTokenCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalTokenCountRef = AutoDisposeProviderRef<int>;
String _$totalPriceHash() => r'db14ff751a4ecb54219f5ec95d052607563a68b2';

/// See also [totalPrice].
@ProviderFor(totalPrice)
final totalPriceProvider = AutoDisposeProvider<double>.internal(
  totalPrice,
  name: r'totalPriceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalPriceRef = AutoDisposeProviderRef<double>;
String _$aiUsageHash() => r'a41152e3ff6d70f34900c65fdd30aaa1dc96c2bd';

/// See also [AiUsage].
@ProviderFor(AiUsage)
final aiUsageProvider = AutoDisposeAsyncNotifierProvider<AiUsage,
    Map<String, RequestUsage>>.internal(
  AiUsage.new,
  name: r'aiUsageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiUsageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiUsage = AutoDisposeAsyncNotifier<Map<String, RequestUsage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
