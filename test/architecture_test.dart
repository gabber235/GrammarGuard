// The folder rules, enforced.
import "dart:io";

import "package:flutter_test/flutter_test.dart";

/// Every folder except lib/platform and lib/app: free of OS plugins and
/// platform channels, so it runs in plain unit tests.
const _pure = [
  "lib/instructions",
  "lib/rewrite",
  "lib/review",
  "lib/llm",
  "lib/session",
  "lib/assistant",
  "lib/bar",
  "lib/settings",
  "lib/models",
  "lib/state",
  "lib/services",
];
const _plugins = [
  "package:window_manager",
  "package:hotkey_manager",
  "package:tray_manager",
  "package:flutter_acrylic",
];

/// Platform channels and bundled assets are reached only through lib/platform.
const _platformCalls = ["MethodChannel(", "EventChannel(", "rootBundle"];

void main() {
  test("only lib/platform and lib/app touch OS plugins", () {
    final offenders = <String>[];
    for (final folder in _pure) {
      for (final file in Directory(folder).listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith(".dart") || file.path.endsWith(".g.dart")) continue;
        final source = file.readAsStringSync();
        for (final use in [..._plugins, ..._platformCalls]) {
          if (source.contains(use)) offenders.add("${file.path}: $use");
        }
      }
    }
    // The Apple model is a ChatCapability built on its own channel; it lives
    // with the other model code on purpose.
    offenders
      ..removeWhere((o) => o.contains("llm/apple_model.dart"))
      // HotKey is hotkey_manager's plain data type, part of the GlobalHotkey
      // port's contract; the setting stores it, it never registers anything.
      ..remove("lib/settings/hotkey_setting.dart: package:hotkey_manager");
    expect(offenders, isEmpty);
  });

  test("no hard-coded white", () {
    final offenders = Directory("lib")
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith(".dart") && f.readAsStringSync().contains("Colors.white"));
    expect(offenders.map((f) => f.path), isEmpty);
  });
}
