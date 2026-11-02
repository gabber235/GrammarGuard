import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:grammar_guard/platform/ports.dart";
import "package:grammar_guard/platform/real/system_hotkey.dart";
import "package:hotkey_manager/hotkey_manager.dart";

/// The real one's calls reach the OS through a channel, so they take a while.
class _Manager implements HotKeyManager {
  final registered = <HotKey>[];

  @override
  Future<void> register(HotKey hotKey, {HotKeyHandler? keyDownHandler, HotKeyHandler? keyUpHandler}) async {
    await Future<void>.delayed(Duration.zero);
    registered.add(hotKey);
  }

  @override
  Future<void> unregister(HotKey hotKey) async {
    await Future<void>.delayed(Duration.zero);
    registered.remove(hotKey);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

HotKey _key(PhysicalKeyboardKey key) => HotKey(key: key, modifiers: [HotKeyModifier.alt], scope: HotKeyScope.system);

void main() {
  final rewrite = _key(PhysicalKeyboardKey.keyG);
  final choose = _key(PhysicalKeyboardKey.keyM);

  test("changing a shortcut survives the old binding unregistering at the same moment", () async {
    final manager = _Manager();
    final hotkey = SystemHotkey(manager);
    await hotkey.register({HotkeyPurpose.rewrite: rewrite, HotkeyPurpose.chooseFirst: choose}, (_) {});

    // What the binding's rebuild does: dispose the old one, unawaited, and
    // register again straight after.
    final disposing = hotkey.unregister();
    final statuses = await hotkey.register({HotkeyPurpose.rewrite: rewrite}, (_) {});
    await disposing;

    expect(statuses, {HotkeyPurpose.rewrite: const HotkeyStatus.active()});
    expect(manager.registered, contains(rewrite));
    expect(manager.registered, isNot(contains(choose)));
  });
}
