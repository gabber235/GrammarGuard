import "dart:developer" as developer;

import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "window_lifecycle.freezed.dart";
part "window_lifecycle.g.dart";

enum RefreshTrigger { none, reopened }

@freezed
abstract class WindowLifecycleState with _$WindowLifecycleState {
  const factory WindowLifecycleState({
    @Default(true) bool isVisible,
    @Default(false) bool isGenerating,
    @Default(false) bool hideAfterCompletionOnBlur,
    @Default(RefreshTrigger.none) RefreshTrigger refreshTrigger,
    @Default("") String lastClipboardHash,
    @Default(false) bool hideRequested,
    @Default(false) bool refreshRequested,
    @Default(true) bool closeAllowed,
  }) = _WindowLifecycleState;
}

@freezed
abstract class WindowLifecyclePolicy with _$WindowLifecyclePolicy {
  const factory WindowLifecyclePolicy({
    required bool shouldHide,
    required bool shouldRefresh,
    required bool canClose,
  }) = _WindowLifecyclePolicy;
}

@Riverpod(keepAlive: true)
class WindowLifecycle extends _$WindowLifecycle {
  void _log(String message) {
    developer.log(message, name: "window_lifecycle");
  }

  @override
  WindowLifecycleState build() {
    _log("build initial state");
    return const WindowLifecycleState();
  }

  void onWindowShown() {
    _log("event onWindowShown");
    state = state.copyWith(
      isVisible: true,
      refreshTrigger: RefreshTrigger.reopened,
      hideRequested: false,
    );
    _log(
      "state visible=${state.isVisible} refreshTrigger=${state.refreshTrigger.name} lastHash=${state.lastClipboardHash}",
    );
  }

  void onWindowHidden() {
    _log("event onWindowHidden");
    state = state.copyWith(
      isVisible: false,
      hideAfterCompletionOnBlur: false,
      refreshTrigger: RefreshTrigger.none,
      hideRequested: false,
      refreshRequested: false,
    );
    _log(
      "state visible=${state.isVisible} refreshTrigger=${state.refreshTrigger.name} hideRequested=${state.hideRequested}",
    );
  }

  void onWindowBlurred() {
    _log("event onWindowBlurred. generating=${state.isGenerating}");
    if (state.isGenerating) {
      _log("blur ignored because generation is active");
      return;
    }
    state = state.copyWith(
      hideRequested: true,
      hideAfterCompletionOnBlur: false,
    );
    _log("blur requested hide");
  }

  void onEscapePressed() {
    _log("event onEscapePressed");
    if (state.isGenerating) {
      _log("escape ignored because generation is active");
      return;
    }
    state = state.copyWith(hideRequested: true);
  }

  void onGenerationStarted() {
    _log("event onGenerationStarted");
    state = state.copyWith(
      isGenerating: true,
      closeAllowed: false,
      refreshRequested: false,
    );
    _log(
      "state generating=${state.isGenerating} closeAllowed=${state.closeAllowed}",
    );
  }

  void setGenerationActivity({required bool isActive}) {
    _log("event setGenerationActivity isActive=$isActive");
    state = state.copyWith(
      isGenerating: isActive,
      closeAllowed: !isActive,
      hideRequested: !isActive && state.hideRequested,
      refreshRequested: !isActive && state.refreshRequested,
    );
    _log(
      "state generating=${state.isGenerating} closeAllowed=${state.closeAllowed}",
    );
  }

  void onGenerationFinished() {
    _log("event onGenerationFinished");
    state = state.copyWith(
      isGenerating: false,
      closeAllowed: true,
      hideAfterCompletionOnBlur: true,
    );
    _log(
      "state generating=${state.isGenerating} pendingHideAfterCompletion=${state.hideAfterCompletionOnBlur}",
    );
  }

  void onCloseRequested() {
    _log("event onCloseRequested generating=${state.isGenerating}");
    state = state.copyWith(closeAllowed: !state.isGenerating);
    _log("state closeAllowed=${state.closeAllowed}");
  }

  void evaluateRefresh(String clipboardHash) {
    final reopened = state.refreshTrigger == RefreshTrigger.reopened;
    final changed =
        clipboardHash.isNotEmpty && clipboardHash != state.lastClipboardHash;
    final shouldRefresh = reopened && changed && !state.isGenerating;

    _log(
      "event evaluateRefresh hash=$clipboardHash reopened=$reopened changed=$changed generating=${state.isGenerating}",
    );

    state = state.copyWith(
      refreshRequested: shouldRefresh,
      refreshTrigger: RefreshTrigger.none,
    );
    _log(
      "state refreshRequested=${state.refreshRequested} refreshTrigger=${state.refreshTrigger.name}",
    );
  }

  void onClipboardSynced(String clipboardHash) {
    _log("event onClipboardSynced hash=$clipboardHash");
    state = state.copyWith(
      lastClipboardHash: clipboardHash,
      refreshRequested: false,
      refreshTrigger: RefreshTrigger.none,
    );
    _log("state lastHash=${state.lastClipboardHash}");
  }

  void acknowledgeHide() {
    _log("event acknowledgeHide");
    state = state.copyWith(hideRequested: false);
  }

  void acknowledgeRefresh() {
    _log("event acknowledgeRefresh");
    state = state.copyWith(refreshRequested: false);
  }
}

@riverpod
WindowLifecyclePolicy windowLifecyclePolicy(Ref ref) {
  final lifecycle = ref.watch(windowLifecycleProvider);
  return WindowLifecyclePolicy(
    shouldHide: lifecycle.hideRequested && !lifecycle.isGenerating,
    shouldRefresh: lifecycle.refreshRequested,
    canClose: lifecycle.closeAllowed,
  );
}
