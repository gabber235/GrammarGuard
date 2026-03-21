import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/state/window_lifecycle.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("WindowLifecyclePolicy", () {
    late ProviderContainer container;
    late WindowLifecycle notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(windowLifecycleProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test("shouldHide is true when hide is requested and not generating", () {
      notifier.onEscapePressed();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isTrue);
    });

    test("shouldHide is false during generation", () {
      notifier.onGenerationStarted();
      notifier.onEscapePressed();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldHide, isFalse);
    });

    test("shouldRefresh is true only after reopen with changed clipboard", () {
      notifier.onClipboardSynced("old");
      notifier.onWindowHidden();
      notifier.onWindowShown();
      notifier.evaluateRefresh("new");

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.shouldRefresh, isTrue);
    });

    test("canClose is false while generation is active", () {
      notifier.onGenerationStarted();
      notifier.onCloseRequested();

      final policy = container.read(windowLifecyclePolicyProvider);
      expect(policy.canClose, isFalse);
    });
  });
}
