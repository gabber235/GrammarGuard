// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_rewrite.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diffsHash() => r'5561574e5ebaf8448f42cb3d6953fa03007a6596';

/// See also [diffs].
@ProviderFor(diffs)
final diffsProvider = AutoDisposeProvider<List<Diff>>.internal(
  diffs,
  name: r'diffsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$diffsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiffsRef = AutoDisposeProviderRef<List<Diff>>;
String _$diffStringHash() => r'dfaa5c3266fcac0b6f97772b749c24ac76457acd';

/// See also [diffString].
@ProviderFor(diffString)
final diffStringProvider = AutoDisposeProvider<String>.internal(
  diffString,
  name: r'diffStringProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$diffStringHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DiffStringRef = AutoDisposeProviderRef<String>;
String _$selectedModelHash() => r'bd84ab2d689f6c9c9cf8df23a0e99befa3a71fa2';

/// See also [SelectedModel].
@ProviderFor(SelectedModel)
final selectedModelProvider =
    AutoDisposeNotifierProvider<SelectedModel, AiModel>.internal(
  SelectedModel.new,
  name: r'selectedModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedModel = AutoDisposeNotifier<AiModel>;
String _$aiRewriteHash() => r'6f2ac87e6d5df3c617601c5989a7422e9f5a06d2';

/// See also [AiRewrite].
@ProviderFor(AiRewrite)
final aiRewriteProvider =
    AutoDisposeStreamNotifierProvider<AiRewrite, String>.internal(
  AiRewrite.new,
  name: r'aiRewriteProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$aiRewriteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AiRewrite = AutoDisposeStreamNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
