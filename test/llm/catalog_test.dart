import "dart:io";

import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/llm.dart";

void main() {
  test("the bundled list knows which models can call tools", () {
    final bundled = parseBundledModels(File("assets/models.json").readAsStringSync());
    // The priciest Google model draws images and has no tools, so the
    // assistant must not pick it.
    expect(bundled[Backend.google]!["gemini-3-pro-image"]?.tools, isFalse);
    expect(bundled[Backend.anthropic]!.values.map((m) => m.tools), everyElement(isTrue));
  });
}
