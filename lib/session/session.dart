import "dart:async";

import "package:clock/clock.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/instructions/prompt.dart";
import "package:grammar_guard/instructions/resolve.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/platform/platform_providers.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/rewrite/run.dart";
import "package:grammar_guard/session/hotkey_binding.dart";
import "package:grammar_guard/session/key_tips.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:markdown/markdown.dart" show markdownToHtml;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "session.freezed.dart";
part "session.g.dart";

/// What the window is doing. The one owner of the hotkey to paste flow.
@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    /// Null until text is captured. No text means no model call.
    Captured? input,
    @Default(RunChoices()) RunChoices choices,

    /// Second model while comparing (C). Both results run side by side.
    ModelRef? compare,

    /// The bar, shown in place of the result while set (Space, M, C).
    BarRequest? bar,

    /// Why no model runs although there is text.
    @Default(RunHold.none) RunHold hold,

    /// ?: the list of keys, shown in place of the result. A run keeps going.
    @Default(false) bool showKeys,

    /// One line toast: "Copied", "Select some text first", a paste problem.
    String? notice,
  }) = _SessionState;
}

/// What keeps captured text from going to a model.
enum RunHold {
  none,

  /// Esc during a run. Stops watching the run, which cancels it.
  cancelled,

  /// The choose first hotkey: nothing is sent until a model is picked, or
  /// someone presses R for the usual one.
  choosing,
}

/// What Enter on a model row in the bar does.
enum BarMode {
  /// Use or save the row, at the scope of the Enter pressed.
  act,

  /// C: a model row starts a comparison instead of switching to it.
  compare,
}

/// How the bar opens: the text already typed ("@" lists models) and what
/// Enter on a model does. Comparing lists only models.
@freezed
abstract class BarRequest with _$BarRequest {
  const factory BarRequest({@Default("") String query, @Default(BarMode.act) BarMode mode}) = _BarRequest;
}

/// Popup when a global hotkey works, a normal window otherwise.
@Riverpod(keepAlive: true)
bool isPopup(Ref ref) => ref.watch(hotkeyBindingProvider).value?[HotkeyPurpose.rewrite] is HotkeyActive;

@Riverpod(keepAlive: true)
Resolved? resolved(Ref ref) {
  final session = ref.watch(sessionProvider);
  final library = ref.watch(libraryStoreProvider).value?.library;
  final input = session.input;
  if (input == null || library == null) return null;
  return resolve(library, input.source, input.text, session.choices);
}

RunRequest? _request(Ref ref, ModelRef? pick) {
  final session = ref.watch(sessionProvider);
  final resolved = ref.watch(resolvedProvider);
  final input = session.input;
  if (input == null || resolved == null || session.hold != RunHold.none) return null;

  // The model picked for now, by a profile or by default, else the first
  // model in the catalog. A pick naming a model that is gone falls back too.
  final models = ref.watch(modelCatalogProvider).value ?? const <ModelInfo>[];
  final wanted = pick ?? resolved.model?.ref;
  final model = models.where((m) => m.ref == wanted).firstOrNull ?? models.firstOrNull;
  if (model == null) return null;
  return RunRequest(model: model, prompt: compose(resolved, input.text), options: resolved.options, input: input.text);
}

/// The request for the visible result, or null when there is nothing to run.
@Riverpod(keepAlive: true)
RunRequest? runRequest(Ref ref) => _request(ref, null);

/// The second request while comparing two models.
@Riverpod(keepAlive: true)
RunRequest? compareRequest(Ref ref) {
  final compare = ref.watch(sessionProvider.select((s) => s.compare));
  return compare == null ? null : _request(ref, compare);
}

/// The run the window shows. Null before capture and after Esc.
@Riverpod(keepAlive: true)
AsyncValue<RunState>? currentRun(Ref ref) {
  final request = ref.watch(runRequestProvider);
  // Watching keeps the current run alive; older runs dispose (and cancel)
  // unless they finished and keep themselves alive as the cache.
  // ignore: riverpod_lint/only_use_keep_alive_inside_keep_alive
  return request == null ? null : ref.watch(runProvider(request));
}

/// Holds the session state. Riverpod 3 forbids a provider from reading
/// providers that depend on it, and most of the flow needs exactly those
/// (the run, the review, the resolved settings), so the flow itself lives
/// in [SessionActions] and changes state only through [update].
@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  SessionState build() => const SessionState();

  void update(SessionState Function(SessionState current) change) => state = change(state);
}

@Riverpod(keepAlive: true)
SessionActions sessionActions(Ref ref) {
  final actions = SessionActions(ref);
  final events = ref.watch(desktopWindowProvider).events.listen(actions._onWindowEvent);
  ref.onDispose(events.cancel);
  return actions;
}

/// The hotkey to paste flow: capture, choices, cancel, retry, delivery.
class SessionActions {
  SessionActions(this.ref);

  final Ref ref;

  SessionState get state => ref.read(sessionProvider);
  set state(SessionState next) => ref.read(sessionProvider.notifier).update((_) => next);

  /// A global hotkey. Runs while the source app is still in front.
  Future<void> onHotkey([HotkeyPurpose purpose = HotkeyPurpose.rewrite]) async {
    final window = ref.read(desktopWindowProvider);
    if (await window.isVisible() && ref.read(isPopupProvider)) {
      await window.hide();
      return;
    }
    try {
      await _start(await ref.read(textBridgeProvider).capture(), purpose);
    } on Object catch (error) {
      // The hotkey callback has no caller to report to: say it here.
      state = SessionState(notice: "Could not read the selection. $error");
    }
    await window.show();
  }

  /// Ctrl or Cmd+V in the window: the explicit way in when there is no
  /// hotkey. Nothing is ever sent to a model without one of these two.
  Future<void> useClipboard() async {
    await _start(await ref.read(textBridgeProvider).captureClipboard());
  }

  Future<void> _start(Captured captured, [HotkeyPurpose purpose = HotkeyPurpose.rewrite]) async {
    if (captured.text.trim().isEmpty) {
      state = SessionState(notice: captured.fallbackReason ?? "Select some text first, or copy it.");
      return;
    }
    // Set together with the text: the run starts from the state, so a hold
    // set later would already have sent the text.
    final (hold, bar) = switch (purpose) {
      HotkeyPurpose.rewrite => (RunHold.none, null),
      HotkeyPurpose.chooseFirst => (RunHold.choosing, const BarRequest(query: "@")),
    };
    final same = state.input?.text == captured.text && state.input?.source?.id == captured.source?.id;
    if (same) {
      // Same text again: keep choices and cached results, refresh the
      // source so paste back targets the app that is in front now.
      state = SessionState(input: captured, choices: state.choices, hold: hold, bar: bar);
      return;
    }
    ref.invalidate(runProvider); // drop the cache of the previous text
    state = SessionState(input: captured, hold: hold, bar: bar);
    unawaited(ref.read(keyTipsProvider.notifier).nextRewrite());
  }

  void toggle(Instruction instruction) {
    final active = ref.read(resolvedProvider)?.active.any((a) => a.instruction.id == instruction.id) ?? false;
    _choose(active ? state.choices.turnOff(instruction.id) : state.choices.turnOn(instruction.id));
  }

  /// [ and ]: one level down or up in the stepped group (edit level).
  void step(int delta) {
    final library = ref.read(libraryStoreProvider).value?.library;
    final resolved = ref.read(resolvedProvider);
    if (library == null || resolved == null) return;
    final next = stepInGroup(library, resolved, delta);
    if (next != null) _choose(state.choices.turnOn(next.id));
  }

  /// Every for-now change reruns: clear Esc and any old toast. Choosing first
  /// goes on until a model is picked, whatever else changes meanwhile.
  void _choose(RunChoices choices) => state = state.copyWith(
    choices: choices,
    hold: state.hold == RunHold.choosing ? RunHold.choosing : RunHold.none,
    notice: null,
  );

  /// A model picked in the bar for now. ⇧Enter and ⌘Enter save it instead,
  /// then [releaseHold].
  void useModel(ModelRef? model) {
    _choose(state.choices.copyWith(model: model));
    releaseHold();
  }

  /// The wait for a model is over: the text may go to one.
  void releaseHold() => state = state.copyWith(hold: RunHold.none);

  /// A profile picked in the bar for now, instead of the matching ones.
  void useProfile(String name) => _choose(state.choices.copyWith(profile: name));

  /// Space, M or C: the bar in place of the result. A new capture closes it.
  void openBar([BarRequest request = const BarRequest()]) => state = state.copyWith(bar: request);

  void closeBar() => state = state.copyWith(bar: null);

  /// ?: the list of keys in place of the result, or back.
  void toggleKeys() => state = state.copyWith(showKeys: !state.showKeys);

  void closeKeys() {
    if (state.showKeys) state = state.copyWith(showKeys: false);
  }

  /// C: run a second model next to the current one.
  void compareWith(ModelRef model) => state = state.copyWith(compare: model, hold: RunHold.none);

  /// Left or right arrow while comparing: keep that result and review it.
  /// Both runs are cached, so nothing is generated again.
  void pickCompared({required bool second}) {
    final winner = second ? state.compare : ref.read(runRequestProvider)?.model.ref;
    state = state.copyWith(choices: state.choices.copyWith(model: winner), compare: null);
  }

  void setWords(String words) => _choose(state.choices.copyWith(words: words));

  /// Esc: closes the keys or the bar, else leaves compare, else cancels a
  /// running rewrite, else hides the popup.
  Future<void> escape() async {
    if (state.showKeys) {
      closeKeys();
      return;
    }
    if (state.bar != null) {
      closeBar();
      return;
    }
    if (state.compare != null) {
      state = state.copyWith(compare: null);
      return;
    }
    if (ref.read(currentRunProvider)?.value?.isActive ?? false) {
      state = state.copyWith(hold: RunHold.cancelled, notice: "Cancelled. Press r to try again.");
      return;
    }
    if (ref.read(isPopupProvider)) await ref.read(desktopWindowProvider).hide();
  }

  /// R: runs the same request again, also after an error or Esc.
  void retry() {
    final request = ref.read(runRequestProvider);
    if (request != null) ref.invalidate(runProvider(request));
    state = state.copyWith(hold: RunHold.none, notice: null);
  }

  /// Enter, or Confirm in the editor. Only a finished, reviewed result is
  /// delivered (fixes the half copied result).
  Future<void> deliver() async {
    final input = state.input;
    final run = ref.read(currentRunProvider)?.value;
    final output = ref.read(reviewProvider)?.finalText;
    if (input == null || run is! Done || output == null) {
      state = state.copyWith(
        notice: switch (state.hold) {
          RunHold.choosing => "Nothing sent yet. Press m to pick a model, or r for the usual one.",
          RunHold.cancelled => "Cancelled. Press r to try again.",
          RunHold.none => "Still writing. Enter works when it is done.",
        },
      );
      return;
    }

    final window = ref.read(desktopWindowProvider);
    final popup = ref.read(isPopupProvider);
    // Hide first, so the source app is in front when the text is pasted.
    if (popup && input.via == CaptureMethod.selection) await window.hide();
    final resolved = ref.read(resolvedProvider);
    final mode = resolved?.deliver ?? DeliveryMode.paste;
    final delivery = await ref
        .read(textBridgeProvider)
        .deliver(
          output,
          input,
          mode: mode,
          // Mail, Word and Docs read HTML, not Markdown.
          html: mode == DeliveryMode.pasteRich ? markdownToHtml(output) : null,
        );
    await ref
        .read(historyProvider.notifier)
        .add(
          HistoryEntry(
            at: clock.now(),
            input: input.text,
            output: output,
            appId: input.source?.id,
            app: input.source?.name,
            profiles: [for (final p in resolved?.profiles ?? const <Profile>[]) p.name],
            instructions: [for (final a in resolved?.active ?? const <ActiveInstruction>[]) a.instruction.id.value],
            picked: [
              for (final a in resolved?.active ?? const <ActiveInstruction>[])
                if (a.origin is FromYou) a.instruction.id.value,
            ],
            words: resolved?.words ?? "",
            decisions: ref.read(reviewProvider)?.decisions ?? const [],
            model: ref.read(runRequestProvider)?.model.label,
            cost: run.cost,
          ),
        );

    ref.invalidate(runProvider);
    state = SessionState(
      notice: switch (delivery) {
        Pasted() => null,
        Copied(reason: null) => "Copied",
        Copied(:final reason?) => "Copied. $reason",
      },
    );
    if (popup && delivery is Copied) {
      // Let the toast be seen before the popup goes away.
      await Future<void>.delayed(const Duration(milliseconds: 700));
      await window.hide();
    }
  }

  Future<void> _onWindowEvent(WindowEvent event) async {
    final window = ref.read(desktopWindowProvider);
    switch (event) {
      case WindowEvent.blurred:
        // The run keeps going while hidden; reopening shows its result.
        if (ref.read(isPopupProvider)) await window.hide();
      case WindowEvent.closeRequested:
        state = state.copyWith(hold: RunHold.cancelled);
        await window.close();
      case WindowEvent.reopened:
        // Opening the app is a way in that needs no hotkey, so a broken
        // shortcut never locks anyone out.
        await window.show();
    }
  }
}
