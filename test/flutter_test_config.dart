import "dart:async";

import "package:alchemist/alchemist.dart";

/// CI goldens use a block font, so they match on every OS and are the ones
/// committed. Platform goldens use the real fonts and are for looking at the
/// design locally (`just goldens`); they are git ignored.
///
/// Renderers antialias a few edge pixels differently per OS and Flutter
/// version (1 to 24 of 600,000 between macOS and CI's Linux), so CI goldens
/// allow 0.1% of pixels to differ. Any visible change is far above that.
Future<void> testExecutable(FutureOr<void> Function() testMain) => AlchemistConfig.runWithConfig(
  config: AlchemistConfig(
    ciGoldensConfig: const CiGoldensConfig(diffThreshold: 0.001),
    platformGoldensConfig: PlatformGoldensConfig(platforms: {HostPlatform.macOS}),
  ),
  run: () async => testMain(),
);
