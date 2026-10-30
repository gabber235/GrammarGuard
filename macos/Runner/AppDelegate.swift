import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  /// Finder, the Dock, Spotlight or Raycast opened the running app again.
  /// The window may be hidden with no other way back (a broken hotkey), so
  /// Dart shows it.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      FlutterMethodChannel(name: "grammar_guard/app", binaryMessenger: controller.engine.binaryMessenger)
        .invokeMethod("reopen", arguments: nil)
    }
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
