// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// macOS 26 on Apple silicon with Apple Intelligence on. A provider so
/// tests can answer it: an unanswered platform channel never completes.

@ProviderFor(appleModelAvailable)
final appleModelAvailableProvider = AppleModelAvailableProvider._();

/// macOS 26 on Apple silicon with Apple Intelligence on. A provider so
/// tests can answer it: an unanswered platform channel never completes.

final class AppleModelAvailableProvider extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// macOS 26 on Apple silicon with Apple Intelligence on. A provider so
  /// tests can answer it: an unanswered platform channel never completes.
  AppleModelAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appleModelAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appleModelAvailableHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return appleModelAvailable(ref);
  }
}

String _$appleModelAvailableHash() => r'bac3710f65258b4a771689cf516473a3e1e39dc2';
