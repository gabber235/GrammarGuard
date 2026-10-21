import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/ui/word_reveal.dart";

void main() {
  Duration ms(int n) => Duration(milliseconds: n);

  test("new words fade in one after another; shown words stay shown", () {
    final reveal = WordReveal()
      ..update("Hey team, ", Duration.zero, animate: false)
      ..update("Hey team, I think ", ms(100), animate: true);
    expect(reveal.alpha(0, ms(100)), 1, reason: "already shown");
    expect(reveal.alpha(10, ms(100)), 0, reason: "\"I\" just arrived");
    expect(reveal.alpha(10, ms(150)), greaterThan(reveal.alpha(12, ms(150))), reason: "\"I\" before \"think\"");
    expect(reveal.settled(ms(100) + WordReveal.fade * 2), isTrue);
  });

  test("text that does not continue the old one is shown at once", () {
    final reveal = WordReveal()
      ..update("Hey team, ", Duration.zero, animate: false)
      ..update("Something else ", ms(100), animate: true);
    expect(reveal.alpha(0, ms(100)), 1);
    expect(reveal.settled(ms(100)), isTrue);
  });

  test("settled text is one run, each fading word its own", () {
    final reveal = WordReveal()
      ..update("Hey team, ", Duration.zero, animate: false)
      ..update("Hey team, I think ", ms(100), animate: true);
    final runs = reveal.runs("Hey team, I think ", 0, ms(100));
    expect([for (final (text, _) in runs) text], ["Hey team, ", "I ", "think "]);
  });

  test("text past the revealed text is shown", () {
    final reveal = WordReveal()..update("Hey ", Duration.zero, animate: false);
    expect(reveal.runs("original words ", 40, Duration.zero), [("original words ", 1.0)]);
  });
}
