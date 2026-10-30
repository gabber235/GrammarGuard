import "dart:async";
import "dart:io";

import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_acrylic/flutter_acrylic.dart";

import "package:grammar_guard/platform/ports.dart";
import "package:window_manager/window_manager.dart";

class WindowManagerWindow with WindowListener, WidgetsBindingObserver implements DesktopWindow {
  WindowManagerWindow(this._manager) {
    _manager.addListener(this);
    // The runner reports the OS opening the app again (macOS reopen, a
    // second launch on Windows and Linux), which window_manager does not.
    _app.setMethodCallHandler((call) async {
      if (call.method != "reopen") throw MissingPluginException();
      _events.add(WindowEvent.reopened);
    });
    WidgetsBinding.instance.addObserver(this);
    // Closing goes through onWindowClose so a running rewrite is cancelled first.
    unawaited(_manager.setPreventClose(true));
  }

  final WindowManager _manager;
  static const _app = MethodChannel("grammar_guard/app");
  final _events = StreamController<WindowEvent>.broadcast();
  var _popup = false;

  @override
  Stream<WindowEvent> get events => _events.stream;

  @override
  void onWindowBlur() => _events.add(WindowEvent.blurred);

  @override
  void onWindowClose() => _events.add(WindowEvent.closeRequested);

  @override
  Future<bool> isVisible() => _manager.isVisible();

  @override
  Future<void> show() async {
    await _manager.show();
    await _manager.focus();
  }

  @override
  Future<void> hide() => _manager.hide();

  @override
  Future<void> setPopup({required bool popup}) async {
    if (Platform.isMacOS) {
      // The style itself is fixed at launch (window_setup.dart). Changing it
      // resizes the Flutter view, and doing that while the popup is hidden
      // left Metal with a wrongly sized texture: a blank or crashed window
      // on the next show. Only the traffic lights change here.
      await _manager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: !popup);
    } else {
      await _manager.setTitleBarStyle(
        popup ? TitleBarStyle.hidden : TitleBarStyle.normal,
        windowButtonVisibility: !popup,
      );
    }
    await _manager.setAlwaysOnTop(popup);
    await _manager.setSkipTaskbar(popup);
    _popup = popup;
    await _applyGlass();
  }

  /// The system switched between light and dark: the glass follows, like
  /// the app's theme does.
  @override
  void didChangePlatformBrightness() => unawaited(_applyGlass());

  /// Lens glass: the OS blurs whatever is behind the window, in a material
  /// that matches the theme. macOS's HUD material is always dark, so light
  /// mode uses the popover material, which is light. Linux has no compositor
  /// blur through flutter_acrylic, so it gets the solid theme surface.
  Future<void> _applyGlass() async {
    // On Linux, setEffect hides and reshows the window and the Flutter view.
    // GTK drops the view's keyboard focus on hide and never gives it back,
    // so every key after that is lost.
    if (Platform.isLinux) return;
    final dark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    if (Platform.isMacOS) await Window.overrideMacOSBrightness(dark: dark);
    await Window.setEffect(
      effect: !_popup
          ? WindowEffect.disabled
          : Platform.isMacOS
          ? (dark ? WindowEffect.hudWindow : WindowEffect.popover)
          : WindowEffect.acrylic,
      dark: dark,
    );
  }

  @override
  Future<void> close() => _manager.destroy();

  void dispose() {
    _manager.removeListener(this);
    _app.setMethodCallHandler(null);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_events.close());
  }
}
