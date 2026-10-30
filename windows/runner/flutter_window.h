#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/method_channel.h>
#include <windows.h>

#include <memory>

#include "text_bridge.h"
#include "win32_window.h"

// Posted by a second launch to the running app's window: show it.
UINT ReopenMessage();

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;

  // The "grammar_guard/text_bridge" channel. Reset before the controller,
  // since it talks through the controller's messenger.
  std::unique_ptr<TextBridge> text_bridge_;

  // The "grammar_guard/app" channel: reopen to Dart. Reset before the
  // controller, like text_bridge_.
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      app_channel_;
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
