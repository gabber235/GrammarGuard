import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/pending_change.dart";
import "package:grammar_guard/review/editor_page.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/services/vim/vim_state.dart";
import "package:grammar_guard/session/session.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// Counts deliveries instead of pasting into another app.
class FakeSessionActions extends SessionActions {
  FakeSessionActions(super.ref);

  int deliveries = 0;

  @override
  Future<void> deliver() async => deliveries++;
}

class EditorHarness {
  EditorHarness(this.tester, this.container);

  final WidgetTester tester;
  final ProviderContainer container;

  FakeSessionActions get actions => container.read(sessionActionsProvider) as FakeSessionActions;
  ReviewView get review => ReviewView(container);
  bool get editorOpen => find.byType(EditorPage).evaluate().isNotEmpty;

  Future<void> open() async {
    await tester.tap(find.text("Open Editor"));
    await tester.pumpAndSettle();
  }

  Future<void> press(LogicalKeyboardKey key) async {
    await tester.sendKeyEvent(key);
    await tester.pumpAndSettle();
  }
}

/// Short reads of the shared review state.
class ReviewView {
  ReviewView(this.container);

  final ProviderContainer container;

  int get pending => container.read(reviewProvider)!.getPendingChangeCount();
  VimMode get mode => container.read(reviewProvider)!.vimState.mode;
  String get text => container.read(reviewProvider)!.document.getText();
  List<ChangeStatus> get statuses => [
    for (final c in container.read(reviewProvider)!.document.pendingChanges) c.status,
  ];
}

/// A home screen with an "Open Editor" button over a review of [diffs].
Future<EditorHarness> pumpHome(WidgetTester tester, List<Diff>? diffs) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      reviewDiffProvider.overrideWithValue(diffs),
      sessionActionsProvider.overrideWith(FakeSessionActions.new),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: GgTheme.dark.toThemeData(Brightness.dark),
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(onPressed: () => EditorPage.show(context), child: const Text("Open Editor")),
          ),
        ),
      ),
    ),
  );
  return EditorHarness(tester, container);
}

void main() {
  final replacement = [Diff(DIFF_EQUAL, "Hello "), Diff(DIFF_DELETE, "world"), Diff(DIFF_INSERT, "there")];

  group("EditorPage", () {
    testWidgets("opens over the review", (tester) async {
      final app = await pumpHome(tester, replacement);

      await app.open();

      expect(app.editorOpen, isTrue);
      expect(find.text("No document loaded"), findsNothing);
      expect(find.textContaining("Hello"), findsWidgets);
    });

    testWidgets("does not open while there is no result", (tester) async {
      final app = await pumpHome(tester, null);

      await app.open();

      expect(app.editorOpen, isFalse);
    });

    testWidgets("Enter in normal mode delivers and exits", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await app.press(LogicalKeyboardKey.enter);

      expect(app.editorOpen, isFalse);
      expect(app.actions.deliveries, equals(1));
    });

    testWidgets("Paste back button delivers and exits", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await tester.tap(find.text("Paste back"));
      await tester.pumpAndSettle();

      expect(app.editorOpen, isFalse);
      expect(app.actions.deliveries, equals(1));
    });

    testWidgets("Escape in normal mode goes back and keeps the edits", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();
      await tester.tap(find.text("keep"));
      await tester.pumpAndSettle();

      await app.press(LogicalKeyboardKey.escape);

      expect(app.editorOpen, isFalse);
      expect(app.actions.deliveries, equals(0));
      expect(app.review.statuses, equals([ChangeStatus.accepted]));
    });

    testWidgets("back button goes back without delivering", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(app.editorOpen, isFalse);
      expect(app.actions.deliveries, equals(0));
    });

    testWidgets("Escape in insert mode returns to normal mode and stays", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await app.press(LogicalKeyboardKey.keyI);
      expect(app.review.mode, equals(VimMode.insert));
      await app.press(LogicalKeyboardKey.escape);

      expect(app.editorOpen, isTrue);
      expect(app.review.mode, equals(VimMode.normal));
    });

    testWidgets("Enter in insert mode types a newline instead of delivering", (tester) async {
      final app = await pumpHome(tester, [Diff(DIFF_EQUAL, "Hello")]);
      await app.open();

      await app.press(LogicalKeyboardKey.keyI);
      await app.press(LogicalKeyboardKey.enter);

      expect(app.editorOpen, isTrue);
      expect(app.actions.deliveries, equals(0));
      expect(app.review.text, equals("\nHello"));
    });

    testWidgets("footer keep keeps the current change", (tester) async {
      final app = await pumpHome(tester, [...replacement, Diff(DIFF_EQUAL, "!")]);
      await app.open();
      expect(app.review.pending, equals(1));

      await tester.tap(find.text("keep"));
      await tester.pumpAndSettle();

      expect(app.review.statuses, equals([ChangeStatus.accepted]));
      expect(find.text("All decided"), findsOneWidget);
    });

    testWidgets("footer undo undoes the current change", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await tester.tap(find.text("undo"));
      await tester.pumpAndSettle();

      expect(app.review.statuses, equals([ChangeStatus.rejected]));
      expect(app.review.text, equals("Hello world"));
    });

    testWidgets("footer back goes back without delivering", (tester) async {
      final app = await pumpHome(tester, replacement);
      await app.open();

      await tester.tap(find.text("back"));
      await tester.pumpAndSettle();

      expect(app.editorOpen, isFalse);
      expect(app.actions.deliveries, equals(0));
    });

    testWidgets("line numbers toggle", (tester) async {
      final app = await pumpHome(tester, [Diff(DIFF_EQUAL, "one\ntwo")]);
      await app.open();
      expect(find.text("2"), findsOneWidget);

      await tester.tap(find.byTooltip("Line numbers"));
      await tester.pumpAndSettle();

      expect(find.text("2"), findsNothing);
    });
  });
}
