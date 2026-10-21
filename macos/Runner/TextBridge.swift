import ApplicationServices
import Carbon.HIToolbox
import Cocoa
import FlutterMacOS

/// Reads the selection in the front app and pastes text back into it.
/// Needs the Accessibility permission, which needs the app sandbox off.
final class TextBridge {
  static func register(with messenger: FlutterBinaryMessenger) {
    let bridge = TextBridge()
    FlutterMethodChannel(name: "grammar_guard/text_bridge", binaryMessenger: messenger)
      .setMethodCallHandler { call, result in bridge.handle(call, result) }
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    switch call.method {
    case "frontmostApp":
      result(frontmostApp())
    case "copySelection":
      copySelection(result)
    case "pasteInto":
      guard let args = call.arguments as? [String: Any],
            let pid = args["pid"] as? Int, let text = args["text"] as? String else {
        return result(FlutterError(code: "arguments", message: "pid and text are required", details: nil))
      }
      pasteInto(pid: pid_t(pid), text: text, html: args["html"] as? String, result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func frontmostApp() -> [String: Any]? {
    guard let app = NSWorkspace.shared.frontmostApplication,
          app.processIdentifier != ProcessInfo.processInfo.processIdentifier else { return nil }
    var info: [String: Any] = [
      "id": app.bundleIdentifier ?? app.localizedName ?? "unknown",
      "name": app.localizedName ?? "Unknown app",
      "pid": Int(app.processIdentifier),
    ]
    // The window title is only for profile matching (web apps in a browser).
    if AXIsProcessTrusted(),
       let window = element(AXUIElementCreateApplication(app.processIdentifier), kAXFocusedWindowAttribute) {
      if let title: String = attribute(window, kAXTitleAttribute) { info["title"] = title }
      // Browsers may expose the active tab's address as the window's
      // document (Safari does). When they do not, url stays absent.
      if let url: String = attribute(window, kAXDocumentAttribute) { info["url"] = url }
    }
    return info
  }

  /// Accessibility first (no clipboard involved). Apps that do not expose
  /// their selection (Electron, many browsers) get a simulated ⌘C, and the
  /// user's clipboard is restored afterwards.
  private func copySelection(_ result: @escaping FlutterResult) {
    guard ensureTrusted() else { return result(accessibilityError) }
    let system = AXUIElementCreateSystemWide()
    if let focused = element(system, kAXFocusedUIElementAttribute),
       let text: String = attribute(focused, kAXSelectedTextAttribute), !text.isEmpty {
      return result(text)
    }
    let board = NSPasteboard.general
    let saved = snapshot(board)
    let before = board.changeCount
    postKey(CGKeyCode(kVK_ANSI_C))
    waitForChange(board, from: before, deadline: Date().addingTimeInterval(0.35)) { changed in
      let text = changed ? board.string(forType: .string) : nil
      if changed { self.restore(board, saved) }
      result(text)
    }
  }

  private func pasteInto(pid: pid_t, text: String, html: String?, _ result: @escaping FlutterResult) {
    guard ensureTrusted() else { return result(accessibilityError) }
    guard let app = NSRunningApplication(processIdentifier: pid) else { return result(false) }
    let board = NSPasteboard.general
    let saved = snapshot(board)
    board.clearContents()
    board.setString(text, forType: .string)
    if let html { board.setString(html, forType: .html) }
    if #available(macOS 14.0, *) {
      // Cooperative activation: hand focus over explicitly, or the
      // target may refuse to come to the front.
      NSApp.yieldActivation(to: app)
      app.activate()
    } else {
      app.activate(options: [])
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
      self.postKey(CGKeyCode(kVK_ANSI_V))
      // The target reads the pasteboard asynchronously; restore after it did.
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        self.restore(board, saved)
        result(true)
      }
    }
  }

  /// Dart shows the message after "Copied", so the user knows why.
  private let accessibilityError = FlutterError(
    code: "accessibility",
    message: "Allow GrammarGuard in System Settings, Privacy and Security, Accessibility.",
    details: nil)

  private func ensureTrusted() -> Bool {
    let prompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
    return AXIsProcessTrustedWithOptions([prompt: true] as CFDictionary)
  }

  private func attribute<T>(_ element: AXUIElement, _ name: String) -> T? {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success else { return nil }
    return value as? T
  }

  /// A cast to a CoreFoundation type always succeeds in Swift, so check the
  /// type ID before treating an attribute value as an element.
  private func element(_ parent: AXUIElement, _ name: String) -> AXUIElement? {
    var value: CFTypeRef?
    guard AXUIElementCopyAttributeValue(parent, name as CFString, &value) == .success,
          let value, CFGetTypeID(value) == AXUIElementGetTypeID() else { return nil }
    return (value as! AXUIElement)
  }

  /// ⌘ plus a key. The flags are set on the event, so the Option and Shift
  /// the user still holds from the hotkey do not leak in.
  private func postKey(_ key: CGKeyCode) {
    let source = CGEventSource(stateID: .combinedSessionState)
    for down in [true, false] {
      let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: down)
      event?.flags = .maskCommand
      event?.post(tap: .cghidEventTap)
    }
  }

  private func snapshot(_ board: NSPasteboard) -> [NSPasteboardItem] {
    (board.pasteboardItems ?? []).map { item in
      let copy = NSPasteboardItem()
      for type in item.types {
        if let data = item.data(forType: type) { copy.setData(data, forType: type) }
      }
      return copy
    }
  }

  private func restore(_ board: NSPasteboard, _ items: [NSPasteboardItem]) {
    board.clearContents()
    if !items.isEmpty { board.writeObjects(items) }
  }

  private func waitForChange(_ board: NSPasteboard, from count: Int, deadline: Date, _ done: @escaping (Bool) -> Void) {
    if board.changeCount != count { return done(true) }
    if Date() > deadline { return done(false) }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
      self.waitForChange(board, from: count, deadline: deadline, done)
    }
  }
}
