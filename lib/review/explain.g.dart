// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explain.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One short reason per change, from one extra call to the same model.
/// Asked the first time the user presses ?, then cached with the run.

@ProviderFor(explanations)
final explanationsProvider = ExplanationsFamily._();

/// One short reason per change, from one extra call to the same model.
/// Asked the first time the user presses ?, then cached with the run.

final class ExplanationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<ChangeKey, String>>,
          Map<ChangeKey, String>,
          FutureOr<Map<ChangeKey, String>>
        >
    with $FutureModifier<Map<ChangeKey, String>>, $FutureProvider<Map<ChangeKey, String>> {
  /// One short reason per change, from one extra call to the same model.
  /// Asked the first time the user presses ?, then cached with the run.
  ExplanationsProvider._({required ExplanationsFamily super.from, required RunRequest super.argument})
    : super(
        retry: null,
        name: r'explanationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$explanationsHash();

  @override
  String toString() {
    return r'explanationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<ChangeKey, String>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Map<ChangeKey, String>> create(Ref ref) {
    final argument = this.argument as RunRequest;
    return explanations(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExplanationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$explanationsHash() => r'4f7afdb7a2fe621d9163989c0f9a451535df122d';

/// One short reason per change, from one extra call to the same model.
/// Asked the first time the user presses ?, then cached with the run.

final class ExplanationsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<ChangeKey, String>>, RunRequest> {
  ExplanationsFamily._()
    : super(
        retry: null,
        name: r'explanationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One short reason per change, from one extra call to the same model.
  /// Asked the first time the user presses ?, then cached with the run.

  ExplanationsProvider call(RunRequest request) => ExplanationsProvider._(argument: request, from: this);

  @override
  String toString() => r'explanationsProvider';
}
