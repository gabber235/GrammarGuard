import FlutterMacOS
import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

/// Streams Apple's on-device model to Dart. Every run shares one event
/// stream; each event is a map with the run's id and a "delta", "error" or
/// "done". Dart may start a new run before it cancels the old one, so runs
/// are kept apart by id and cancel only their own task.
final class AppleModelChannel: NSObject, FlutterStreamHandler {
  private var events: FlutterEventSink?
  private var tasks: [Int: Task<Void, Never>] = [:]

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = AppleModelChannel()
    FlutterMethodChannel(name: "grammar_guard/apple_model", binaryMessenger: messenger)
      .setMethodCallHandler { call, result in channel.handle(call, result) }
    FlutterEventChannel(name: "grammar_guard/apple_model/stream", binaryMessenger: messenger)
      .setStreamHandler(channel)
  }

  private func handle(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    switch call.method {
    case "isAvailable":
      #if canImport(FoundationModels)
      if #available(macOS 26.0, *) {
        return result(SystemLanguageModel.default.isAvailable)
      }
      #endif
      result(false)
    case "start":
      guard let args = call.arguments as? [String: Any], let id = args["id"] as? Int,
            let system = args["system"] as? String, let user = args["user"] as? String else {
        return result(FlutterError(code: "arguments", message: "id, system and user are required", details: nil))
      }
      result(start(id: id, system: system, user: user))
    case "cancel":
      if let id = call.arguments as? Int { tasks.removeValue(forKey: id)?.cancel() }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func start(id: Int, system: String, user: String) -> FlutterError? {
    #if canImport(FoundationModels)
    guard #available(macOS 26.0, *) else {
      return FlutterError(code: "unavailable", message: "Needs macOS 26 with Apple Intelligence.", details: nil)
    }
    tasks[id] = Task {
      do {
        let session = LanguageModelSession(instructions: system)
        var sent = ""
        // Snapshots hold the whole answer so far; send only the new part.
        for try await snapshot in session.streamResponse(to: user) {
          let text = snapshot.content
          guard text.count > sent.count, text.hasPrefix(sent) else { continue }
          let delta = String(text.dropFirst(sent.count))
          sent = text
          await MainActor.run { self.send(id, ["delta": delta]) }
        }
        await MainActor.run { self.finish(id, ["done": true]) }
      } catch is CancellationError {
        return
      } catch {
        await MainActor.run { self.finish(id, ["error": error.localizedDescription]) }
      }
    }
    return nil
    #else
    return FlutterError(code: "unavailable", message: "Built without the macOS 26 SDK.", details: nil)
    #endif
  }

  private func send(_ id: Int, _ event: [String: Any]) {
    events?(event.merging(["id": id]) { old, _ in old })
  }

  private func finish(_ id: Int, _ event: [String: Any]) {
    tasks[id] = nil
    send(id, event)
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.events = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    events = nil
    return nil
  }
}
