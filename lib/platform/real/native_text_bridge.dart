import "package:flutter/services.dart";
import "package:grammar_guard/platform/ports.dart";

/// Talks to the runner code on each OS over one method channel:
/// frontmostApp, copySelection, pasteInto.
class NativeTextBridge implements TextBridge {
  const NativeTextBridge(this._channel);

  final MethodChannel _channel;

  @override
  Future<Captured> capture() async {
    final source = await _frontmostApp();
    // GrammarGuard itself in front (or Wayland): there is no other app to
    // read from, so use the clipboard.
    if (source == null) return captureClipboard();
    final String? selected;
    try {
      selected = await _channel.invokeMethod<String>("copySelection");
    } on PlatformException catch (error) {
      return (await _clipboard(source)).copyWith(fallbackReason: error.message);
    }
    if (selected == null || selected.trim().isEmpty) return _clipboard(source);
    return Captured(text: selected, via: CaptureMethod.selection, source: source);
  }

  @override
  Future<Captured> captureClipboard() => _clipboard(null);

  @override
  Future<Delivery> deliver(String text, Captured from, {required DeliveryMode mode, String? html}) async {
    final source = from.source;
    if (from.via == CaptureMethod.selection && source != null && mode != DeliveryMode.copy) {
      try {
        final pasted = await _channel.invokeMethod<bool>("pasteInto", {
          "pid": source.processId,
          "text": text,
          // Rich paste puts HTML next to the plain text; apps that read
          // HTML (Mail, Word, Docs) use it, the rest use the text.
          if (mode == DeliveryMode.pasteRich && html != null) "html": html,
        });
        if (pasted ?? false) return const Delivery.pasted();
      } on PlatformException catch (error) {
        await Clipboard.setData(ClipboardData(text: text));
        return Delivery.copied(error.message);
      }
    }
    await Clipboard.setData(ClipboardData(text: text));
    return switch ((from.via, mode)) {
      (_, DeliveryMode.copy) => const Delivery.copied(),
      (CaptureMethod.clipboard, _) => Delivery.copied(from.fallbackReason),
      _ => Delivery.copied("${source?.name ?? "The app"} could not be pasted into."),
    };
  }

  Future<SourceApp?> _frontmostApp() async {
    final app = await _channel.invokeMapMethod<String, Object?>("frontmostApp");
    if (app == null) return null;
    return SourceApp(
      id: (app["id"]! as String).toLowerCase(),
      name: app["name"]! as String,
      processId: app["pid"]! as int,
      windowTitle: app["title"] as String?,
      url: app["url"] is String ? Uri.tryParse(app["url"]! as String) : null,
    );
  }

  Future<Captured> _clipboard(SourceApp? source) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return Captured(text: data?.text ?? "", via: CaptureMethod.clipboard, source: source);
  }
}
