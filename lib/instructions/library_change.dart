import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_file.dart";
import "package:grammar_guard/llm/llm.dart";

part "library_change.freezed.dart";

/// One edit to the setup. ⇧Enter and ⌘Enter in the bar, S, the settings
/// screen and the assistant all produce these, and only these.
@freezed
sealed class LibraryChange with _$LibraryChange {
  const LibraryChange._();

  /// Adds the instruction, or replaces the one with the same id.
  const factory LibraryChange.putInstruction(Instruction instruction) = PutInstruction;
  const factory LibraryChange.removeInstruction(InstructionId id) = RemoveInstruction;

  /// Adds the profile, or replaces the one with the same name.
  const factory LibraryChange.putProfile(Profile profile) = PutProfile;
  const factory LibraryChange.removeProfile(String name) = RemoveProfile;
  const factory LibraryChange.putGroup(Group group) = PutGroup;

  /// Removes the group; its members stay, without a group.
  const factory LibraryChange.removeGroup(GroupId id) = RemoveGroup;

  /// The "always" layer. Null fields stay as they are.
  const factory LibraryChange.setDefaults({
    List<InstructionId>? use,
    ModelRef? model,
    ModelRef? assistantModel,
    List<String>? keepWords,
  }) = SetDefaults;

  /// One line for proposals and the change log.
  String get summary => switch (this) {
    PutInstruction(:final instruction) => "Instruction ${instruction.name}",
    RemoveInstruction(:final id) => "Remove instruction ${id.value}",
    PutProfile(:final profile) => "Profile ${profile.name}",
    RemoveProfile(:final name) => "Remove profile $name",
    PutGroup(:final group) => "Group ${group.name}",
    RemoveGroup(:final id) => "Remove group ${id.value}",
    SetDefaults() => "Defaults",
  };

  /// Two changes with the same key replace each other in a proposal.
  String get key => switch (this) {
    PutInstruction(:final instruction) => "instruction:${instruction.id.value}",
    RemoveInstruction(:final id) => "instruction:${id.value}",
    PutProfile(:final profile) => "profile:${profile.name}",
    RemoveProfile(:final name) => "profile:$name",
    PutGroup(:final group) => "group:${group.id.value}",
    RemoveGroup(:final id) => "group:${id.value}",
    SetDefaults() => "defaults",
  };
}

/// What the setup becomes after [changes]. Pure; used for the proposal
/// preview, for validating the assistant's tool calls, and before writing.
/// Throws [LibraryProblem] when the result would be invalid.
Library applyChanges(Library library, List<LibraryChange> changes) {
  var next = library;
  List<T> put<T>(List<T> list, T item, bool Function(T) same) {
    final at = list.indexWhere(same);
    return at < 0 ? [...list, item] : [...list.take(at), item, ...list.skip(at + 1)];
  }

  for (final change in changes) {
    next = switch (change) {
      PutInstruction(:final instruction) => next.copyWith(
        instructions: put(next.instructions, instruction, (i) => i.id == instruction.id),
      ),
      // Removing an instruction also takes it out of everything using it.
      RemoveInstruction(:final id) => next.copyWith(
        instructions: [
          for (final i in next.instructions)
            if (i.id != id) i.copyWith(excludes: i.excludes.difference({id})),
        ],
        defaults: [...next.defaults.where((d) => d != id)],
        profiles: [
          for (final p in next.profiles) p.copyWith(use: [...p.use.where((u) => u != id)]),
        ],
      ),
      PutProfile(:final profile) => next.copyWith(profiles: put(next.profiles, profile, (p) => p.name == profile.name)),
      RemoveProfile(:final name) => next.copyWith(profiles: [...next.profiles.where((p) => p.name != name)]),
      PutGroup(:final group) => next.copyWith(groups: put(next.groups, group, (g) => g.id == group.id)),
      RemoveGroup(:final id) => next.copyWith(
        groups: [...next.groups.where((g) => g.id != id)],
        instructions: [
          for (final i in next.instructions)
            if (i.group == id) i.copyWith(group: null) else i,
        ],
      ),
      SetDefaults(:final use, :final model, :final assistantModel, :final keepWords) => next.copyWith(
        defaults: use ?? next.defaults,
        defaultModel: model ?? next.defaultModel,
        assistantModel: assistantModel ?? next.assistantModel,
        keepWords: keepWords ?? next.keepWords,
      ),
    };
  }

  return validateLibrary(
    groups: next.groups,
    instructions: next.instructions,
    profiles: next.profiles,
    defaults: next.defaults,
    keepWords: next.keepWords,
    defaultModel: next.defaultModel,
    assistantModel: next.assistantModel,
  );
}
