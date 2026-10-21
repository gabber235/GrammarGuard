import "package:alchemist/alchemist.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

import "../support/desktop.dart";
import "../support/screens.dart";
import "../support/test_flow.dart";

/// Every screen and the states inside it, in the 1000 by 600 popup over a
/// stand in desktop, dark unless named light. Animations are off (reduced
/// motion), so each image is the end state.
void main() {
  for (final Screen(:name, :drive, :brightness, :file) in screens) {
    late FlowApp app;
    goldenTest(
      name,
      fileName: file,
      constraints: BoxConstraints.tight(const Size(1000, 600)),
      builder: () {
        // The app ships on desktop: macOS key labels and text fields, no
        // touch selection handles.
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        mockStorage();
        app = FlowApp();
        return MediaQuery(
          data: MediaQueryData(platformBrightness: brightness, size: const Size(1000, 600)),
          child: Desktop(light: brightness == Brightness.light, child: app.widget),
        );
      },
      pumpBeforeTest: (tester) async {
        await app.start(tester, pump: false);
        await drive(app);
        await app.settle();
      },
    );
  }
}
