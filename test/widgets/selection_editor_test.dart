import "package:diff_match_patch/diff_match_patch.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/models/editor_document.dart";
import "package:grammar_guard/state/selection_editor_notifier.dart";
import "package:grammar_guard/state/selection_editor_state.dart";
import "package:grammar_guard/widgets/editor/selection_editor.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

Widget createTestWidget(Widget child,
    {double width = 1200, double height = 800,}) {
  return ProviderScope(
    child: MaterialApp(
      home: SizedBox(
        width: width,
        height: height,
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  group("SelectionEditor", () {
    testWidgets("displays message when no document is loaded", (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const SelectionEditor(showLineNumbers: true),
        ),
      );

      expect(find.text("No document loaded"), findsOneWidget);
    });

    testWidgets("displays text content from document", (tester) async {
      final diffs = [Diff(DIFF_EQUAL, "Hello world")];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectionEditorProvider.overrideWith(() {
              final notifier = SelectionEditorNotifier();
              return notifier;
            }),
          ],
          child: MaterialApp(
            home: SizedBox(
              width: 1200,
              height: 800,
              child: Scaffold(
                body: Builder(
                  builder: (context) {
                    return Consumer(
                      builder: (context, ref, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref
                              .read(selectionEditorProvider.notifier)
                              .initialize(diffs);
                        });
                        return const SelectionEditor(showLineNumbers: true);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining("Hello world"), findsOneWidget);
    });
  });

  group("SelectionEditorState integration", () {
    test("initializes with correct cursor position at first change", () {
      final diffs = [
        Diff(DIFF_EQUAL, "Hello "),
        Diff(DIFF_INSERT, "beautiful "),
        Diff(DIFF_EQUAL, "world"),
      ];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      expect(state.vimState.cursorPosition, equals(6));
    });

    test("initializes with cursor at 0 when no changes", () {
      final diffs = [Diff(DIFF_EQUAL, "Hello world")];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      expect(state.vimState.cursorPosition, equals(0));
    });

    test("accept change moves cursor to next pending change", () {
      final diffs = [
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_INSERT, "first "),
        Diff(DIFF_EQUAL, "B "),
        Diff(DIFF_INSERT, "second "),
        Diff(DIFF_EQUAL, "C"),
      ];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      final newState = state.acceptCurrentChange();

      expect(newState.vimState.cursorPosition,
          greaterThan(state.vimState.cursorPosition),);
    });

    test("reject change moves cursor to next pending change", () {
      final diffs = [
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_INSERT, "first "),
        Diff(DIFF_EQUAL, "B "),
        Diff(DIFF_INSERT, "second "),
        Diff(DIFF_EQUAL, "C"),
      ];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      final newState = state.rejectCurrentChange();

      expect(newState.vimState.cursorPosition,
          greaterThan(state.vimState.cursorPosition),);
    });

    test("acceptAll accepts all changes", () {
      final diffs = [
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_INSERT, "first "),
        Diff(DIFF_EQUAL, "B "),
        Diff(DIFF_INSERT, "second "),
        Diff(DIFF_EQUAL, "C"),
      ];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      final newState = state.acceptAll();

      expect(newState.getPendingChangeCount(), equals(0));
      expect(newState.getResultText(), isNotNull);
    });

    test("rejectAll rejects all changes", () {
      final diffs = [
        Diff(DIFF_EQUAL, "A "),
        Diff(DIFF_INSERT, "first "),
        Diff(DIFF_EQUAL, "B "),
        Diff(DIFF_INSERT, "second "),
        Diff(DIFF_EQUAL, "C"),
      ];
      final document = EditorDocument.fromDiffs(diffs);
      final state = SelectionEditorState.fromDocument(document);

      final newState = state.rejectAll();

      expect(newState.getPendingChangeCount(), equals(0));
      expect(newState.getResultText(), equals("A B C"));
    });
  });
}
