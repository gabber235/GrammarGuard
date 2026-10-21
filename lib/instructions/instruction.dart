import "package:collection/collection.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/text_signals.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/ports.dart";

part "instruction.freezed.dart";

/// Stable name of an instruction in library.yaml, such as `fix-only`.
extension type const InstructionId(String value) {}

/// Stable name of a group, such as `edit` or `tone`.
extension type const GroupId(String value) {}

enum Pick {
  /// Picking one member replaces the others (edit level, tone, format).
  one,

  /// Members combine freely.
  many,
}

/// A named set of instructions. Shown as one row in the bar and Settings,
/// and explained to the assistant.
@freezed
abstract class Group with _$Group {
  const factory Group({
    required GroupId id,
    required String name,
    @Default(Pick.one) Pick pick,

    /// Members are ordered levels; [ and ] step through them (Fix only,
    /// Polish, Enhance, Rewrite).
    @Default(false) bool steps,
  }) = _Group;
}

/// One piece of guidance for the model. Every rewrite option is one of these.
@freezed
abstract class Instruction with _$Instruction {
  const factory Instruction({
    required InstructionId id,

    /// Shown in the bar and Settings, and what the bar searches.
    required String name,

    /// Sent to the model as written.
    required String text,

    /// Number key 1 to 9 that toggles it. Unique in a library.
    int? pin,
    GroupId? group,

    /// Instructions that cannot be on together with this one, across
    /// groups: turning this on turns those off (Fix only excludes Rewrite
    /// style requests such as Shorter).
    @Default(<InstructionId>{}) Set<InstructionId> excludes,
  }) = _Instruction;
}

/// When a profile applies. Where: any of apps, title or URL matches (or
/// none is set). What: every text condition that is set holds.
@freezed
abstract class When with _$When {
  const When._();

  const factory When({
    /// Lowercased bundle ids, exe names or WM_CLASS values.
    @Default(<String>{}) Set<String> apps,
    RegExp? title,

    /// Browser tab address, where the OS exposes it.
    RegExp? url,

    /// ISO 639-1 codes, such as nl or en, from [TextSignals.language].
    @Default(<String>{}) Set<String> languages,
    int? minWords,
    int? maxWords,
    @Default(<Content>{}) Set<Content> contains,
  }) = _When;

  bool get hasPlace => apps.isNotEmpty || title != null || url != null;

  bool get isEmpty => !hasPlace && languages.isEmpty && minWords == null && maxWords == null && contains.isEmpty;

  bool matches(SourceApp? source, TextSignals text) {
    final placed =
        !hasPlace ||
        (source != null &&
            (apps.contains(source.id) ||
                (title?.hasMatch(source.windowTitle ?? "") ?? false) ||
                (url?.hasMatch(source.url?.toString() ?? "") ?? false)));
    return placed &&
        (languages.isEmpty || languages.contains(text.language)) &&
        (minWords == null || text.words >= minWords!) &&
        (maxWords == null || text.words <= maxWords!) &&
        text.contains.containsAll(contains);
  }
}

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String name,
    required When when,
    @Default(<InstructionId>[]) List<InstructionId> use,

    /// Model for matching text. The last matching profile with one wins.
    ModelRef? model,
    @Default(ModelOptions()) ModelOptions options,

    /// Added to the library's keep words while this profile applies.
    @Default(<String>[]) List<String> keepWords,

    /// Paste, rich paste or copy. Default paste.
    DeliveryMode? deliver,
  }) = _Profile;
}

/// Everything in library.yaml: the user's whole setup. Only validateLibrary
/// creates one, so ids are unique, references exist and pins are free.
@freezed
abstract class Library with _$Library {
  const Library._();

  const factory Library({
    required List<Group> groups,
    required List<Instruction> instructions,

    /// Every matching profile applies, in this order.
    required List<Profile> profiles,

    /// Active in every run, before profiles.
    required List<InstructionId> defaults,

    /// Names and terms the model must leave exactly as written.
    required List<String> keepWords,

    /// The "always" model.
    ModelRef? defaultModel,

    /// Runs the assistant. Needs tool calls.
    ModelRef? assistantModel,
  }) = _Library;

  Instruction? operator [](InstructionId id) => instructions.firstWhereOrNull((i) => i.id == id);

  Group? group(GroupId id) => groups.firstWhereOrNull((g) => g.id == id);

  /// Members of [id] in file order: the order [ and ] step through.
  List<Instruction> members(GroupId id) => [
    for (final i in instructions)
      if (i.group == id) i,
  ];

  List<Profile> profilesFor(SourceApp? source, TextSignals text) => [
    for (final p in profiles)
      if (p.when.matches(source, text)) p,
  ];

  /// The profile that belongs to one app, for "save for this app".
  Profile? appProfile(String appId) => profiles.firstWhereOrNull((p) => p.when.apps.contains(appId));

  Instruction? pinned(int pin) => instructions.firstWhereOrNull((i) => i.pin == pin);
}

/// What the user changed in the window for this one run.
@freezed
abstract class RunChoices with _$RunChoices {
  const RunChoices._();

  const factory RunChoices({
    /// In pick order, so a later pick wins a group or excludes conflict.
    @Default(<InstructionId>[]) List<InstructionId> added,

    /// Default or profile instructions the user switched off.
    @Default(<InstructionId>{}) Set<InstructionId> removed,

    /// Free text from the bar.
    @Default("") String words,

    /// Model picked for now.
    ModelRef? model,

    /// Profile picked for now from the bar, instead of the matching ones.
    String? profile,
  }) = _RunChoices;

  RunChoices turnOn(InstructionId id) =>
      copyWith(added: [...added.where((a) => a != id), id], removed: removed.difference({id}));

  RunChoices turnOff(InstructionId id) =>
      copyWith(added: added.where((a) => a != id).toList(), removed: {...removed, id});
}

/// Why an instruction or model is on: the defaults, a profile, or a pick
/// for now. The bar shows it beside each row that is on.
@freezed
sealed class Origin with _$Origin {
  const factory Origin.defaults() = FromDefaults;
  const factory Origin.profile(String name) = FromProfile;
  const factory Origin.you() = FromYou;
}

@freezed
abstract class ActiveInstruction with _$ActiveInstruction {
  const factory ActiveInstruction(Instruction instruction, Origin origin) = _ActiveInstruction;
}

@freezed
abstract class ActiveModel with _$ActiveModel {
  const factory ActiveModel(ModelRef ref, Origin origin) = _ActiveModel;
}

/// The settings for one run, after every layer is applied.
@freezed
abstract class Resolved with _$Resolved {
  const factory Resolved({
    required TextSignals signals,

    /// Every matching profile, in file order.
    required List<Profile> profiles,

    /// In library file order: the same set always composes the same prompt.
    required List<ActiveInstruction> active,
    required String words,
    required List<String> keepWords,
    required ModelOptions options,
    required DeliveryMode deliver,
    SourceApp? source,

    /// Null means the first model in the catalog.
    ActiveModel? model,
  }) = _Resolved;
}
