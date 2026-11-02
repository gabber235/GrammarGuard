import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/session/commands.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "key_tips.freezed.dart";
part "key_tips.g.dart";

const _usedKey = "key_tips_used";
const _enabledKey = "key_tips_enabled";

/// Most useful first. The footer already shows the review's own keys.
const tipOrder = [
  AppCommand.changeModel,
  AppCommand.openBar,
  AppCommand.compare,
  AppCommand.why,
  AppCommand.undoDecision,
  AppCommand.less,
  AppCommand.more,
  AppCommand.saveForApp,
  AppCommand.editor,
  AppCommand.sideBySide,
  AppCommand.preview,
  AppCommand.retry,
];

@freezed
abstract class KeyTipState with _$KeyTipState {
  const KeyTipState._();

  const factory KeyTipState({
    /// Commands this computer has run, so they need no tip.
    @Default(<AppCommand>{}) Set<AppCommand> used,

    /// This rewrite's tip. Changes only between rewrites, so nothing moves
    /// while reading; gone once its command runs.
    AppCommand? tip,
    @Default(true) bool enabled,
  }) = _KeyTipState;

  AppCommand? get shown => enabled ? tip : null;
}

/// One quiet tip per rewrite, for a key not used yet. Tips take turns, so a
/// key someone ignores does not stay in the footer forever.
@Riverpod(keepAlive: true)
class KeyTips extends _$KeyTips {
  var _turn = 0;

  @override
  Future<KeyTipState> build() async {
    final prefs = await ref.watch(preferencesProvider.future);
    final names = prefs.getStringList(_usedKey) ?? const <String>[];
    return KeyTipState(
      used: {for (final name in names) ?AppCommand.values.asNameMap()[name]},
      enabled: prefs.getBool(_enabledKey) ?? true,
    );
  }

  /// A new text came in: on to the next tip.
  Future<void> nextRewrite() async {
    final current = await future;
    final open = [
      for (final command in tipOrder)
        if (!current.used.contains(command)) command,
    ];
    state = AsyncData(current.copyWith(tip: open.isEmpty ? null : open[_turn++ % open.length]));
  }

  Future<void> markUsed(AppCommand command) async {
    final current = await future;
    if (current.used.contains(command)) return;
    final used = {...current.used, command};
    state = AsyncData(current.copyWith(used: used, tip: current.tip == command ? null : current.tip));
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.setStringList(_usedKey, [for (final c in used) c.name]);
  }

  Future<void> setEnabled({required bool enabled}) async {
    state = AsyncData((await future).copyWith(enabled: enabled));
    await (await ref.read(preferencesProvider.future)).setBool(_enabledKey, enabled);
  }
}
