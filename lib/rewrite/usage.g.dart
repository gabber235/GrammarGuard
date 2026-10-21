// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lifetime totals, shown in the footer and reset from Settings.

@ProviderFor(UsageTotals)
final usageTotalsProvider = UsageTotalsProvider._();

/// Lifetime totals, shown in the footer and reset from Settings.
final class UsageTotalsProvider extends $AsyncNotifierProvider<UsageTotals, UsageSummary> {
  /// Lifetime totals, shown in the footer and reset from Settings.
  UsageTotalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usageTotalsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usageTotalsHash();

  @$internal
  @override
  UsageTotals create() => UsageTotals();
}

String _$usageTotalsHash() => r'306dee71eb63963c02529a8387a74af78025e5c0';

/// Lifetime totals, shown in the footer and reset from Settings.

abstract class _$UsageTotals extends $AsyncNotifier<UsageSummary> {
  FutureOr<UsageSummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UsageSummary>, UsageSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UsageSummary>, UsageSummary>,
              AsyncValue<UsageSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
