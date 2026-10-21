// "You always pick Shorter here. Make a profile?"
// Deterministic and local: no model call, no network.
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/rewrite/history.dart";

/// A profile worth proposing for [source], or null. Needs at least 3
/// rewrites in an app without its own profile, and instructions the user
/// picked in at least two thirds of them.
PutProfile? suggestProfile(Library library, SourceApp source, List<HistoryEntry> history) {
  if (library.appProfile(source.id) != null) return null;
  final here = history.where((e) => e.appId == source.id).take(10).toList();
  if (here.length < 3) return null;
  final counts = <String, int>{};
  for (final entry in here) {
    for (final id in entry.picked.toSet()) {
      counts.update(id, (n) => n + 1, ifAbsent: () => 1);
    }
  }
  final habits = [
    for (final MapEntry(:key, :value) in counts.entries)
      if (value * 3 >= here.length * 2 && library[InstructionId(key)] != null) InstructionId(key),
  ];
  if (habits.isEmpty) return null;
  return PutProfile(
    Profile(
      name: source.name,
      when: When(apps: {source.id}),
      use: habits,
    ),
  );
}
