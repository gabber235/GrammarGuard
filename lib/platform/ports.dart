import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hotkey_manager/hotkey_manager.dart";

part "ports.freezed.dart";

/// The app the user was in when the hotkey fired.
@freezed
abstract class SourceApp with _$SourceApp {
  const factory SourceApp({
    /// macOS bundle id, Windows exe name or X11 WM_CLASS, lowercased.
    required String id,

    /// Display name. The only part of the source sent to the model.
    required String name,

    /// Brings the app back to the front before pasting.
    required int processId,

    /// For profile matching only, never sent to the model.
    String? windowTitle,

    /// The active browser tab, where the OS exposes it (macOS browsers
    /// through Accessibility). For profile matching only.
    Uri? url,
  }) = _SourceApp;
}

enum CaptureMethod {
  /// Read from the selection. Delivery replaces it in the source app.
  selection,

  /// Nothing was selected, so the clipboard was used. Delivery copies.
  clipboard,
}

/// Text taken from the user's app when the hotkey fired.
@freezed
abstract class Captured with _$Captured {
  const factory Captured({
    required String text,
    required CaptureMethod via,

    /// Null when GrammarGuard itself was in front, or when the desktop does not
    /// name windows (GNOME and KDE on Wayland).
    SourceApp? source,

    /// Why the selection could not be read and the clipboard was used
    /// instead (no Accessibility permission). Shown when the clipboard is
    /// empty and again on delivery.
    String? fallbackReason,
  }) = _Captured;
}

/// How a profile wants the result delivered.
enum DeliveryMode {
  /// Replace the selection with plain text.
  paste,

  /// Replace the selection with rich text rendered from Markdown, for apps
  /// such as Mail, Word and Google Docs that do not read Markdown.
  pasteRich,

  /// Never paste; put the result on the clipboard.
  copy,
}

@freezed
sealed class Delivery with _$Delivery {
  /// The text replaced the selection in the source app.
  const factory Delivery.pasted() = Pasted;

  /// The text is on the clipboard. [reason] says why it was not pasted.
  const factory Delivery.copied([String? reason]) = Copied;
}

/// Reads and writes text in other apps.
abstract interface class TextBridge {
  /// Must run before GrammarGuard takes focus, so the source app is still
  /// in front. Falls back to the clipboard when nothing is selected.
  Future<Captured> capture();

  /// The user's explicit "use the clipboard" command inside the window.
  Future<Captured> captureClipboard();

  /// Delivers [text] as [mode] asks. [html] is the rich form for
  /// [DeliveryMode.pasteRich]. Restores the user's clipboard after pasting.
  Future<Delivery> deliver(String text, Captured from, {required DeliveryMode mode, String? html});
}

enum WindowEvent {
  blurred,
  closeRequested,

  /// The OS opened the running app again: Finder, the Dock, Raycast,
  /// Explorer, the Start menu or a desktop shortcut.
  reopened,
}

/// GrammarGuard's own window.
abstract interface class DesktopWindow {
  Stream<WindowEvent> get events;
  Future<bool> isVisible();

  /// Shows and focuses the window.
  Future<void> show();
  Future<void> hide();

  /// Popup: no title bar, above other windows, not in the dock or taskbar,
  /// translucent glass where the OS supports it.
  Future<void> setPopup({required bool popup});

  /// Destroys the window and ends the app.
  Future<void> close();
}

@freezed
sealed class HotkeyStatus with _$HotkeyStatus {
  /// [note] explains keys the desktop, not GrammarGuard, decides.
  const factory HotkeyStatus.active({String? note}) = HotkeyActive;
  const factory HotkeyStatus.unavailable(String reason) = HotkeyUnavailable;
}

/// The system wide shortcut that summons GrammarGuard.
abstract interface class GlobalHotkey {
  /// Replaces any earlier registration.
  Future<HotkeyStatus> register(HotKey hotKey, VoidCallback onPressed);
  Future<void> unregister();
}
