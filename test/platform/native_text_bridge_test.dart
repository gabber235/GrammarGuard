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

  test("a selection without a named app is still pasted", () async {
    final pastes = <Object?>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_channel, (call) async {
      switch (call.method) {
        case "frontmostApp":
          return null;
        case "waylandSelection":
          return "Selected";
        case "pasteInto":
          pastes.add(call.arguments);
          return true;
      }
      return null;
    });

    final captured = await bridge.capture();
    expect(captured, const Captured(text: "Selected", via: CaptureMethod.selection));
    expect(await bridge.deliver("Fixed", captured, mode: DeliveryMode.paste), const Delivery.pasted());
    expect(pastes.single, {"pid": 0, "text": "Fixed"});
  }, testOn: "linux");

  test("a paste the desktop refuses is copied with its reason", () async {
    String? clipboard;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(_channel, (call) async {
        switch (call.method) {
          case "frontmostApp":
            return null;
          case "waylandSelection":
            return "Selected";
          case "pasteInto":
            throw PlatformException(code: "unsupported", message: "This desktop cannot type into other apps.");
        }
        return null;
      })
      ..setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == "Clipboard.setData") clipboard = (call.arguments as Map)["text"] as String;
        return null;
      });

    final captured = await bridge.capture();
    expect(
      await bridge.deliver("Fixed", captured, mode: DeliveryMode.paste),
      const Delivery.copied("This desktop cannot type into other apps."),
    );
    expect(clipboard, "Fixed");
  }, testOn: "linux");
}
