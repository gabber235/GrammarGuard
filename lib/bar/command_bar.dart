import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/app/library_writes.dart";
import "package:grammar_guard/app/navigation.dart";
import "package:grammar_guard/app/result_view.dart";
import "package:grammar_guard/app/settings/settings_page.dart";
import "package:grammar_guard/assistant/assistant.dart";
import "package:grammar_guard/bar/bar_items.dart";
import "package:grammar_guard/instructions/instruction.dart";
import "package:grammar_guard/instructions/library_change.dart";
import "package:grammar_guard/instructions/library_store.dart";
import "package:grammar_guard/instructions/scopes.dart";
import "package:grammar_guard/llm/catalog.dart";
import "package:grammar_guard/llm/llm.dart";
import "package:grammar_guard/rewrite/history.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Space: the one place to type, as a view of the window in place of the
/// result. Search, requests, models, actions and the assistant share it;
/// Enter, Shift Enter and Cmd Enter are the three scopes. Empty, it lists
/// what is on for this text first, so it is also where the setup is seen
/// and changed. The footer shows its keys.
class CommandBar extends HookConsumerWidget {
  const CommandBar({required this.request, super.key});

  final BarRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useTextEditingController(text: request.query);
    useListenable(query);
    // Not autofocus: the window already holds focus (AlwaysFocused), and
    // autofocus only fills an empty scope.
    final field = useFocusNode();
    useEffect(() {
      // The cursor goes after a prefix ("@"), not over it, so typing goes on
      // from there. Desktop fields select all as focus lands, so this
      // listens from after the first frame: behind the field's own listener.
      void placeCursor() {
        if (!field.hasFocus) return;
        query.selection = TextSelection.collapsed(offset: query.text.length);
        field.removeListener(placeCursor);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        field
          ..addListener(placeCursor)
          ..requestFocus();
      });
      return () => field.removeListener(placeCursor);
    }, const []);
    final highlighted = useState(0);
    final rowKeys = useMemoized(() => <BarItem, GlobalKey>{});
    final library = ref.watch(libraryStoreProvider).value?.library;
    final resolved = ref.watch(resolvedProvider);
    final session = ref.read(sessionActionsProvider);
    final model = ref.watch(runRequestProvider)?.model.ref;
    final comparing = request.mode == BarMode.compare;

    final all = library == null
        ? const <BarItem>[]
        : barItems(
            // Comparing lists models only, without the "@" in the field.
            query: comparing ? "@${query.text}" : query.text,
            library: library,
            active: {for (final a in resolved?.active ?? const []) a.instruction.id},
            words: resolved?.words ?? "",
            models: ref.watch(modelCatalogProvider).value ?? const [],
            history: ref.watch(historyProvider).value ?? const [],
            source: resolved?.source,
          );
    // Comparing a model with itself shows the same text twice.
    final items = [
      for (final item in all)
        if (!(comparing && item is ModelItem && item.model.ref == model)) item,
    ];
    // No rows for "@xyz": clamp would throw on an empty range.
    final index = items.isEmpty ? 0 : highlighted.value.clamp(0, items.length - 1);

    // Arrowing past the edge scrolls the current row into view.
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final row = items.isEmpty ? null : rowKeys[items[index]]?.currentContext;
        if (row != null && row.mounted) _reveal(row);
      });
      return null;
    }, [index, items.length]);

    Future<void> run(Scope scope) async {
      if (items.isEmpty) return;
      final messenger = ScaffoldMessenger.of(context);
      final item = items[index];
      session.closeBar();
      if (comparing && item is ModelItem) {
        session.compareWith(item.model.ref);
        return;
      }
      await writeLibrary(messenger, () => handleBarItem(ref, item, scope));
    }

    // Empty, the rows on for this text come first, under their own label.
    final on = query.text.trim().isEmpty ? items.takeWhile(_isOn).length : 0;
    final gg = context.gg;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => highlighted.value = index + 1,
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => highlighted.value = index - 1,
        const SingleActivator(LogicalKeyboardKey.enter): () => run(Scope.now),
        const SingleActivator(LogicalKeyboardKey.enter, shift: true): () => run(Scope.app),
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): () => run(Scope.always),
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () => run(Scope.always),
        // Bound here, not left to macOS: in a text field macOS turns Esc
        // into a dismiss only through its native text input.
        const SingleActivator(LogicalKeyboardKey.escape): session.closeBar,
        // Tab has one meaning here: hand the text to the assistant.
        const SingleActivator(LogicalKeyboardKey.tab): () async {
          session.closeBar();
          await handleBarItem(ref, BarItem.ask(query.text.trim()), Scope.now);
        },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Icon(Icons.search, size: 22, color: gg.muted),
              ),
              Expanded(
                child: TextField(
                  controller: query,
                  focusNode: field,
                  onChanged: (_) => highlighted.value = 0,
                  style: TextStyle(fontSize: 20, color: gg.ink),
                  decoration: InputDecoration(
                    hintText: comparing ? "Compare with which model?" : "Search, type a request, or Tab to ask",
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(color: gg.hairline, height: 1),
          Expanded(
            child: items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                    child: Text("Nothing matches.", style: TextStyle(color: gg.muted)),
                  )
                // The last rows fade out, so a cut off row reads as "more below".
                : ShaderMask(
                    blendMode: BlendMode.dstIn,
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [Colors.black, Colors.black, Colors.transparent],
                      stops: [0, 1 - _fade / rect.height, 1],
                    ).createShader(rect),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, _fade),
                      children: [
                        for (final (i, item) in items.indexed) ...[
                          if (on > 0 && i == 0)
                            _Label(switch (resolved?.source) {
                              final source? => "On for this text from ${source.name}",
                              null => "On for this text",
                            }),
                          if (on > 0 && i == on) const _Label("More", top: 14),
                          PillRow(
                            key: rowKeys.putIfAbsent(item, GlobalKey.new),
                            current: i == index,
                            onTap: () {
                              highlighted.value = i;
                              run(Scope.now);
                            },
                            child: _Row(
                              item: item,
                              origin: i < on ? _origin(resolved, item) : null,
                              inUse: switch (item) {
                                InstructionItem(:final active) => active,
                                ModelItem(model: ModelInfo(:final ref)) => ref == model,
                                _ => false,
                              },
                            ),
                          ).stagger(context, i),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// How far the bottom of the list fades out.
const _fade = 32.0;

/// Scrolls just enough to show [row] whole, clear of the bottom fade.
void _reveal(BuildContext row) {
  final box = row.findRenderObject();
  if (box == null) return;
  final viewport = RenderAbstractViewport.of(box);
  final position = Scrollable.of(row).position;
  // The scroll offsets that put the row at the top edge, and just above the fade.
  final atTop = viewport.getOffsetToReveal(box, 0).offset;
  final atBottom = viewport.getOffsetToReveal(box, 1).offset + _fade;
  final target = position.pixels.clamp(atBottom, atTop).clamp(position.minScrollExtent, position.maxScrollExtent);
  if (target != position.pixels) position.jumpTo(target);
}

bool _isOn(BarItem item) => item is InstructionItem && item.active || item is WordsItem && item.active;

/// Why an "on" row is on: the defaults, a profile, or a pick for now.
Origin? _origin(Resolved? resolved, BarItem item) => switch (item) {
  InstructionItem(:final instruction) =>
    resolved?.active.firstWhereOrNull((a) => a.instruction.id == instruction.id)?.origin,
  _ => const Origin.you(),
};

/// A group label in the bar, lined up with the row text.
class _Label extends StatelessWidget {
  const _Label(this.text, {this.top = 0});

  final String text;
  final double top;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: EdgeInsets.fromLTRB(16, top, 16, 0), child: SectionLabel(text));
}

/// One bar row: what kind of thing it is, its name, and either where an
/// "on" row comes from or "on" for a search result already in use.
class _Row extends StatelessWidget {
  const _Row({required this.item, required this.inUse, this.origin});

  final BarItem item;

  /// Already part of this rewrite: an instruction that is on, the model.
  final bool inUse;
  final Origin? origin;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final trailing = switch (origin) {
      FromDefaults() => ("Default", gg.muted),
      FromProfile(:final name) => ("$name profile", gg.profile),
      FromYou() => ("For now", gg.you),
      null when inUse => ("on", gg.added),
      null => null,
    };
    return Row(
      children: [
        SizedBox(
          width: 92,
          child: Text(switch (item) {
            InstructionItem() => "Instruction",
            ProfileItem() => "Profile",
            ModelItem() => "Model",
            ActionItem() => "Action",
            SuggestionItem() => "Suggested",
            WordsItem() => "Request",
            AskItem() => "Assistant",
          }, style: TextStyle(fontSize: 12, color: gg.muted)),
        ),
        Expanded(
          child: Text(
            item.label,
            style: TextStyle(fontSize: 15, color: gg.ink),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing case (final text, final color))
          Text(
            text,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

/// One place that turns a row and a scope into an effect.
Future<void> handleBarItem(WidgetRef ref, BarItem item, Scope scope) async {
  // Every read happens before the first await: the bar has closed, and
  // its ref goes with it.
  final session = ref.read(sessionActionsProvider);
  final store = ref.read(libraryStoreProvider.notifier);
  final library = ref.read(libraryStoreProvider).value?.library;
  final resolved = ref.read(resolvedProvider);
  final assistant = ref.read(assistantProvider.notifier);
  final preview = ref.read(previewProvider.notifier);
  if (library == null) return; // the bar lists nothing before the library loads

  Future<void> save(List<LibraryChange> changes) =>
      changes.isEmpty ? Future.value() : store.apply(changes, author: ChangeAuthor.you);

  switch ((item, scope)) {
    case (InstructionItem(:final instruction), Scope.now):
      session.toggle(instruction);
    case (InstructionItem(:final instruction), _) when resolved != null:
      await save(keepOne(library, resolved, scope, instruction: instruction));
    case (WordsItem(active: true), Scope.now):
      session.setWords(""); // Enter on the request that is on drops it
    case (WordsItem(:final words), Scope.now):
      session.setWords(words);
    case (WordsItem(:final words), _) when resolved != null:
      await save(keepOne(library, resolved, scope, instruction: wordsInstruction(library, words)));
    case (ModelItem(:final model), Scope.now):
      session.useModel(model.ref);
    case (ModelItem(:final model), _) when resolved != null:
      await save(keepOne(library, resolved, scope, model: model.ref));
    case (SuggestionItem(:final change), _):
      await save([change]);
    case (ProfileItem(:final profile), _):
      session.useProfile(profile.name);
    case (AskItem(:final words), _):
      await assistant.open(words);
    case (ActionItem(:final action), _):
      switch (action) {
        case BarAction.settings:
          await openSettings();
        case BarAction.history:
          await openSettings(SettingsSection.history);
        case BarAction.undoSetupChange:
          await store.undo();
        case BarAction.compare:
          session.openBar(const BarRequest(mode: BarMode.compare));
        case BarAction.retry:
          session.retry();
        case BarAction.preview:
          preview.toggle();
      }
    case (_, _):
      break; // saving needs captured text; nothing to save against
  }
}
