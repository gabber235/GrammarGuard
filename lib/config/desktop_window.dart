import "package:flutter/foundation.dart";

/// macOS uses a shortcut-driven palette; other desktop systems keep a normal window.
bool get usesPaletteWindow => defaultTargetPlatform == TargetPlatform.macOS;
