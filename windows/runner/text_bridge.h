#ifndef RUNNER_TEXT_BRIDGE_H_
#define RUNNER_TEXT_BRIDGE_H_

#include <flutter/binary_messenger.h>
#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/method_result.h>
#include <windows.h>

#include <memory>
#include <optional>
#include <string>

// The "grammar_guard/text_bridge" method channel: reads the selection in the
// app in front and pastes text back into it.
class TextBridge {
 public:
  // |own_window| is GrammarGuard's top level window, so frontmostApp can tell
  // it apart from other apps.
  TextBridge(flutter::BinaryMessenger* messenger, HWND own_window);

  TextBridge(const TextBridge&) = delete;
  TextBridge& operator=(const TextBridge&) = delete;

 private:
  using Result =
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>;

  void FrontmostApp(Result result);
  void CopySelection(Result result);
  void PasteInto(const std::string& text, std::optional<std::string> html,
                 Result result);

  HWND own_window_;
  // The window in front at the last frontmostApp call; pasteInto brings it
  // back before pasting.
  HWND source_window_ = nullptr;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
};

#endif  // RUNNER_TEXT_BRIDGE_H_
