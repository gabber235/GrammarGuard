// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One model call. Auto dispose cancels the request when nobody watches it
/// (another instruction picked, Esc, window closed). A finished run keeps
/// itself alive as the cache until the session invalidates the family.

@ProviderFor(Run)
final runProvider = RunFamily._();

/// One model call. Auto dispose cancels the request when nobody watches it
/// (another instruction picked, Esc, window closed). A finished run keeps
/// itself alive as the cache until the session invalidates the family.
final class RunProvider extends $StreamNotifierProvider<Run, RunState> {
  /// One model call. Auto dispose cancels the request when nobody watches it
  /// (another instruction picked, Esc, window closed). A finished run keeps
  /// itself alive as the cache until the session invalidates the family.
  RunProvider._({required RunFamily super.from, required RunRequest super.argument})
    : super(
        retry: null,
        name: r'runProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runHash();

  @override
  String toString() {
    return r'runProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Run create() => Run();

  @override
  bool operator ==(Object other) {
    return other is RunProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$runHash() => r'c3fa3962d59aa27b83937b66206aeaa696eb70c9';

/// One model call. Auto dispose cancels the request when nobody watches it
/// (another instruction picked, Esc, window closed). A finished run keeps
/// itself alive as the cache until the session invalidates the family.

final class RunFamily extends $Family
    with $ClassFamilyOverride<Run, AsyncValue<RunState>, RunState, Stream<RunState>, RunRequest> {
  RunFamily._()
    : super(
        retry: null,
        name: r'runProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One model call. Auto dispose cancels the request when nobody watches it
  /// (another instruction picked, Esc, window closed). A finished run keeps
  /// itself alive as the cache until the session invalidates the family.

  RunProvider call(RunRequest request) => RunProvider._(argument: request, from: this);

  @override
  String toString() => r'runProvider';
}

/// One model call. Auto dispose cancels the request when nobody watches it
/// (another instruction picked, Esc, window closed). A finished run keeps
/// itself alive as the cache until the session invalidates the family.

abstract class _$Run extends $StreamNotifier<RunState> {
  late final _$args = ref.$arg as RunRequest;
  RunRequest get request => _$args;

  Stream<RunState> build(RunRequest request);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RunState>, RunState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RunState>, RunState>,
              AsyncValue<RunState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
