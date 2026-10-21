import "package:flutter/material.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/motion.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// The window body. In popup mode the OS blurs the desktop behind the
/// window (flutter_acrylic) and this paints a tint plus a hairline edge on
/// top: Lens glass. Elsewhere it is the solid Rail surface.
class GlassSurface extends ConsumerWidget {
  const GlassSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gg = context.gg;
    final popup = ref.watch(isPopupProvider);
    // Each hotkey press shows the window; replay the entrance then.
    final shown = ref.watch(sessionProvider.select((s) => s.input));
    final radius = BorderRadius.circular(popup ? 14 : 0);
    // Clipped to the rounded edge, so scrims and pages never paint into
    // the see-through corners.
    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(
        decoration: BoxDecoration(color: popup ? gg.glass : gg.surface, borderRadius: radius),
        position: DecorationPosition.background,
        child: DecoratedBox(
          // The hairline edge sits on top of everything, scrims included.
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: popup ? Border.all(color: gg.hairline) : null,
          ),
          child: KeyedSubtree(key: ValueKey(shown), child: child.appear(context)),
        ),
      ),
    );
  }
}
