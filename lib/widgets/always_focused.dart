import "package:flutter/material.dart";

/// Keeps a focused widget inside [child] so bare key shortcuts always work.
///
/// Focus is taken back whenever it ends up above this widget: a text field
/// let go of it, or the app came back to the front and Flutter restored a
/// node higher up (the Navigator). Focus elsewhere, such as a dialog or a
/// page pushed on top, is left alone.
class AlwaysFocused extends StatefulWidget {
  const AlwaysFocused({required this.child, super.key});
  final Widget child;

  @override
  State<AlwaysFocused> createState() => _AlwaysFocusedState();
}

class _AlwaysFocusedState extends State<AlwaysFocused> {
  final _focus = FocusNode(debugLabel: "AlwaysFocused");

  @override
  void initState() {
    super.initState();
    FocusManager.instance.addListener(_refocus);
  }

  void _refocus() {
    if (!mounted || _focus.hasFocus) return;
    // While the app is in the background Flutter parks focus at the root on
    // purpose; it is restored (and checked again here) on resume.
    if (WidgetsBinding.instance.lifecycleState case final state? when state != AppLifecycleState.resumed) return;
    final primary = FocusManager.instance.primaryFocus;
    if (primary == null || _focus.ancestors.contains(primary)) _focus.requestFocus();
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_refocus);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(focusNode: _focus, autofocus: true, child: widget.child);
  }
}
