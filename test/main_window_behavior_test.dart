import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/state/window_lifecycle.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("Main window behavior policy flow", () {
    late ProviderContainer container;
    late WindowLifecycle notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(windowLifecycleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test("blur while generating does not request hide", () {
      notifier.onGenerationStarted();
      notifier.onWindowBlurred();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("generation completion does not request immediate hide", () {
      notifier.onGenerationStarted();
      notifier.onGenerationFinished();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("generation completion requests hide after blur", () {
      notifier.onGenerationStarted();
      notifier.onGenerationFinished();
      notifier.onWindowBlurred();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isTrue);
    });

    test("refresh is requested only for reopen with changed clipboard", () {
      notifier.onClipboardSynced("old");
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.evaluateRefresh("new");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isTrue);
    });

    test("reopen refresh is blocked while generating", () {
      notifier.onClipboardSynced("old");
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.onGenerationStarted();
      notifier.evaluateRefresh("new");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isFalse);
    });

    test("close stays blocked during generation", () {
      notifier.onGenerationStarted();
      notifier.onCloseRequested();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.canClose, isFalse);
    });
  });
}
