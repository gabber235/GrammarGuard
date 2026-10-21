import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/resolve.dart";

import "../support/library.dart"; // bundled() parses assets/library.yaml

void main() {
  test("removing an instruction also removes it from defaults and profiles", () {
    final next = applyChanges(bundled(), [const LibraryChange.removeInstruction(InstructionId("casual"))]);
    expect(next.profiles.singleWhere((p) => p.name == "Discord").use, [const InstructionId("discord")]);
  });

  test("a profile using an unknown instruction is rejected", () {
    expect(
      () => applyChanges(bundled(), [
        const LibraryChange.putProfile(
          Profile(
            name: "X",
            when: When(apps: {"x"}),
            use: [InstructionId("nope")],
          ),
        ),
      ]),
      throwsA(isA<LibraryProblem>()),
    );
  });

  test("groups: a later pick replaces its group mate, excludes work across groups", () {
    final library = bundled();
    final resolved = resolve(
      library,
      null,
      "a b c d",
      const RunChoices().turnOn(InstructionId("shorter")).turnOn(InstructionId("fix-only")),
    );
    final on = {for (final a in resolved.active) a.instruction.id.value};
    expect(on, containsAll(["fix-only"]));
    expect(on, isNot(contains("polish"))); // same group, replaced
    expect(on, isNot(contains("shorter"))); // fix-only excludes it
  });

  test("language and content conditions stack profiles", () {
    final resolved = resolve(bundled(), null, "Kun je `npm test` draaien? Het werkt niet.", const RunChoices());
    expect(resolved.signals.language, "nl");
    expect(resolved.profiles.map((p) => p.name), ["Code in the text"]);
  });

  test("a profile without any condition is rejected", () {
    expect(
      () => applyChanges(bundled(), [const LibraryChange.putProfile(Profile(name: "X", when: When()))]),
      throwsA(isA<LibraryProblem>()),
    );
  });
}
