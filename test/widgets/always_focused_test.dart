import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/widgets/always_focused.dart";

void main() {
  testWidgets("bare key shortcuts work again after a text field lets go of focus", (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.keyA): () => presses++},
          child: const AlwaysFocused(child: Material(child: TextField())),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    expect(presses, 1);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    FocusManager.instance.primaryFocus!.unfocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    expect(presses, 2);
  });

  testWidgets("focus parked above it (the app came back to the front) comes back down", (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.keyA): () => presses++},
          child: const AlwaysFocused(child: SizedBox()),
        ),
      ),
    );

    // What FocusManager does when the app resumes and restores a node that
    // was focused before the screen's own node existed.
    tester.state<NavigatorState>(find.byType(Navigator)).focusNode.requestFocus();
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    expect(presses, 1);
  });
}
