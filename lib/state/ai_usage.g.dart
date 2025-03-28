// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestUsage _$RequestUsageFromJson(Map<String, dynamic> json) =>
    _RequestUsage(
      promptTokenCount: (json['promptTokenCount'] as num).toInt(),
      completionTokenCount: (json['completionTokenCount'] as num).toInt(),
      model: $enumDecode(_$ModelEnumMap, json['model']),
    );

Map<String, dynamic> _$RequestUsageToJson(_RequestUsage instance) =>
    <String, dynamic>{
      'promptTokenCount': instance.promptTokenCount,
      'completionTokenCount': instance.completionTokenCount,
      'model': _$ModelEnumMap[instance.model]!,
    };

const _$ModelEnumMap = {
  Model.gemini25ProExp0325: 'gemini25ProExp0325',
  Model.gemini20Flash: 'gemini20Flash',
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
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$totalTokenCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalTokenCountRef = AutoDisposeProviderRef<int>;
String _$totalPriceHash() => r'f1429f0f35c78bcb5725b06a7c7e4cfdb8b80fed';

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
String _$aiUsageHash() => r'35a66eaaf5ff7f4679fd660b8e7557703ae368c1';

/// See also [AiUsage].
@ProviderFor(AiUsage)
final aiUsageProvider = AutoDisposeAsyncNotifierProvider<
  AiUsage,
  Map<String, RequestUsage>
>.internal(
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
