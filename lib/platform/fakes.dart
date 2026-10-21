import "dart:async";

import "package:flutter/foundation.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:hotkey_manager/hotkey_manager.dart";

class FakeWindow implements DesktopWindow {
  bool visible = false;
  bool closed = false;
  bool popup = false;
  final _events = StreamController<WindowEvent>.broadcast();

  void emit(WindowEvent event) => _events.add(event);

  @override
  Stream<WindowEvent> get events => _events.stream;

  @override
  Future<bool> isVisible() async => visible;

  @override
  Future<void> show() async => visible = true;

  @override
  Future<void> hide() async => visible = false;

  @override
  Future<void> setPopup({required bool popup}) async => this.popup = popup;

  @override
  Future<void> close() async => closed = true;
}

class FakeHotkey implements GlobalHotkey {
  FakeHotkey({this.status = const HotkeyStatus.active()});

  HotkeyStatus status;
  HotKey? registered;
  VoidCallback? _onPressed;

  /// Simulates the user pressing the global shortcut in another app.
  void press() => _onPressed?.call();

  @override
  Future<HotkeyStatus> register(HotKey hotKey, VoidCallback onPressed) async {
    if (status is HotkeyActive) {
      registered = hotKey;
      _onPressed = onPressed;
    }
    return status;
  }

  @override
  Future<void> unregister() async {
    registered = null;
    _onPressed = null;
  }
}

class FakeTextBridge implements TextBridge {
  FakeTextBridge({this.selection, this.clipboard = "", this.source});

  String? selection;
  String clipboard;
  SourceApp? source;

  /// False simulates a missing Accessibility permission.
  bool canPaste = true;

  /// Every successful paste back, with the app it went to.
  final pasted = <(String text, SourceApp? into)>[];

  @override
  Future<Captured> capture() async {
    final selected = selection;
    if (source != null && selected != null && selected.trim().isNotEmpty) {
      return Captured(text: selected, via: CaptureMethod.selection, source: source);
    }
    return Captured(text: clipboard, via: CaptureMethod.clipboard, source: source);
  }

  @override
  Future<Captured> captureClipboard() async {
    return Captured(text: clipboard, via: CaptureMethod.clipboard);
  }

  /// The rich form of the last [DeliveryMode.pasteRich] delivery.
  String? lastHtml;

  @override
  Future<Delivery> deliver(String text, Captured from, {required DeliveryMode mode, String? html}) async {
    if (from.via == CaptureMethod.selection && canPaste && mode != DeliveryMode.copy) {
      pasted.add((text, from.source));
      lastHtml = html;
      return const Delivery.pasted();
    }
    clipboard = text;
    return switch ((from.via, mode, canPaste)) {
      (CaptureMethod.clipboard, _, _) || (_, DeliveryMode.copy, _) => const Delivery.copied(),
      _ => const Delivery.copied("Allow GrammarGuard in Accessibility settings."),
    };
  }
}
