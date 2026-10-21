import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/real/native_text_bridge.dart";

const _channel = MethodChannel("grammar_guard/text_bridge");
const _allow = "Allow GrammarGuard in System Settings, Privacy and Security, Accessibility.";

/// Answers the runner's methods; [handle] decides copySelection and pasteInto.
void _runner(Object? Function(MethodCall call) handle) {
  var clipboard = "from the clipboard";
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    ..setMockMethodCallHandler(_channel, (call) async {
      if (call.method == "frontmostApp") return {"id": "com.example.notes", "name": "Notes", "pid": 42};
      return handle(call);
    })
    ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
      switch (call.method) {
        case "Clipboard.getData":
          return {"text": clipboard};
        case "Clipboard.setData":
          clipboard = (call.arguments as Map)["text"] as String;
      }
      return null;
    });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const bridge = NativeTextBridge(_channel);

  test("without Accessibility the copy toast says how to allow it", () async {
    _runner((call) => throw PlatformException(code: "accessibility", message: _allow));

    final captured = await bridge.capture();
    expect(captured.via, CaptureMethod.clipboard);
    expect(captured.text, "from the clipboard");
    expect(await bridge.deliver("Fixed", captured, mode: DeliveryMode.paste), const Delivery.copied(_allow));
  });

  test("nothing selected copies without a reason", () async {
    _runner((call) => null);

    final captured = await bridge.capture();
    expect(await bridge.deliver("Fixed", captured, mode: DeliveryMode.paste), const Delivery.copied());
  });

  test("a terminal gets the text on the clipboard and the reason", () async {
    _runner(
      (call) => switch (call.method) {
        "copySelection" => "teh text",
        _ => throw PlatformException(code: "terminal", message: "Terminals paste with Ctrl+Shift+V."),
      },
    );

    final captured = await bridge.capture();
    expect(
      await bridge.deliver("the text", captured, mode: DeliveryMode.paste),
      const Delivery.copied("Terminals paste with Ctrl+Shift+V."),
    );
    expect((await Clipboard.getData(Clipboard.kTextPlain))?.text, "the text");
  });
}
