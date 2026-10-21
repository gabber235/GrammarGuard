import "dart:async";

import "package:alchemist/alchemist.dart";

/// CI goldens use a block font, so they match on every OS and are the ones
/// committed. Platform goldens use the real fonts and are for looking at the
/// design locally (`just goldens`); they are git ignored.
Future<void> testExecutable(FutureOr<void> Function() testMain) => AlchemistConfig.runWithConfig(
  config: AlchemistConfig(platformGoldensConfig: PlatformGoldensConfig(platforms: {HostPlatform.macOS})),
  run: () async => testMain(),
);
