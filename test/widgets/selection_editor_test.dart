import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/review/review.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:grammar_guard/ui/theme.dart";
import "package:grammar_guard/widgets/editor/selection_editor.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

/// The editor over a review built from [diffs]; null means no finished run.
Future<ProviderContainer> pumpEditor(WidgetTester tester, List<Diff>? diffs) async {
  final container = ProviderContainer(overrides: [reviewDiffProvider.overrideWithValue(diffs)]);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: GgTheme.dark.toThemeData(Brightness.dark),
        home: const Scaffold(body: SelectionEditor(showLineNumbers: true)),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group("SelectionEditor", () {
    for (final (platform, modifier) in [
      (TargetPlatform.macOS, LogicalKeyboardKey.metaLeft),
      (TargetPlatform.linux, LogicalKeyboardKey.controlLeft),
      (TargetPlatform.windows, LogicalKeyboardKey.controlLeft),
    ]) {
      testWidgets("accepts all changes with the primary shortcut on $platform", (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final container = await pumpEditor(tester, [
          Diff(DIFF_EQUAL, "A "),
          Diff(DIFF_INSERT, "first "),
          Diff(DIFF_EQUAL, "B "),
          Diff(DIFF_INSERT, "second"),
        ]);

        await tester.sendKeyDownEvent(modifier);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyY);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(modifier);
        await tester.pump();

        expect(container.read(reviewProvider)!.getPendingChangeCount(), 0);
        debugDefaultTargetPlatformOverride = null;
      });
    }

    testWidgets("displays message when no document is loaded", (tester) async {
      await pumpEditor(tester, null);

      expect(find.text("No document loaded"), findsOneWidget);
    });

    testWidgets("displays text content from document", (tester) async {
      await pumpEditor(tester, [Diff(DIFF_EQUAL, "Hello world")]);

      expect(find.textContaining("Hello world"), findsOneWidget);
    });

    testWidgets("types the character the keyboard produced", (tester) async {
      final container = await pumpEditor(tester, [Diff(DIFF_EQUAL, "Hello")]);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyI);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyE, character: "é");
      await tester.sendKeyEvent(LogicalKeyboardKey.comma, character: ",");
      await tester.pump();

      expect(container.read(reviewProvider)!.document.getText(), equals("é,Hello"));
    });

    testWidgets("typing next to a suggestion keeps it pending (B3)", (tester) async {
      final container = await pumpEditor(tester, [
        Diff(DIFF_DELETE, "teh"),
        Diff(DIFF_INSERT, "the"),
        Diff(DIFF_EQUAL, " cat"),
      ]);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyI);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyB, character: "b");
      await tester.sendKeyEvent(LogicalKeyboardKey.keyI, character: "i");
      await tester.sendKeyEvent(LogicalKeyboardKey.keyG, character: "g");
      await tester.sendKeyEvent(LogicalKeyboardKey.space, character: " ");
      await tester.pump();

      final state = container.read(reviewProvider)!;
      expect(state.document.getText(), equals("tehthe big cat"));
      expect(state.getPendingChangeCount(), equals(1));
    });
  });

  group("SelectionEditorState integration", () {
    final twoInsertions = [
      Diff(DIFF_EQUAL, "A "),
      Diff(DIFF_INSERT, "first "),
      Diff(DIFF_EQUAL, "B "),
      Diff(DIFF_INSERT, "second "),
      Diff(DIFF_EQUAL, "C"),
    ];

    test("initializes with correct cursor position at first change", () {
      final document = EditorDocument.fromDiffs([
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_INSERT, "beautiful "),
        Diff(DIFF_EQUAL, "world"),
      ]);
      final state = SelectionEditorState.fromDocument(document);

      expect(state.vimState.cursorPosition, equals(6));
    });

    test("initializes with cursor at 0 when no changes", () {
      final document = EditorDocument.fromDiffs([Diff(DIFF_EQUAL, "Hello world")]);
      final state = SelectionEditorState.fromDocument(document);

      expect(state.vimState.cursorPosition, equals(0));
    });

    test("accept change moves cursor to next pending change", () {
      final state = SelectionEditorState.fromDocument(EditorDocument.fromDiffs(twoInsertions));

      final newState = state.acceptCurrentChange();

      expect(newState.vimState.cursorPosition, greaterThan(state.vimState.cursorPosition));
    });

    test("reject change moves cursor to next pending change", () {
      final state = SelectionEditorState.fromDocument(EditorDocument.fromDiffs(twoInsertions));

      final newState = state.rejectCurrentChange();

      expect(newState.vimState.cursorPosition, greaterThan(state.vimState.cursorPosition));
    });

    test("acceptAll accepts all changes", () {
      final state = SelectionEditorState.fromDocument(EditorDocument.fromDiffs(twoInsertions));

      final newState = state.acceptAll();

      expect(newState.getPendingChangeCount(), equals(0));
      expect(newState.document.getText(), equals("A first B second C"));
    });

    test("rejectAll rejects all changes", () {
      final state = SelectionEditorState.fromDocument(EditorDocument.fromDiffs(twoInsertions));

      final newState = state.rejectAll();

      expect(newState.getPendingChangeCount(), equals(0));
      expect(newState.document.getText(), equals("A B C"));
    });
  });
}
