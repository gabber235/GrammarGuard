// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_editor_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectionEditorNotifier)
final selectionEditorProvider = SelectionEditorNotifierProvider._();

final class SelectionEditorNotifierProvider
    extends $NotifierProvider<SelectionEditorNotifier, SelectionEditorState?> {
  SelectionEditorNotifierProvider._()
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
    r'dfbf75c7b79d71eccc14358cda1aef83796f0aba';

abstract class _$SelectionEditorNotifier
    extends $Notifier<SelectionEditorState?> {
  SelectionEditorState? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SelectionEditorState?, SelectionEditorState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SelectionEditorState?, SelectionEditorState?>,
              SelectionEditorState?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
