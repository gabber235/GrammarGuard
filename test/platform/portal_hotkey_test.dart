import "dart:async";

import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/real/portal_hotkey.dart";
import "package:hotkey_manager/hotkey_manager.dart";

const _channel = MethodChannel("grammar_guard/global_shortcut");
final _hotKey = HotKey(
  key: PhysicalKeyboardKey.keyG,
  modifiers: [HotKeyModifier.alt, HotKeyModifier.shift],
  scope: HotKeyScope.system,
);

Future<void> _activate() => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
  _channel.name,
  _channel.codec.encodeMethodCall(const MethodCall("activated")),
  (_) {},
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];

  void runner(Object? Function(MethodCall call) answer) {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return answer(call);
    });
  }

  test("a bound shortcut is active with the desktop's note and sends the xkb keycode", () async {
    runner((call) => call.method == "register" ? {"note": "Your desktop decides the keys."} : null);

    final status = await PortalHotkey(_channel).register(_hotKey, () {});

    expect(status, const HotkeyStatus.active(note: "Your desktop decides the keys."));
    // keyG is xkb keycode 42 (evdev 34 + 8).
    expect(calls.single.arguments, {
      "keycode": 42,
      "modifiers": ["alt", "shift"],
    });
  });

  test("a refused shortcut is unavailable with the runner's reason", () async {
    runner((call) => throw PlatformException(code: "unavailable", message: "No global shortcut portal."));

    expect(
      await PortalHotkey(_channel).register(_hotKey, () {}),
      const HotkeyStatus.unavailable("No global shortcut portal."),
    );
  });

  test("activation runs the callback until unregistered", () async {
    runner((call) => call.method == "register" ? <String, Object?>{} : null);
    final hotkey = PortalHotkey(_channel);
    var pressed = 0;
    await hotkey.register(_hotKey, () => pressed++);

    await _activate();
    await hotkey.unregister();
    await _activate();

    expect(pressed, 1);
    expect(calls.map((c) => c.method), ["register", "unregister"]);
  });

  test("unregister while a register is in flight is still sent to the runner", () async {
    final bound = Completer<Map<String, Object?>>();
    runner((call) => call.method == "register" ? bound.future : null);
    final hotkey = PortalHotkey(_channel);

    final registering = hotkey.register(_hotKey, () {});
    await hotkey.unregister();
    bound.completeError(PlatformException(code: "replaced"));
    await registering;

    expect(calls.map((c) => c.method), ["register", "unregister"]);
  });
}
