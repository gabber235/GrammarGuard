import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/text_signals.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";

/// Applies the layers in order: defaults, every matching profile in file
/// order, then the user's picks. A layer only changes what it names. Inside
/// a pick-one group, and between instructions that exclude each other, the
/// later layer wins. The result lists instructions in library file order,
/// so the same set always composes the same prompt and hits the run cache.
Resolved resolve(Library library, SourceApp? source, String text, RunChoices run) {
  final signals = TextSignals.of(text);
  final pickedProfile = run.profile;
  final profiles = pickedProfile == null
      ? library.profilesFor(source, signals)
      : [...library.profiles.where((p) => p.name == pickedProfile)];
  final chosen = <InstructionId, Origin>{};

  void apply(InstructionId id, Origin origin) {
    // Run choices may name an instruction that a file edit just removed.
    final instruction = library[id];
    if (instruction == null) return;
    final group = instruction.group == null ? null : library.group(instruction.group!);
    chosen.removeWhere((otherId, _) {
      final other = library[otherId];
      if (other == null) return true;
      final sameGroup = group != null && group.pick == Pick.one && other.group == group.id;
      final clash = instruction.excludes.contains(otherId) || other.excludes.contains(id);
      return sameGroup || clash;
    });
    chosen[id] = origin;
  }

  for (final id in library.defaults) {
    apply(id, const Origin.defaults());
  }
  for (final profile in profiles) {
    for (final id in profile.use) {
      apply(id, Origin.profile(profile.name));
    }
  }
  for (final id in run.added) {
    apply(id, const Origin.you());
  }
  run.removed.forEach(chosen.remove);

  // The model is one more layer with the same precedence.
  var model = library.defaultModel == null ? null : ActiveModel(library.defaultModel!, const Origin.defaults());
  var options = const ModelOptions();
  DeliveryMode? deliver;
  for (final profile in profiles) {
    if (profile.model case final ref?) model = ActiveModel(ref, Origin.profile(profile.name));
    options = options.copyWith(
      temperature: profile.options.temperature ?? options.temperature,
      reasoningEffort: profile.options.reasoningEffort ?? options.reasoningEffort,
    );
    deliver = profile.deliver ?? deliver;
  }
  if (run.model case final ref?) model = ActiveModel(ref, const Origin.you());

  return Resolved(
    source: source,
    signals: signals,
    profiles: profiles,
    active: [
      for (final instruction in library.instructions)
        if (chosen[instruction.id] case final origin?) ActiveInstruction(instruction, origin),
    ],
    words: run.words.trim(),
    keepWords: {...library.keepWords, for (final p in profiles) ...p.keepWords}.toList(),
    model: model,
    options: options,
    deliver: deliver ?? DeliveryMode.paste,
  );
}

/// [ and ]: the next level in the stepped group that is active (or the
/// first stepped group). Null at either end.
Instruction? stepInGroup(Library library, Resolved resolved, int delta) {
  final stepped = library.groups.where((g) => g.steps).toList();
  if (stepped.isEmpty) return null;
  final activeIds = {for (final a in resolved.active) a.instruction.id};
  final group = stepped.firstWhere(
    (g) => library.members(g.id).any((i) => activeIds.contains(i.id)),
    orElse: () => stepped.first,
  );
  final members = library.members(group.id);
  final at = members.indexWhere((i) => activeIds.contains(i.id));
  final next = (at < 0 ? 0 : at) + delta;
  return next < 0 || next >= members.length ? null : members[next];
}
