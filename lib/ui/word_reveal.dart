import "package:flutter/animation.dart";
import "package:flutter_hooks/flutter_hooks.dart";

/// When each word of a growing text arrived, so every new word can fade in
/// on its own, a few milliseconds after the one before it. A chunk of words
/// reads left to right instead of flashing in at once, and text already
/// shown never animates again. Pure bookkeeping on a clock the caller owns.
/// A word with the space after it, or a run of space before the first word.
final _words = RegExp(r"\S+\s*|\s+");

class WordReveal {
  static const fade = Duration(milliseconds: 260);
  static const _stagger = Duration(milliseconds: 35);
  static const _spread = Duration(milliseconds: 150);

  String _text = "";

  /// Where each word starts in the text, and when it arrived.
  final _starts = <int>[];
  final _births = <Duration>[];

  String get text => _text;

  /// Takes the text as it is [now]. Words past the old text arrive, staggered
  /// when [animate]. Text that does not continue the old one (a new run) is
  /// shown at once.
  void update(String text, Duration now, {required bool animate}) {
    if (text == _text) return;
    if (text.startsWith(_text)) {
      _add(_text.length, text, now, animate: animate);
    } else {
      _starts.clear();
      _births.clear();
      _add(0, text, now, animate: false);
    }
    _text = text;
  }

  /// A word keeps its trailing space. A chunk spreads over at most [_spread]
  /// and never queues more than [_spread] behind, so a fast model is never
  /// trailed by its own reveal.
  void _add(int from, String text, Duration now, {required bool animate}) {
    if (from >= text.length) return;
    final words = _words.allMatches(text.substring(from)).toList();
    final perWord = _spread ~/ words.length;
    final step = !animate ? Duration.zero : (perWord < _stagger ? perWord : _stagger);
    final queued = _births.isEmpty ? now : _births.last + _stagger;
    var at = !animate
        ? now - fade
        : queued < now
        ? now
        : (queued > now + _spread ? now + _spread : queued);
    for (final match in words) {
      _starts.add(from + match.start);
      _births.add(at);
      at += step;
    }
  }

  /// True once the last word has fully faded in.
  bool settled(Duration now) => _births.isEmpty || now - _births.last >= fade;

  /// Offset of the first character still fading in, or the text length.
  int settledUntil(Duration now) {
    final first = _births.indexWhere((b) => now - b < fade);
    return first < 0 ? _text.length : _starts[first];
  }

  /// Opacity of the character at [offset]: its word's progress. Offsets past
  /// the text are shown.
  double alpha(int offset, Duration now) {
    if (offset >= _text.length || _starts.isEmpty) return 1;
    var low = 0;
    var high = _starts.length - 1;
    while (low < high) {
      final mid = (low + high + 1) ~/ 2;
      if (_starts[mid] <= offset) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    final progress = (now - _births[low]).inMicroseconds / fade.inMicroseconds;
    return Curves.easeOut.transform(progress.clamp(0, 1));
  }

  /// [text], which sits at [at] in the revealed text, in runs of equal
  /// opacity: one run for what has settled, one per word still fading in.
  /// Text that is not part of the revealed text (an undone change shows the
  /// original) sits past its end or among settled words, so it is shown.
  List<(String, double)> runs(String text, int at, Duration now) {
    final settled = at >= _text.length ? text.length : (settledUntil(now) - at).clamp(0, text.length);
    return [
      if (settled > 0) (text.substring(0, settled), 1.0),
      for (final match in _words.allMatches(text.substring(settled)))
        (match[0]!, alpha(at + settled + match.start, now)),
    ];
  }
}

/// A [WordReveal] that follows [text] and rebuilds the widget every frame
/// while words fade in. Returns it with the time to draw it at.
({WordReveal reveal, Duration now}) useWordReveal(String text, {required bool animate}) {
  final clock = useMemoized(() => Stopwatch()..start());
  final reveal = useMemoized(WordReveal.new);
  final frame = useState(Duration.zero);
  final vsync = useSingleTickerProvider();
  final ticker = useMemoized(
    () => vsync.createTicker((_) {
      frame.value = clock.elapsed;
    }),
  );
  useEffect(() => ticker.dispose, const []);
  final built = useRef(false);

  // The first text is shown as it is; only what arrives later fades in.
  reveal.update(text, clock.elapsed, animate: animate && built.value);
  built.value = true;
  final now = clock.elapsed;
  if (reveal.settled(now)) {
    if (ticker.isActive) ticker.stop();
  } else if (!ticker.isActive) {
    ticker.start();
  }
  return (reveal: reveal, now: now);
}
