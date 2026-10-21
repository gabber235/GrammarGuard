import "dart:ui";

import "package:flutter/widgets.dart";

/// A stand in for the desktop behind the popup: a colorful wallpaper with
/// the blur macOS puts under a HUD window. Goldens show the glass the way a
/// user sees it, instead of a tint over nothing.
class Desktop extends StatelessWidget {
  const Desktop({required this.child, this.light = false, super.key});

  final Widget child;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final blobs = light
        ? const [Color(0xFFB7CBE6), Color(0xFFE6D3C6), Color(0xFFC9DED6), Color(0xFFD6CFE4)]
        : const [Color(0xFF274B8F), Color(0xFF8A3B5C), Color(0xFF1F6E63), Color(0xFF5A3A8C)];
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: light ? const Color(0xFFDDE2EA) : const Color(0xFF101521)),
        for (final (i, color) in blobs.indexed)
          Positioned(
            left: [-80.0, 520.0, 180.0, 760.0][i],
            top: [-60.0, -120.0, 300.0, 260.0][i],
            child: Container(
              width: 520,
              height: 420,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
        // A bit of "window" structure, so the blur has edges to soften.
        Positioned(
          left: 60,
          top: 90,
          child: Container(width: 380, height: 260, color: light ? const Color(0xFFFFFFFF) : const Color(0xFF2B2F3A)),
        ),
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40), child: const SizedBox.expand()),
        child,
      ],
    );
  }
}
