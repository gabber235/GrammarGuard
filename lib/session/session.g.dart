// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Popup when a global hotkey works, a normal window otherwise (Wayland).

@ProviderFor(isPopup)
final isPopupProvider = IsPopupProvider._();

/// Popup when a global hotkey works, a normal window otherwise (Wayland).

final class IsPopupProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  /// Popup when a global hotkey works, a normal window otherwise (Wayland).
  IsPopupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPopupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPopupHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isPopup(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$isPopupHash() => r'2e0b3cb4d6db91d6b44e13148dcd9b85726c2f2f';

@ProviderFor(resolved)
final resolvedProvider = ResolvedProvider._();

final class ResolvedProvider extends $FunctionalProvider<Resolved?, Resolved?, Resolved?> with $Provider<Resolved?> {
  ResolvedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolvedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolvedHash();

  @$internal
  @override
  $ProviderElement<Resolved?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Resolved? create(Ref ref) {
    return resolved(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Resolved? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Resolved?>(value));
  }
}

String _$resolvedHash() => r'd67bf1473905a9cd05e65c5ef95b8f9a282733e2';

/// The request for the visible result, or null when there is nothing to run.

@ProviderFor(runRequest)
final runRequestProvider = RunRequestProvider._();

/// The request for the visible result, or null when there is nothing to run.

final class RunRequestProvider extends $FunctionalProvider<RunRequest?, RunRequest?, RunRequest?>
    with $Provider<RunRequest?> {
  /// The request for the visible result, or null when there is nothing to run.
  RunRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runRequestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runRequestHash();

  @$internal
  @override
  $ProviderElement<RunRequest?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RunRequest? create(Ref ref) {
    return runRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunRequest? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RunRequest?>(value));
  }
}

String _$runRequestHash() => r'cee5ec1c9147cbfdbb33f015505d80569729b8e9';

/// The second request while comparing two models.

@ProviderFor(compareRequest)
final compareRequestProvider = CompareRequestProvider._();

/// The second request while comparing two models.

final class CompareRequestProvider extends $FunctionalProvider<RunRequest?, RunRequest?, RunRequest?>
    with $Provider<RunRequest?> {
  /// The second request while comparing two models.
  CompareRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compareRequestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$compareRequestHash();

  @$internal
  @override
  $ProviderElement<RunRequest?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  RunRequest? create(Ref ref) {
    return compareRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunRequest? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<RunRequest?>(value));
  }
}

String _$compareRequestHash() => r'04f9538dad8305db0f7075d7233a3b2e1b047e70';

/// The run the window shows. Null before capture and after Esc.

@ProviderFor(currentRun)
final currentRunProvider = CurrentRunProvider._();

/// The run the window shows. Null before capture and after Esc.

final class CurrentRunProvider
    extends $FunctionalProvider<AsyncValue<RunState>?, AsyncValue<RunState>?, AsyncValue<RunState>?>
    with $Provider<AsyncValue<RunState>?> {
  /// The run the window shows. Null before capture and after Esc.
  CurrentRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRunProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRunHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<RunState>?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<RunState>? create(Ref ref) {
    return currentRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RunState>? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AsyncValue<RunState>?>(value));
  }
}

String _$currentRunHash() => r'b6e2a4971b288e2ffd8e280363b23830379ce20d';

/// Holds the session state. Riverpod 3 forbids a provider from reading
/// providers that depend on it, and most of the flow needs exactly those
/// (the run, the review, the resolved settings), so the flow itself lives
/// in [SessionActions] and changes state only through [update].

@ProviderFor(Session)
final sessionProvider = SessionProvider._();

/// Holds the session state. Riverpod 3 forbids a provider from reading
/// providers that depend on it, and most of the flow needs exactly those
/// (the run, the review, the resolved settings), so the flow itself lives
/// in [SessionActions] and changes state only through [update].
final class SessionProvider extends $NotifierProvider<Session, SessionState> {
  /// Holds the session state. Riverpod 3 forbids a provider from reading
  /// providers that depend on it, and most of the flow needs exactly those
  /// (the run, the review, the resolved settings), so the flow itself lives
  /// in [SessionActions] and changes state only through [update].
  SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SessionState>(value));
  }
}

String _$sessionHash() => r'3aff5d1b82bf90b76fe5e3760ae3e29d0f95b439';

/// Holds the session state. Riverpod 3 forbids a provider from reading
/// providers that depend on it, and most of the flow needs exactly those
/// (the run, the review, the resolved settings), so the flow itself lives
/// in [SessionActions] and changes state only through [update].

abstract class _$Session extends $Notifier<SessionState> {
  SessionState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionState, SessionState>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<SessionState, SessionState>, SessionState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(sessionActions)
final sessionActionsProvider = SessionActionsProvider._();

final class SessionActionsProvider extends $FunctionalProvider<SessionActions, SessionActions, SessionActions>
    with $Provider<SessionActions> {
  SessionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionActionsHash();

  @$internal
  @override
  $ProviderElement<SessionActions> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SessionActions create(Ref ref) {
    return sessionActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionActions value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SessionActions>(value));
  }
}

String _$sessionActionsHash() => r'408b0d5ba67c500f7c3b53a5052c8ecbfd9dbd90';
