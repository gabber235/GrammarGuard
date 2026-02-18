import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/state/ai_rewrite.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("RewriteGenerationActivity", () {
    late ProviderContainer container;
    late RewriteGenerationActivity notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(rewriteGenerationActivityProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test("starts inactive", () {
      final active = container.read(rewriteGenerationActivityProvider);
      expect(active, isFalse);
    });

    test("becomes active when started", () {
      notifier.started();

      final active = container.read(rewriteGenerationActivityProvider);
      expect(active, isTrue);
    });

    test("returns inactive when finished", () {
      notifier.started();
      notifier.finished();

      final active = container.read(rewriteGenerationActivityProvider);
      expect(active, isFalse);
    });

    test("stays active across listener churn", () async {
      final sub = container.listen<bool>(
        rewriteGenerationActivityProvider,
        (_, __) {},
      );

      notifier.started();
      expect(container.read(rewriteGenerationActivityProvider), isTrue);

      sub.close();
      await container.pump();

      expect(container.read(rewriteGenerationActivityProvider), isTrue);
    });
  });
}
