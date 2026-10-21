// The three scopes as pure functions.
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";

enum Scope {
  /// This text only: a RunChoices change, nothing is saved.
  now,

  /// Saved into the profile for the app the text came from.
  app,

  /// Saved into the defaults, for every app.
  always,
}

/// Typed words as a reusable instruction with a readable, unused id.
Instruction wordsInstruction(Library library, String words) {
  final base = words.toLowerCase().replaceAll(RegExp("[^a-z0-9]+"), "-").replaceAll(RegExp(r"^-+|-+$"), "");
  final stem = base.isEmpty ? "custom" : base.substring(0, base.length.clamp(0, 24));
  var id = stem;
  for (var n = 2; library[InstructionId(id)] != null; n++) {
    id = "$stem-$n";
  }
  return Instruction(id: InstructionId(id), name: words, text: words);
}

/// The profile that belongs to [source], or a new one matching only it.
/// Other matching profiles (language, length, content) are left alone.
Profile _appProfile(Library library, SourceApp source) =>
    library.appProfile(source.id) ?? newAppProfile(library, source);

/// A new profile matching only [source]. Profiles are saved by name, so a
/// name already in use (Flatpak Discord next to the bundled Discord) gets
/// the app id added instead of replacing the other profile.
Profile newAppProfile(Library library, SourceApp source) {
  final taken = {for (final p in library.profiles) p.name};
  return Profile(
    name: taken.contains(source.name) ? "${source.name} (${source.id})" : source.name,
    when: When(apps: {source.id}),
  );
}

/// S: everything picked for now (instructions, words, model) becomes part
/// of the app's own profile.
List<LibraryChange> keepForApp(Library library, Resolved resolved, SourceApp source) {
  final profile = _appProfile(library, source);
  final picked = [
    for (final a in resolved.active)
      if (a.origin is FromYou) a.instruction.id,
  ];
  final words = resolved.words.isEmpty ? null : wordsInstruction(library, resolved.words);
  final model = resolved.model;
  return [
    if (words != null) LibraryChange.putInstruction(words),
    LibraryChange.putProfile(
      profile.copyWith(
        use: {...profile.use, ...picked, if (words != null) words.id}.toList(),
        model: model != null && model.origin is FromYou ? model.ref : profile.model,
      ),
    ),
  ];
}

/// ⇧Enter or ⌘Enter on one bar row: that single item, saved at [scope].
List<LibraryChange> keepOne(
  Library library,
  Resolved resolved,
  Scope scope, {
  Instruction? instruction,
  ModelRef? model,
}) {
  final isNew = instruction != null && library[instruction.id] == null;
  final source = resolved.source;
  switch (scope) {
    case Scope.now:
      return const [];
    case Scope.always:
      return [
        if (isNew) LibraryChange.putInstruction(instruction),
        LibraryChange.setDefaults(
          use: instruction == null ? null : [...library.defaults.where((d) => d != instruction.id), instruction.id],
          model: model,
        ),
      ];
    case Scope.app:
      if (source == null) return const []; // clipboard text: no app to save for
      final profile = _appProfile(library, source);
      return [
        if (isNew) LibraryChange.putInstruction(instruction),
        LibraryChange.putProfile(
          profile.copyWith(
            use: {...profile.use, if (instruction != null) instruction.id}.toList(),
            model: model ?? profile.model,
          ),
        ),
      ];
  }
}
