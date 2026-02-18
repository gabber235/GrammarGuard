import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/state/window_lifecycle.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("WindowLifecycle", () {
    late ProviderContainer container;
    late WindowLifecycle notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(windowLifecycleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test("blur while generating does not hide", () {
      notifier.onGenerationStarted();
      notifier.onWindowBlurred();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("blur while idle hides", () {
      notifier.onWindowBlurred();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isTrue);
    });

    test("generation finish does not hide immediately", () {
      notifier.onGenerationStarted();
      notifier.onGenerationFinished();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("generation finish hides on next blur", () {
      notifier.onGenerationStarted();
      notifier.onGenerationFinished();
      notifier.onWindowBlurred();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isTrue);
    });

    test("escape requests hide", () {
      notifier.onEscapePressed();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isTrue);
    });

    test("escape during generation does not request immediate hide", () {
      notifier.onGenerationStarted();
      notifier.onEscapePressed();
      notifier.onGenerationFinished();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("close blocked during generation", () {
      notifier.onGenerationStarted();
      notifier.onCloseRequested();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.canClose, isFalse);
    });

    test("close allowed when idle", () {
      notifier.onCloseRequested();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.canClose, isTrue);
    });

    test("focus alone never refreshes", () {
      notifier.evaluateRefresh("hash");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isFalse);
    });

    test("hidden to visible enables refresh evaluation", () {
      notifier.onClipboardSynced("old");
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.evaluateRefresh("new");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isTrue);
    });

    test("refresh requires changed clipboard", () {
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.onClipboardSynced("same");
      notifier.evaluateRefresh("same");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isFalse);
    });

    test("refresh blocked during generation", () {
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.onClipboardSynced("old");
      notifier.onGenerationStarted();
      notifier.evaluateRefresh("new");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isFalse);
    });
  });
}
