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

Future<void> _activate([String id = "open"]) => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    .handlePlatformMessage(_channel.name, _channel.codec.encodeMethodCall(MethodCall("activated", id)), (_) {});

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

    final status = await PortalHotkey(_channel).register({HotkeyPurpose.rewrite: _hotKey}, (_) {});

    expect(status, {HotkeyPurpose.rewrite: const HotkeyStatus.active(note: "Your desktop decides the keys.")});
    // keyG is xkb keycode 42 (evdev 34 + 8).
    expect(calls.single.arguments, {
      "shortcuts": [
        {
          "id": "open",
          "keycode": 42,
          "modifiers": ["alt", "shift"],
        },
      ],
    });
  });

  test("a refused shortcut is unavailable with the runner's reason", () async {
    runner((call) => throw PlatformException(code: "unavailable", message: "No global shortcut portal."));

    expect(await PortalHotkey(_channel).register({HotkeyPurpose.rewrite: _hotKey}, (_) {}), {
      HotkeyPurpose.rewrite: const HotkeyStatus.unavailable("No global shortcut portal."),
    });
  });

  test("activation runs the callback until unregistered", () async {
    runner((call) => call.method == "register" ? <String, Object?>{} : null);
    final hotkey = PortalHotkey(_channel);
    var pressed = 0;
    await hotkey.register({HotkeyPurpose.rewrite: _hotKey}, (_) => pressed++);

    await _activate();
    await hotkey.unregister();
    await _activate();

    expect(pressed, 1);
    expect(calls.map((c) => c.method), ["register", "unregister"]);
  });

  test("each shortcut's activation says which one was pressed", () async {
    runner((call) => call.method == "register" ? <String, Object?>{} : null);
    final pressed = <HotkeyPurpose>[];
    await PortalHotkey(_channel)
        .register({HotkeyPurpose.rewrite: _hotKey, HotkeyPurpose.chooseFirst: _hotKey}, pressed.add);

    await _activate("choose");
    await _activate();

    expect(pressed, [HotkeyPurpose.chooseFirst, HotkeyPurpose.rewrite]);
    final shortcuts = (calls.single.arguments as Map)["shortcuts"] as List;
    expect(shortcuts.map((s) => (s as Map)["id"]), ["open", "choose"]);
  });

  test("unregister while a register is in flight is still sent to the runner", () async {
    final bound = Completer<Map<String, Object?>>();
    runner((call) => call.method == "register" ? bound.future : null);
    final hotkey = PortalHotkey(_channel);

    final registering = hotkey.register({HotkeyPurpose.rewrite: _hotKey}, (_) {});
    await hotkey.unregister();
    bound.completeError(PlatformException(code: "replaced"));
    await registering;

    expect(calls.map((c) => c.method), ["register", "unregister"]);
  });
}
