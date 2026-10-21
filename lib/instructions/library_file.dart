import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/text_signals.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:llm_dart/llm_dart.dart" as llm;
import "package:yaml/yaml.dart";

part "library_file.freezed.dart";

/// A problem in library.yaml or in a proposed change, with its line when it
/// came from the file.
@freezed
abstract class LibraryProblem with _$LibraryProblem implements Exception {
  const LibraryProblem._();

  const factory LibraryProblem(String message, [int? line]) = _LibraryProblem;

  @override
  String toString() => line == null ? message : "Line $line: $message";
}

/// The only way to build a [Library]. The file, every LibraryChange and
/// every assistant proposal pass through here, so an invalid setup is never
/// shown, saved or used.
Library validateLibrary({
  required List<Group> groups,
  required List<Instruction> instructions,
  required List<Profile> profiles,
  required List<InstructionId> defaults,
  required List<String> keepWords,
  ModelRef? defaultModel,
  ModelRef? assistantModel,
}) {
  bool blank(String value) => value.trim().isEmpty;
  final groupIds = <GroupId>{};
  for (final group in groups) {
    if (blank(group.id.value) || blank(group.name)) throw const LibraryProblem("Every group needs an id and a name.");
    if (!groupIds.add(group.id)) throw LibraryProblem("The group id `${group.id.value}` is used twice.");
  }
  final ids = <InstructionId>{};
  final pins = <int>{};
  for (final i in instructions) {
    if (blank(i.id.value) || blank(i.name)) throw const LibraryProblem("Every instruction needs an id and a name.");
    if (blank(i.text)) throw LibraryProblem("`${i.name}` has no text.");
    if (!ids.add(i.id)) throw LibraryProblem("The instruction id `${i.id.value}` is used twice.");
    if (i.pin case final pin? when pin < 1 || pin > 9 || !pins.add(pin)) {
      throw LibraryProblem("`${i.name}`: pin must be a free number from 1 to 9.");
    }
    if (i.group case final g? when !groupIds.contains(g)) {
      throw LibraryProblem("`${i.name}` is in group `${g.value}`, which does not exist.");
    }
  }
  void check(Iterable<InstructionId> used, String where) {
    for (final id in used) {
      if (!ids.contains(id)) throw LibraryProblem("$where uses `${id.value}`, which does not exist.");
    }
  }

  for (final i in instructions) {
    check(i.excludes, "`${i.name}` excludes");
  }
  final names = <String>{};
  for (final p in profiles) {
    if (blank(p.name)) throw const LibraryProblem("Every profile needs a name.");
    if (!names.add(p.name)) throw LibraryProblem("The profile name `${p.name}` is used twice.");
    // A profile without conditions would apply to everything: that is
    // what defaults are for.
    if (p.when.isEmpty) throw LibraryProblem("Profile `${p.name}` has no `when` condition.");
    check(p.use, "Profile `${p.name}`");
  }
  check(defaults, "`defaults`");
  return Library(
    groups: List.unmodifiable(groups),
    instructions: List.unmodifiable(instructions),
    profiles: List.unmodifiable(profiles),
    defaults: List.unmodifiable(defaults),
    keepWords: List.unmodifiable(keepWords),
    defaultModel: defaultModel,
    assistantModel: assistantModel,
  );
}

/// Reads library.yaml. Every mistake in the file, whatever its shape, comes
/// out as a [LibraryProblem], with its line number when it has one.
Library parseLibrary(String source) {
  final Object? root;
  try {
    root = loadYamlNode(source);
  } on YamlException catch (error) {
    // Spans count lines from zero; people count from one.
    throw LibraryProblem(error.message, switch (error.span) {
      final span? => span.start.line + 1,
      null => null,
    });
  }
  if (root is! YamlMap) throw const LibraryProblem("The file must start with `groups:` or `instructions:`.");
  _onlyKeys(root, const {
    "groups",
    "instructions",
    "profiles",
    "defaults",
    "keep_words",
    "default_model",
    "assistant_model",
  }, "the file");
  return validateLibrary(
    groups: [for (final n in _list(root, "groups")) groupFromYaml(_map(n))],
    instructions: [for (final n in _list(root, "instructions")) instructionFromYaml(_map(n))],
    profiles: [for (final n in _list(root, "profiles")) profileFromYaml(_map(n))],
    defaults: [for (final id in _strings(root, "defaults")) InstructionId(id)],
    keepWords: _strings(root, "keep_words"),
    defaultModel: _model(root["default_model"]),
    assistantModel: _model(root["assistant_model"]),
  );
}

Group groupFromYaml(YamlMap map) {
  _onlyKeys(map, const {"id", "name", "pick", "steps"}, "a group");
  return Group(
    id: GroupId(_string(map, "id")),
    name: _string(map, "name"),
    pick: _enum(Pick.values, map, "pick") ?? Pick.one,
    steps: _scalar<bool>(map, "steps", "true or false") ?? false,
  );
}

Instruction instructionFromYaml(YamlMap map) {
  _onlyKeys(map, const {"id", "name", "text", "pin", "group", "excludes"}, "an instruction");
  final group = _optionalString(map, "group");
  return Instruction(
    id: InstructionId(_string(map, "id")),
    name: _string(map, "name"),
    text: _string(map, "text"),
    pin: _scalar<int>(map, "pin", "a whole number"),
    group: group == null ? null : GroupId(group),
    excludes: {for (final id in _strings(map, "excludes")) InstructionId(id)},
  );
}

Profile profileFromYaml(YamlMap map) {
  _onlyKeys(map, const {"name", "when", "use", "model", "options", "keep_words", "deliver"}, "a profile");
  final when = _submap(map, "when");
  _onlyKeys(when, const {"apps", "title", "url", "languages", "min_words", "max_words", "contains"}, "`when`");
  RegExp? pattern(String key) {
    final source = _optionalString(when, key);
    if (source == null) return null;
    try {
      return RegExp(source, caseSensitive: false);
    } on FormatException catch (error) {
      throw LibraryProblem("`$key` is not a valid pattern: ${error.message}", _lineOf(when, key));
    }
  }

  final options = _submap(map, "options");
  _onlyKeys(options, const {"temperature", "reasoning_effort"}, "`options`");
  return Profile(
    name: _string(map, "name"),
    when: When(
      apps: {for (final a in _strings(when, "apps")) a.toLowerCase()},
      title: pattern("title"),
      url: pattern("url"),
      languages: _strings(when, "languages").toSet(),
      minWords: _scalar<int>(when, "min_words", "a whole number"),
      maxWords: _scalar<int>(when, "max_words", "a whole number"),
      contains: {for (final c in _strings(when, "contains")) _byName(Content.values, c, when)},
    ),
    use: [for (final id in _strings(map, "use")) InstructionId(id)],
    model: _model(map["model"]),
    options: ModelOptions(
      temperature: _scalar<num>(options, "temperature", "a number")?.toDouble(),
      reasoningEffort: _enum(llm.ReasoningEffort.values, options, "reasoning_effort"),
    ),
    keepWords: _strings(map, "keep_words"),
    deliver: _enum(DeliveryMode.values, map, "deliver"),
  );
}

/// The YAML form written back by LibraryStore, the inverse of the readers.
Map<String, Object?> groupToYaml(Group g) => {
  "id": g.id.value,
  "name": g.name,
  if (g.pick != Pick.one) "pick": g.pick.name,
  if (g.steps) "steps": true,
};

Map<String, Object?> instructionToYaml(Instruction i) => {
  "id": i.id.value,
  "name": i.name,
  if (i.group != null) "group": i.group!.value,
  if (i.pin != null) "pin": i.pin,
  if (i.excludes.isNotEmpty) "excludes": [for (final e in i.excludes) e.value],
  "text": i.text,
};

Map<String, Object?> profileToYaml(Profile p) => {
  "name": p.name,
  "when": {
    if (p.when.apps.isNotEmpty) "apps": p.when.apps.toList(),
    if (p.when.title != null) "title": p.when.title!.pattern,
    if (p.when.url != null) "url": p.when.url!.pattern,
    if (p.when.languages.isNotEmpty) "languages": p.when.languages.toList(),
    if (p.when.minWords != null) "min_words": p.when.minWords,
    if (p.when.maxWords != null) "max_words": p.when.maxWords,
    if (p.when.contains.isNotEmpty) "contains": [for (final c in p.when.contains) c.name],
  },
  "use": [for (final id in p.use) id.value],
  if (p.model != null) "model": p.model.toString(),
  if (p.options != const ModelOptions())
    "options": {
      if (p.options.temperature != null) "temperature": p.options.temperature,
      if (p.options.reasoningEffort != null) "reasoning_effort": _snake(p.options.reasoningEffort!.name),
    },
  if (p.keepWords.isNotEmpty) "keep_words": p.keepWords,
  if (p.deliver != null) "deliver": _snake(p.deliver!.name),
};

ModelRef? _model(Object? value) => value is String ? ModelRef.tryParse(value) : null;

T? _enum<T extends Enum>(List<T> values, YamlMap map, String key) {
  final raw = map[key];
  return raw == null ? null : _byName(values, raw.toString(), map);
}

/// Enum values are written in snake_case in the file: paste_rich.
T _byName<T extends Enum>(List<T> values, String name, YamlMap at) =>
    values.asNameMap()[name.replaceAllMapped(RegExp("_([a-z])"), (m) => m[1]!.toUpperCase())] ??
    (throw LibraryProblem("`$name` must be one of ${values.map((v) => _snake(v.name)).join(", ")}.", _line(at)));

String _snake(String name) => name.replaceAllMapped(RegExp("[A-Z]"), (m) => "_${m[0]!.toLowerCase()}");

// Typed readers. Each one turns a value of the wrong kind into a
// LibraryProblem that names the key and its line, so a hand edit can never
// surface as a TypeError.

/// An empty key (`groups:` with nothing after it) reads as absent.
YamlNode? _node(YamlMap map, String key) {
  final node = map.nodes[key];
  return node is YamlScalar && node.value == null ? null : node;
}

T? _scalar<T>(YamlMap map, String key, String expected) {
  final value = _node(map, key)?.value;
  if (value == null || value is T) return value as T?;
  throw LibraryProblem("`$key` must be $expected.", _lineOf(map, key));
}

String? _optionalString(YamlMap map, String key) {
  final value = _scalar<String>(map, key, "text")?.trim();
  return value == null || value.isEmpty ? null : value;
}

String _string(YamlMap map, String key) =>
    _optionalString(map, key) ?? (throw LibraryProblem("`$key` is missing or empty.", _lineOf(map, key)));

List<YamlNode> _list(YamlMap map, String key) {
  final node = _node(map, key);
  if (node == null) return const [];
  if (node is! YamlList) throw LibraryProblem("`$key` must be a list.", _line(node));
  return node.nodes;
}

/// Words, ids and names: numbers are accepted as text, nested maps are not.
List<String> _strings(YamlMap map, String key) => [
  for (final n in _list(map, key))
    if (n is YamlScalar && n.value != null)
      n.value.toString()
    else
      throw LibraryProblem("Each item in `$key` must be a single value.", _line(n)),
];

YamlMap _submap(YamlMap map, String key) {
  final node = _node(map, key);
  return node == null ? YamlMap() : _map(node);
}

YamlMap _map(YamlNode node) =>
    node is YamlMap ? node : throw LibraryProblem("Expected a map with named fields.", _line(node));

int _lineOf(YamlMap map, String key) => _line(map.nodes[key] ?? map);

int _line(YamlNode node) => node.span.start.line + 1;

/// Unknown keys are mistakes, usually a comma inside an unquoted text in
/// the `{id: ..., text: ...}` form, which silently cuts the text short: the
/// rest of the sentence becomes a key of its own.
void _onlyKeys(YamlMap map, Set<String> known, String where) {
  final keys = [for (final key in map.keys) "$key"];
  for (final (at, key) in keys.indexed) {
    if (known.contains(key)) continue;
    // The tail of a sentence, not a misspelled key: name the value it was
    // cut from, and whose it is.
    if (at > 0 && (key.contains(" ") || key.endsWith("."))) {
      final field = keys[at - 1];
      final owner = map["id"] ?? map["name"];
      throw LibraryProblem(
        "The $field of ${owner == null ? where : "`$owner`"} has a comma, so YAML cut it off. "
        'Put the $field in quotes: $field: "..."',
        _lineOf(map, key),
      );
    }
    throw LibraryProblem(
      "Unknown key `$key` in $where. Known keys: ${known.join(", ")}. "
      "If a text has a comma, put the text in quotes.",
      _lineOf(map, key),
    );
  }
}
