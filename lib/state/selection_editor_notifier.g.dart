// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_editor_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectionEditorNotifier)
const selectionEditorProvider = SelectionEditorNotifierProvider._();

final class SelectionEditorNotifierProvider
    extends $NotifierProvider<SelectionEditorNotifier, SelectionEditorState?> {
  const SelectionEditorNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectionEditorProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectionEditorNotifierHash();

  @$internal
  @override
  SelectionEditorNotifier create() => SelectionEditorNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectionEditorState? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectionEditorState?>(value),
    );
  }
}

String _$selectionEditorNotifierHash() =>
    r'68309e3bd65a0ab2db3a5b0edeb089923f287029';

abstract class _$SelectionEditorNotifier
    extends $Notifier<SelectionEditorState?> {
  SelectionEditorState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SelectionEditorState?, SelectionEditorState?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SelectionEditorState?, SelectionEditorState?>,
        SelectionEditorState?,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
