import "dart:async";

import "package:alchemist/alchemist.dart";
import "package:flutter_test/flutter_test.dart";

import "support/tolerant_comparator.dart";

/// CI goldens use a block font, so they match on every OS and are the ones
/// committed. Platform goldens use the real fonts and are for looking at the
/// design locally (`goldens` in devenv); they are git ignored. Every golden is
/// compared with [TolerantComparator], since renderers round colors a little
/// differently per OS.
Future<void> testExecutable(FutureOr<void> Function() testMain) {
  if (goldenFileComparator case final LocalFileComparator local) {
    goldenFileComparator = TolerantComparator(local.basedir.resolve("flutter_test_config.dart"));
  }
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(platformGoldensConfig: PlatformGoldensConfig(platforms: {HostPlatform.macOS})),
    run: () async => testMain(),
  );
}
