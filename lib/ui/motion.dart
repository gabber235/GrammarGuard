// The motion rules from the design page, as code.
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";

abstract final class Motion {
  static const fast = Duration(milliseconds: 160);
  static const medium = Duration(milliseconds: 220);
  static const slow = Duration(milliseconds: 260);
  static const out = Curves.easeOutCubic;

  /// The highlighter glide between changes: quick, a touch of overshoot.
  static const glide = Cubic(0.2, 1.1, 0.3, 1);

  /// Views and pages: long enough for the spring to settle.
  static const lift = Duration(milliseconds: 420);

  /// A view arriving: overshoots its place by a few pixels, then settles.
  static const spring = Cubic(0.34, 1.4, 0.64, 1);
}

/// How every view and page changes (see [LiftTransition]).
enum Lift {
  /// A view opens over another (the bar, the assistant, Settings): 28 px.
  deeper(28),

  /// One state of the same view becomes another (preview, a Settings
  /// section): 12 px.
  sideways(12),

  /// A small piece changes with its view (the footer's keys): 4 px.
  nudge(4);

  const Lift(this.distance);

  /// How far below its place the arriving view starts.
  final double distance;
}

/// One motion for every view change, so they all feel alike. The view on
/// its way out sinks back (shrinks a little) and is gone within 90 ms; the
/// arriving view then rises from below and from 4% smaller with a small
/// spring overshoot, so the two texts are never seen on top of each other.
/// Going back plays the same thing in reverse: the top view drops away and
/// the one below springs back up.
///
/// Driven like a route: [animation] runs forward for the arriving view and
/// backward when it leaves on the way back; [secondaryAnimation] runs forward
/// for the view being covered and backward when it comes back.
class LiftTransition extends StatelessWidget {
  const LiftTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    this.lift = Lift.deeper,
    super.key,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
  final Lift lift;

  @override
  Widget build(BuildContext context) {
    final still = context.reduceMotion;
    return AnimatedBuilder(
      animation: Listenable.merge([animation, secondaryAnimation]),
      builder: (context, child) {
        // The arriving view, and the top view leaving on the way back. The
        // leaving view is gone before the other shows: never two texts at once.
        final rise = _along(
          animation,
          const Interval(0.22, 1, curve: Motion.spring),
          const Interval(0.6, 1, curve: Curves.easeIn),
        );
        final shown = _along(
          animation,
          const Interval(0.24, 0.6, curve: Curves.easeOut),
          const Interval(0.76, 1, curve: Curves.easeIn),
        );
        // The covered view, and that view springing back on the way back.
        final sink = _along(
          secondaryAnimation,
          const Interval(0, 0.4, curve: Curves.easeOut),
          const Interval(0, 0.76, curve: FlippedCurve(Motion.spring)),
        );
        final hidden = _along(
          secondaryAnimation,
          const Interval(0, 0.22, curve: Curves.easeIn),
          const Interval(0.4, 0.74, curve: Curves.easeIn),
        );
        final faded = Opacity(opacity: (shown * (1 - hidden)).clamp(0, 1), child: child);
        // Reduced motion keeps the fades, which never overlap, and drops the movement.
        if (still) return faded;
        return Transform.translate(
          offset: Offset(0, lift.distance * (1 - rise)),
          child: Transform.scale(scale: (0.96 + 0.04 * rise) * (1 - 0.05 * sink), child: faded),
        );
      },
      child: child,
    );
  }

  /// [animation] through [forward], or through [back] while it runs backward.
  static double _along(Animation<double> animation, Curve forward, Curve back) =>
      (animation.status == AnimationStatus.reverse ? back : forward).transform(animation.value);
}

/// [LiftTransition] for routes: Settings and the editor.
class LiftPageTransitionsBuilder extends PageTransitionsBuilder {
  const LiftPageTransitionsBuilder();

  @override
  Duration get transitionDuration => Motion.lift;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => LiftTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child);
}

extension MotionContext on BuildContext {
  /// The OS "reduce motion" setting. Every animation here checks it.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);

  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}

extension Entrances on Widget {
  /// The window as it opens, and small things that arrive (a reason, an
  /// answer): fades in and springs up from 4% smaller.
  Widget appear(BuildContext context, {Duration delay = Duration.zero}) => context.reduceMotion
      ? this
      : animate(delay: delay)
            .fadeIn(duration: Motion.fast, curve: Motion.out)
            .scaleXY(begin: 0.96, end: 1, duration: Motion.lift, curve: Motion.spring)
            .slideY(begin: 0.02, end: 0, duration: Motion.lift, curve: Motion.spring);

  /// Bar rows and proposal lines: staggered by their index.
  Widget stagger(BuildContext context, int index) => context.reduceMotion
      ? this
      : animate(delay: Duration(milliseconds: 20 * index))
            .fadeIn(duration: Motion.fast)
            .slideY(begin: 0.15, end: 0, duration: Motion.fast, curve: Motion.out);
}
