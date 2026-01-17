import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/state/ai_usage.dart";

void main() {
  group("RequestUsage", () {
    group("creation", () {
      test("creates with all required fields", () {
        final usage = RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        expect(usage.promptTokenCount, equals(100));
        expect(usage.completionTokenCount, equals(50));
        expect(usage.modelName, equals("gpt-4"));
        expect(usage.providerName, equals("openai"));
        expect(usage.cost, equals(0.005));
      });

      test("creates with zero tokens", () {
        final usage = RequestUsage(
          promptTokenCount: 0,
          completionTokenCount: 0,
          modelName: "test-model",
          providerName: "test-provider",
          cost: 0.0,
        );

        expect(usage.promptTokenCount, equals(0));
        expect(usage.completionTokenCount, equals(0));
        expect(usage.cost, equals(0.0));
      });

      test("creates with large token counts", () {
        final usage = RequestUsage(
          promptTokenCount: 1000000,
          completionTokenCount: 500000,
          modelName: "large-model",
          providerName: "provider",
          cost: 100.0,
        );

        expect(usage.promptTokenCount, equals(1000000));
        expect(usage.completionTokenCount, equals(500000));
      });
    });

    group("serialization", () {
      test("toJson produces correct map", () {
        final usage = RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        final json = usage.toJson();

        expect(json["promptTokenCount"], equals(100));
        expect(json["completionTokenCount"], equals(50));
        expect(json["modelName"], equals("gpt-4"));
        expect(json["providerName"], equals("openai"));
        expect(json["cost"], equals(0.005));
      });

      test("fromJson creates correct object", () {
        final json = {
          "promptTokenCount": 200,
          "completionTokenCount": 100,
          "modelName": "claude-3",
          "providerName": "anthropic",
          "cost": 0.01,
        };

        final usage = RequestUsage.fromJson(json);

        expect(usage.promptTokenCount, equals(200));
        expect(usage.completionTokenCount, equals(100));
        expect(usage.modelName, equals("claude-3"));
        expect(usage.providerName, equals("anthropic"));
        expect(usage.cost, equals(0.01));
      });

      test("roundtrip serialization preserves data", () {
        final original = RequestUsage(
          promptTokenCount: 150,
          completionTokenCount: 75,
          modelName: "gemini-pro",
          providerName: "google",
          cost: 0.0075,
        );

        final json = original.toJson();
        final restored = RequestUsage.fromJson(json);

        expect(restored.promptTokenCount, equals(original.promptTokenCount));
        expect(
          restored.completionTokenCount,
          equals(original.completionTokenCount),
        );
        expect(restored.modelName, equals(original.modelName));
        expect(restored.providerName, equals(original.providerName));
        expect(restored.cost, equals(original.cost));
      });
    });

    group("equality", () {
      test("equal objects are equal", () {
        final usage1 = RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        final usage2 = RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        expect(usage1, equals(usage2));
      });

      test("different objects are not equal", () {
        final usage1 = RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        final usage2 = RequestUsage(
          promptTokenCount: 200,
          completionTokenCount: 50,
          modelName: "gpt-4",
          providerName: "openai",
          cost: 0.005,
        );

        expect(usage1, isNot(equals(usage2)));
      });
    });
  });

  group("Cost calculation", () {
    test("cost calculation formula is correct", () {
      const pricePerMillionInput = 10.0;
      const pricePerMillionOutput = 30.0;

      const promptTokens = 1000;
      const completionTokens = 500;

      final cost =
          (promptTokens / 1000000 * pricePerMillionInput) +
          (completionTokens / 1000000 * pricePerMillionOutput);

      expect(cost, equals(0.01 + 0.015));
      expect(cost, equals(0.025));
    });

    test("zero tokens results in zero cost", () {
      const pricePerMillionInput = 10.0;
      const pricePerMillionOutput = 30.0;

      const promptTokens = 0;
      const completionTokens = 0;

      final cost =
          (promptTokens / 1000000 * pricePerMillionInput) +
          (completionTokens / 1000000 * pricePerMillionOutput);

      expect(cost, equals(0.0));
    });

    test("one million tokens at 1 dollar per million equals 2 dollars", () {
      const pricePerMillionInput = 1.0;
      const pricePerMillionOutput = 1.0;

      const promptTokens = 1000000;
      const completionTokens = 1000000;

      final cost =
          (promptTokens / 1000000 * pricePerMillionInput) +
          (completionTokens / 1000000 * pricePerMillionOutput);

      expect(cost, equals(2.0));
    });

    test("gemini 2.0 flash pricing example", () {
      const pricePerMillionInput = 0.1;
      const pricePerMillionOutput = 0.4;

      const promptTokens = 10000;
      const completionTokens = 2000;

      final cost =
          (promptTokens / 1000000 * pricePerMillionInput) +
          (completionTokens / 1000000 * pricePerMillionOutput);

      expect(cost, closeTo(0.001 + 0.0008, 0.0001));
    });

    test("gemini 2.5 pro pricing example", () {
      const pricePerMillionInput = 1.25;
      const pricePerMillionOutput = 2.5;

      const promptTokens = 50000;
      const completionTokens = 10000;

      final cost =
          (promptTokens / 1000000 * pricePerMillionInput) +
          (completionTokens / 1000000 * pricePerMillionOutput);

      expect(cost, closeTo(0.0625 + 0.025, 0.0001));
    });
  });

  group("Token aggregation", () {
    test("total tokens from multiple usages", () {
      final usages = [
        RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "model1",
          providerName: "provider1",
          cost: 0.01,
        ),
        RequestUsage(
          promptTokenCount: 200,
          completionTokenCount: 100,
          modelName: "model2",
          providerName: "provider2",
          cost: 0.02,
        ),
        RequestUsage(
          promptTokenCount: 300,
          completionTokenCount: 150,
          modelName: "model3",
          providerName: "provider3",
          cost: 0.03,
        ),
      ];

      final totalTokens = usages.fold<int>(
        0,
        (prev, usage) =>
            prev + usage.promptTokenCount + usage.completionTokenCount,
      );

      expect(totalTokens, equals(100 + 50 + 200 + 100 + 300 + 150));
      expect(totalTokens, equals(900));
    });

    test("total cost from multiple usages", () {
      final usages = [
        RequestUsage(
          promptTokenCount: 100,
          completionTokenCount: 50,
          modelName: "model1",
          providerName: "provider1",
          cost: 0.01,
        ),
        RequestUsage(
          promptTokenCount: 200,
          completionTokenCount: 100,
          modelName: "model2",
          providerName: "provider2",
          cost: 0.02,
        ),
        RequestUsage(
          promptTokenCount: 300,
          completionTokenCount: 150,
          modelName: "model3",
          providerName: "provider3",
          cost: 0.03,
        ),
      ];

      final totalCost = usages.fold<double>(
        0,
        (prev, usage) => prev + usage.cost,
      );

      expect(totalCost, closeTo(0.06, 0.0001));
    });

    test("empty usage list returns zero totals", () {
      final usages = <RequestUsage>[];

      final totalTokens = usages.fold<int>(
        0,
        (prev, usage) =>
            prev + usage.promptTokenCount + usage.completionTokenCount,
      );
      final totalCost = usages.fold<double>(
        0,
        (prev, usage) => prev + usage.cost,
      );

      expect(totalTokens, equals(0));
      expect(totalCost, equals(0.0));
    });
  });
}
