// The few shapes every screen is built from, so they all read alike.
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/theme.dart";

/// A raised group on the window: settings blocks, compare columns, the
/// proposal. A faint fill and a hairline, never a shadow.
class Panel extends StatelessWidget {
  const Panel({required this.child, this.padding = const EdgeInsets.all(16), super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    // A Material, so list rows inside can paint their hover and selection.
    return Material(
      color: gg.raised,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GgTheme.radius),
        side: BorderSide(color: gg.hairline),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// One key, drawn like a key. The only way keys appear on screen.
class KeyCap extends StatelessWidget {
  const KeyCap(this.label, {this.size = 12, super.key});

  final String label;

  /// Font size; the empty window draws its keys large.
  final double size;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return Container(
      constraints: BoxConstraints(minWidth: size * 1.7),
      padding: EdgeInsets.symmetric(horizontal: size / 2, vertical: size / 12),
      decoration: BoxDecoration(
        color: gg.raised,
        borderRadius: BorderRadius.circular(size / 2.4),
        border: Border(
          top: BorderSide(color: gg.hairline),
          left: BorderSide(color: gg.hairline),
          right: BorderSide(color: gg.hairline),
          bottom: BorderSide(color: gg.hairline, width: 2),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Atkinson Hyperlegible Mono", fontSize: size, color: gg.ink, height: 1.4),
      ),
    );
  }
}

/// The modifier shortcuts are drawn with: Cmd on macOS, Ctrl elsewhere.
/// Both work everywhere; this is only the label.
String get primaryKey => defaultTargetPlatform == TargetPlatform.macOS ? "Cmd" : "Ctrl";

/// Keys and what they do, optionally clickable: `KeyHint(["n", "p"], "next")`.
class KeyHint {
  const KeyHint(this.keys, this.what, {this.onTap});

  final List<String> keys;
  final String what;

  /// The same action for the mouse.
  final VoidCallback? onTap;
}

/// A row of "keys then what they do" hints, for footers and panels.
class KeyHints extends StatelessWidget {
  const KeyHints(this.hints, {super.key});

  final List<KeyHint> hints;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final hint in hints)
          InkWell(
            onTap: hint.onTap,
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final key in hint.keys) Padding(padding: const EdgeInsets.only(right: 3), child: KeyCap(key)),
                const SizedBox(width: 3),
                Text(hint.what, style: TextStyle(fontSize: 13, color: gg.muted)),
              ],
            ),
          ),
      ],
    );
  }
}

/// A list row that can be the current one. The current row gets the same
/// yellow pill as the change under review, so "where am I" always looks
/// the same: in the review, the bar, the proposal and Settings.
class PillRow extends StatelessWidget {
  const PillRow({
    required this.child,
    required this.current,
    this.onTap,
    this.padding = const EdgeInsets.fromLTRB(16, 9, 14, 9),
    super.key,
  });

  final Widget child;
  final bool current;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final gg = context.gg;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GgTheme.smallRadius),
      child: AnimatedContainer(
        duration: context.motion(Motion.fast),
        curve: Motion.out,
        decoration: BoxDecoration(
          color: current ? gg.current : Colors.transparent,
          borderRadius: BorderRadius.circular(GgTheme.smallRadius),
        ),
        child: Stack(
          children: [
            Padding(padding: padding, child: child),
            Positioned(
              left: 4,
              top: 8,
              bottom: 8,
              child: AnimatedOpacity(
                opacity: current ? 1 : 0,
                duration: context.motion(Motion.fast),
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(color: gg.highlighter, borderRadius: BorderRadius.circular(2)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small muted label over a group: "Models", "Original". Sentence case.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.labelMedium),
  );
}
