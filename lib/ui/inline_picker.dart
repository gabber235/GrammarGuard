// A choice made inside the window: the field opens into its list where it
// stands, never as a menu floating over the window.
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/bar/bar_items.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/surfaces.dart";
import "package:grammar_guard/ui/theme.dart";

/// One choice in an [InlinePicker].
class PickerOption<T> {
  const PickerOption(this.value, this.label, {this.detail});

  final T value;
  final String label;

  /// A muted note at the end of the row, searched too: "Ollama".
  final String? detail;
}

/// A field showing the current choice. Clicked, or Enter or Space while
/// focused, it opens in place into [PillRow]s and the group around it grows
/// to fit: arrows move the pill, Enter or a click picks, Esc closes. Long
/// lists get a search field on top that filters like the bar.
class InlinePicker<T> extends HookWidget {
  const InlinePicker({
    required this.options,
    required this.value,
    required this.onPicked,
    this.label,
    this.hint = "Choose",
    super.key,
  });

  final List<PickerOption<T>> options;

  /// The current choice; [hint] shows while it is none of [options].
  final T? value;
  final ValueChanged<T> onPicked;

  /// What is chosen, on the field's border like a text field's label.
  final String? label;
  final String hint;

  /// More options than this get a search field.
  static const searchAbove = 8;

  /// The open list scrolls past this height, about six rows.
  static const listHeight = 260.0;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    final field = Theme.of(context).textTheme.bodyLarge;
    final open = useState(false);
    final highlighted = useState(0);
    // Rows hidden under the fade, so it shows only when there are some.
    final more = useState(false);
    final query = useTextEditingController();
    useListenable(query);
    // Holds focus for the whole picker, so keys reach it open or closed and
    // focus never drops out while the field turns into the list.
    final node = useFocusNode(debugLabel: "InlinePicker");
    useListenable(node);
    final search = useFocusNode(debugLabel: "InlinePicker search");
    final rowKeys = useMemoized(() => <T, GlobalKey>{});

    final searchable = options.length > searchAbove;
    final text = query.text.trim();
    final shown = text.isEmpty
        ? options
        : options
              .map((o) => (o, max(matchScore(o.label, text), matchScore(o.detail ?? "", text))))
              .where((e) => e.$2 > 0)
              .sortedBy<num>((e) => -e.$2)
              .map((e) => e.$1)
              .toList();
    final index = shown.isEmpty ? 0 : highlighted.value.clamp(0, shown.length - 1);
    final chosen = options.firstWhereOrNull((o) => o.value == value);

    void show() {
      query.clear();
      highlighted.value = chosen == null ? 0 : options.indexOf(chosen);
      open.value = true;
      node.requestFocus();
    }

    // Focus goes back to the picker before the search field it may be in
    // goes away, so it stays here for the next key.
    void close() {
      node.requestFocus();
      open.value = false;
    }

    void pick(PickerOption<T> option) {
      close();
      onPicked(option.value);
    }

    // The search field exists only from the next frame on.
    useEffect(() {
      if (open.value && searchable) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) search.requestFocus();
        });
      }
      return null;
    }, [open.value]);

    // Arrowing past the edge scrolls the current row into view.
    useEffect(() {
      if (!open.value || shown.isEmpty) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final row = rowKeys[shown[index].value]?.currentContext;
        if (row != null && row.mounted) revealRow(row);
      });
      return null;
    }, [open.value, index, shown.length]);

    bool track(ScrollMetrics metrics) {
      more.value = metrics.extentAfter > 0;
      return false;
    }

    final Widget body;
    if (!open.value) {
      body = InkWell(
        canRequestFocus: false,
        onTap: show,
        borderRadius: BorderRadius.circular(GgTheme.smallRadius),
        child: InputDecorator(
          isFocused: node.hasPrimaryFocus,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: Icon(Icons.unfold_more, size: 18, color: gg.muted),
          ),
          // A text field's own text style, so it reads like the fields around it.
          child: Text(
            chosen?.label ?? hint,
            style: field?.copyWith(color: chosen == null ? gg.muted : gg.ink),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      body = InputDecorator(
        isFocused: true,
        decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.all(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (searchable) ...[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.search, size: 18, color: gg.muted),
                  ),
                  Expanded(
                    child: TextField(
                      controller: query,
                      focusNode: search,
                      onChanged: (_) => highlighted.value = 0,
                      style: field?.copyWith(color: gg.ink),
                      decoration: const InputDecoration(
                        hintText: "Search",
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: gg.hairline, height: 1),
            ],
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Text("Nothing matches.", style: TextStyle(color: gg.muted)),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: listHeight),
                child: NotificationListener<ScrollMetricsNotification>(
                  onNotification: (n) => track(n.metrics),
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (n) => track(n.metrics),
                    child: BottomFade(
                      on: more.value,
                      // Not a shrink wrapped ListView: dialogs measure their
                      // content's intrinsic size, which a lazy list cannot give.
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: searchable ? 4 : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final (i, option) in shown.indexed)
                              PillRow(
                                key: rowKeys.putIfAbsent(option.value, GlobalKey.new),
                                current: i == index,
                                onTap: () => pick(option),
                                child: _Row(option: option, chosen: option == chosen),
                              ).stagger(context, i),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return TapRegion(
      onTapOutside: open.value ? (_) => open.value = false : null,
      child: CallbackShortcuts(
        bindings: open.value
            ? {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () => highlighted.value = index + 1,
                const SingleActivator(LogicalKeyboardKey.arrowUp): () => highlighted.value = index - 1,
                const SingleActivator(LogicalKeyboardKey.enter): () {
                  if (shown.isNotEmpty) pick(shown[index]);
                },
                // Bound here, not left to macOS: in a text field macOS turns
                // Esc into a dismiss only through its native text input.
                const SingleActivator(LogicalKeyboardKey.escape): close,
              }
            : {
                const SingleActivator(LogicalKeyboardKey.enter): show,
                const SingleActivator(LogicalKeyboardKey.space): show,
              },
        child: Focus(
          focusNode: node,
          // Tabbing or clicking away closes it, like a click outside.
          onFocusChange: (focused) {
            if (!focused && context.mounted) open.value = false;
          },
          // Not a zero duration AnimatedSize under reduced motion: that one
          // relayouts itself during its own layout and asserts.
          child: context.reduceMotion
              ? body
              : AnimatedSize(duration: Motion.medium, curve: Motion.out, alignment: Alignment.topCenter, child: body),
        ),
      ),
    );
  }
}

/// One option: its label, a muted detail, and "on" for the current choice.
class _Row<T> extends StatelessWidget {
  const _Row({required this.option, required this.chosen});

  final PickerOption<T> option;
  final bool chosen;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return Row(
      children: [
        Expanded(
          child: Text(
            option.label,
            style: TextStyle(fontSize: 15, color: gg.ink),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (option.detail case final detail?)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(detail, style: TextStyle(fontSize: 12, color: gg.muted)),
          ),
        if (chosen)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "on",
              style: TextStyle(fontSize: 12, color: gg.added, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
