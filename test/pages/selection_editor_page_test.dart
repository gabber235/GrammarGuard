import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/pages/selection_editor_page.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

void main() {
  group("SelectionEditorPage", () {
    Future<void> waitForEditorReady(WidgetTester tester) async {
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
    }

    testWidgets("pressing Enter in normal mode confirms and exits",
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      String? poppedResult;
      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_DELETE, "world"),
        Diff(DIFF_INSERT, "there"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      poppedResult = await SelectionEditorPage.show(
                        context,
                        diffs,
                      );
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      expect(find.byType(SelectionEditorPage), findsOneWidget);
      expect(find.text("No document loaded"), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SelectionEditorPage), findsNothing);
      expect(poppedResult, isNotNull);
    });

    testWidgets("pressing Escape in normal mode shows exit confirmation dialog",
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_DELETE, "world"),
        Diff(DIFF_INSERT, "there"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await SelectionEditorPage.show(context, diffs);
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      expect(find.byType(SelectionEditorPage), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text("Discard changes?"), findsOneWidget);
    });

    testWidgets(
        "pressing Escape with no pending changes exits without confirmation",
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final diffs = [
        Diff(DIFF_EQUAL, "Hello world"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await SelectionEditorPage.show(context, diffs);
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      expect(find.byType(SelectionEditorPage), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(SelectionEditorPage), findsNothing);
    });

    testWidgets("back button triggers cancel flow", (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_INSERT, "new "),
        Diff(DIFF_EQUAL, "world"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await SelectionEditorPage.show(context, diffs);
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.text("Discard changes?"), findsOneWidget);
    });

    testWidgets("confirm button confirms and exits", (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      String? poppedResult;
      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_INSERT, "beautiful "),
        Diff(DIFF_EQUAL, "world"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      poppedResult = await SelectionEditorPage.show(
                        context,
                        diffs,
                      );
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      final confirmButton = find.text("Confirm");
      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SelectionEditorPage), findsNothing);
      expect(poppedResult, isNotNull);
      expect(poppedResult, contains("Hello"));
    });

    testWidgets("discard button in dialog exits without saving",
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      String? poppedResult;
      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_DELETE, "old"),
        Diff(DIFF_INSERT, "new"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      poppedResult = await SelectionEditorPage.show(
                        context,
                        diffs,
                      );
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text("Discard changes?"), findsOneWidget);

      await tester.tap(find.text("Discard"));
      await tester.pumpAndSettle();

      expect(find.byType(SelectionEditorPage), findsNothing);
      expect(poppedResult, isNull);
    });

    testWidgets("cancel button in dialog keeps editor open", (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_INSERT, "world"),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await SelectionEditorPage.show(context, diffs);
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text("Discard changes?"), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cancel"));
      await tester.pumpAndSettle();

      expect(find.byType(SelectionEditorPage), findsOneWidget);
    });

    testWidgets("footer accept button triggers accept action", (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_DELETE, "old"),
        Diff(DIFF_INSERT, "new"),
        Diff(DIFF_EQUAL, " world"),
      ];

      late WidgetRef capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                capturedRef = ref;
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () async {
                      await SelectionEditorPage.show(context, diffs);
                    },
                    child: const Text("Open Editor"),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Editor"));
      await waitForEditorReady(tester);

      final initialPendingCount =
          capturedRef.read(selectionEditorProvider)?.getPendingChangeCount();

      await tester.tap(find.text("Accept"));
      await tester.pumpAndSettle();

      final newPendingCount =
          capturedRef.read(selectionEditorProvider)?.getPendingChangeCount();

      expect(newPendingCount, lessThan(initialPendingCount ?? 0));
    });
  });
}
