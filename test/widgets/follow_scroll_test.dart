import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/hooks/follow_scroll.dart";

/// [lines] lines of 40 px in a 200 px tall scroll view.
class _Writing extends HookWidget {
  const _Writing({required this.scroll, required this.lines, required this.writing});

  final ScrollController scroll;
  final int lines;
  final bool writing;

  @override
  Widget build(BuildContext context) {
    useFollowWhileWriting(scroll, writing: writing, content: lines);
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        controller: scroll,
        child: Column(children: [for (var i = 0; i < lines; i++) const SizedBox(height: 40)]),
      ),
    );
  }
}

void main() {
  late ScrollController scroll;
  setUp(() => scroll = ScrollController());
  tearDown(() => scroll.dispose());

  Future<void> show(WidgetTester tester, {required int lines, bool writing = true}) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: _Writing(scroll: scroll, lines: lines, writing: writing),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets("keeps the newest words in view while writing", (tester) async {
    await show(tester, lines: 3);
    expect(scroll.offset, 0);
    await show(tester, lines: 10);
    expect(scroll.offset, scroll.position.maxScrollExtent);
    expect(scroll.offset, 200);
    await show(tester, lines: 12);
    expect(scroll.offset, 280);
  });

  testWidgets("stops following once the reader scrolls up, until back at the end", (tester) async {
    await show(tester, lines: 10);
    scroll.jumpTo(40);
    await show(tester, lines: 12);
    expect(scroll.offset, 40);
    scroll.jumpTo(scroll.position.maxScrollExtent);
    await show(tester, lines: 14);
    expect(scroll.offset, 360);
  });

  testWidgets("glides back to the top when writing ends", (tester) async {
    await show(tester, lines: 10);
    expect(scroll.offset, 200);
    await show(tester, lines: 10, writing: false);
    expect(scroll.offset, 0);
  });
}
