import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:grammar_guard/hooks/delayed_execution.dart";
import "package:window_manager/window_manager.dart";

/// For shortcuts to work there must be a focused widget.
/// This widget is a hack to ensure that there is always a focused widget.
class AlwaysFocused extends StatefulHookWidget {
  const AlwaysFocused({required this.child, super.key}) : super();
  final Widget child;

  @override
  State<AlwaysFocused> createState() => _AlwaysFocusedState();
}

class _AlwaysFocusedState extends State<AlwaysFocused> with WindowListener {
  final focus = FocusNode(debugLabel: "AlwaysFocusedNode");

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    focus.requestFocus();
    super.onWindowFocus();
  }

  void onFocusChange() {
    final currentFocus = FocusScope.of(context).focusedChild;

    // For shortcuts to work, a widget must be focused.
    // So if nothing is focused, request focus for a placeholder focus.
    if (currentFocus == null) {
      focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    useDelayedExecution(() {
      FocusScope.of(context).addListener(onFocusChange);
      return () => FocusScope.of(context).removeListener(onFocusChange);
    });

    return Focus(focusNode: focus, canRequestFocus: true, child: widget.child);
  }
}
