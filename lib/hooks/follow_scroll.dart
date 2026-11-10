import "package:flutter/widgets.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/ui/motion.dart";

/// Room at the end that still counts as being at the end.
const _slack = 24.0;

/// Keeps [scroll] at the end of a text that grows while [writing], so the
/// newest words stay in view. Scrolling away from the end (wheel, J, K)
/// stops that until the reader is back at the end. When writing ends it
/// glides back to the top, where reading starts. [content] is what grows;
/// each change of it is followed once laid out.
void useFollowWhileWriting(ScrollController? scroll, {required bool writing, required Object? content}) {
  final context = useContext();
  final following = useRef(true);
  // Scrolls this hook started, so they do not count as the reader's.
  final ours = useRef(0);
  final wasWriting = useRef(writing);

  useEffect(() {
    if (scroll == null) return null;
    void listen() {
      if (ours.value > 0 || !scroll.hasClients) return;
      final position = scroll.position;
      following.value = position.pixels >= position.maxScrollExtent - _slack;
    }

    scroll.addListener(listen);
    return () => scroll.removeListener(listen);
  }, [scroll]);

  useEffect(() {
    if (scroll == null) return null;
    final duration = context.motion(Motion.medium);
    final started = writing && !wasWriting.value;
    final ended = !writing && wasWriting.value;
    wasWriting.value = writing;
    if (started) following.value = true;
    if (!writing && !ended) return null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scroll.hasClients) return;
      final position = scroll.position;
      final double? target = ended ? 0 : (following.value ? position.maxScrollExtent : null);
      if (target == null || target == position.pixels) return;
      if (duration == Duration.zero) {
        position.jumpTo(target);
        return;
      }
      ours.value++;
      position.animateTo(target, duration: duration, curve: Motion.out).whenComplete(() => ours.value--);
    });
    return null;
  }, [content, writing]);
}
