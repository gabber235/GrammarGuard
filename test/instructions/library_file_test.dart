import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/instructions/text_signals.dart";
import "package:grammar_guard/platform/ports.dart";

import "package:yaml/yaml.dart";

import "../support/library.dart";

void main() {
  test("the bundled library parses and round trips through the YAML writers", () {
    final library = bundled();
    expect(library.instructions.map((i) => i.id.value), containsAll(["fix-only", "discord", "keep-code"]));
    for (final p in library.profiles) {
      expect(profileFromYaml(_yaml(profileToYaml(p))).name, p.name);
    }
  });

  test("a comma in an unquoted text is caught, not cut short", () {
    expect(
      () => parseLibrary("instructions:\n  - {id: casual, name: Casual, text: Use a relaxed, friendly tone.}\n"),
      throwsA(isA<LibraryProblem>().having((p) => p.message, "message", contains("Unknown key `friendly tone.`"))),
    );
    // The bundled file passes the same check, so every text is complete.
    expect(bundled()[const InstructionId("casual")]?.text, "Use a relaxed, friendly tone.");
  });

  test("errors name the line", () {
    expect(
      () => parseLibrary("instructions:\n  - id: a\n    name: A\n"),
      throwsA(isA<LibraryProblem>().having((p) => p.toString(), "message", contains("Line 2"))),
    );
  });

  test("references, pins and empty profiles are validated", () {
    const head = "instructions:\n  - {id: a, name: A, text: t, pin: 1}\n";
    expect(() => parseLibrary("${head}defaults: [b]\n"), throwsA(isA<LibraryProblem>()));
    expect(() => parseLibrary("$head  - {id: c, name: C, text: t, pin: 1}\n"), throwsA(isA<LibraryProblem>()));
    expect(() => parseLibrary("${head}profiles:\n  - {name: P, use: [a]}\n"), throwsA(isA<LibraryProblem>()));
    expect(() => parseLibrary("$head  - {id: d, name: D, text: t, group: nope}\n"), throwsA(isA<LibraryProblem>()));
  });

  test("a value of the wrong kind is a LibraryProblem with its line, never a TypeError", () {
    Matcher problemOnLine(int line, String words) => throwsA(
      isA<LibraryProblem>().having((p) => p.line, "line", line).having((p) => p.message, "message", contains(words)),
    );
    const a = "instructions:\n  - {id: a, name: A, text: t}\n";
    expect(
      () => parseLibrary("instructions:\n  - id: a\n    name: A\n    text: t\n    group: 5\n"),
      problemOnLine(5, "group"),
    );
    expect(
      () => parseLibrary("instructions:\n  - id: a\n    name: A\n    text: t\n    pin: \"x\"\n"),
      problemOnLine(5, "pin"),
    );
    expect(
      () => parseLibrary("${a}profiles:\n  - name: P\n    use: [a]\n    when:\n      min_words: ten\n"),
      problemOnLine(7, "min_words"),
    );
    expect(
      () => parseLibrary("${a}profiles:\n  - name: P\n    use: [a]\n    when:\n      title: \"(\"\n"),
      problemOnLine(7, "title"),
    );
    expect(
      () => parseLibrary("${a}profiles:\n  - {name: P, use: [a], when: {apps: [x]}, options: {temperature: hot}}\n"),
      throwsA(isA<LibraryProblem>()),
    );
    expect(() => parseLibrary("${a}defaults: [{a: b}]\n"), throwsA(isA<LibraryProblem>()));
  });

  test("YAML syntax errors count lines from one", () {
    expect(
      () => parseLibrary("instructions:\n  - {id: a, name: A, text: t}\n  - {id: b\n"),
      throwsA(isA<LibraryProblem>().having((p) => p.line, "line", greaterThanOrEqualTo(3))),
    );
  });

  test("an empty list key reads as no items", () {
    expect(parseLibrary("instructions:\n  - {id: a, name: A, text: t}\nprofiles:\n").profiles, isEmpty);
  });

  test("names and texts may not be empty, whoever builds the library", () {
    Library build({String name = "A", String text = "t", String profile = "P"}) => validateLibrary(
      groups: const [],
      instructions: [Instruction(id: const InstructionId("a"), name: name, text: text)],
      profiles: [
        Profile(
          name: profile,
          when: const When(apps: {"x"}),
          use: const [InstructionId("a")],
        ),
      ],
      defaults: const [],
      keepWords: const [],
    );
    expect(build().instructions, hasLength(1));
    expect(() => build(name: " "), throwsA(isA<LibraryProblem>()));
    expect(() => build(text: ""), throwsA(isA<LibraryProblem>()));
    expect(() => build(profile: ""), throwsA(isA<LibraryProblem>()));
  });

  test("enum values are snake case in the file", () {
    final library = parseLibrary("""
instructions:
  - {id: a, name: A, text: t}
profiles:
  - {name: Mail, when: {apps: [mail]}, use: [a], deliver: paste_rich, options: {reasoning_effort: medium}}
""");
    expect(library.profiles.single.deliver, DeliveryMode.pasteRich);
    expect(profileToYaml(library.profiles.single)["deliver"], "paste_rich");
  });

  test("conditions: place is any of apps, title or url; text conditions all hold", () {
    final when = When(apps: const {"slack"}, title: RegExp("Slack"), languages: const {"nl"}, maxWords: 50);
    const slack = SourceApp(id: "slack", name: "Slack", processId: 1);
    final dutch = TextSignals.of("Ik heb het gisteren gedaan maar het werkt niet");
    final english = TextSignals.of("I did it yesterday but it does not work and that is fine");
    expect(when.matches(slack, dutch), isTrue);
    expect(when.matches(slack, english), isFalse);
    expect(when.matches(null, dutch), isFalse);
  });

  test("text signals", () {
    final signals = TextSignals.of("Run `npm test` and see https://x.dev\n- one\n- two");
    expect(signals.contains, containsAll([Content.code, Content.link, Content.list]));
    expect(TextSignals.of("hi").language, isNull);
  });
}

YamlMap _yaml(Map<String, Object?> map) => loadYaml(jsonEncode(map)) as YamlMap;
