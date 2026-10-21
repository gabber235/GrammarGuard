#include "text_bridge.h"

#include <flutter/standard_method_codec.h>
#include <shlwapi.h>
#include <windows.h>

#include <chrono>
#include <cstring>
#include <optional>
#include <string>
#include <thread>
#include <utility>
#include <vector>

namespace {

std::string ToUtf8(const std::wstring& wide) {
  if (wide.empty()) return {};
  int size = WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), -1, nullptr, 0,
                                 nullptr, nullptr);
  if (size <= 1) return {};
  std::string out(size - 1, '\0');
  WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), -1, out.data(), size, nullptr,
                      nullptr);
  return out;
}

std::wstring ToWide(const std::string& utf8) {
  int size = MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, nullptr, 0);
  if (size <= 1) return {};
  std::wstring out(size - 1, L'\0');
  MultiByteToWideChar(CP_UTF8, 0, utf8.c_str(), -1, out.data(), size);
  return out;
}

// Another app (often the one that just copied) can hold the clipboard open
// for a moment, so retry for up to 100 ms. Opening with our own window as
// owner keeps SetClipboardData working after EmptyClipboard.
bool OpenClipboardRetrying(HWND owner) {
  for (int i = 0; i < 10; i++) {
    if (OpenClipboard(owner)) return true;
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
  return false;
}

// Formats whose handle is not plain HGLOBAL memory (bitmaps, metafiles,
// palettes, owner drawn data). Copying their bytes would copy a dead handle.
bool IsMemoryFormat(UINT format) {
  switch (format) {
    case CF_BITMAP:
    case CF_DSPBITMAP:
    case CF_ENHMETAFILE:
    case CF_DSPENHMETAFILE:
    case CF_METAFILEPICT:
    case CF_DSPMETAFILEPICT:
    case CF_PALETTE:
    case CF_OWNERDISPLAY:
      return false;
    default:
      return !(format >= CF_GDIOBJFIRST && format <= CF_GDIOBJLAST);
  }
}

// Every HGLOBAL clipboard format, so images (as DIB) and rich text survive.
using Snapshot = std::vector<std::pair<UINT, std::vector<char>>>;

Snapshot SaveClipboard(HWND owner) {
  Snapshot saved;
  if (!OpenClipboardRetrying(owner)) return saved;
  for (UINT format = EnumClipboardFormats(0); format != 0;
       format = EnumClipboardFormats(format)) {
    if (!IsMemoryFormat(format)) continue;
    HANDLE handle = GetClipboardData(format);
    if (!handle) continue;
    const char* data = static_cast<const char*>(GlobalLock(handle));
    if (!data) continue;
    SIZE_T size = GlobalSize(handle);
    saved.emplace_back(format, std::vector<char>(data, data + size));
    GlobalUnlock(handle);
  }
  CloseClipboard();
  return saved;
}

// Call with the clipboard open. The clipboard owns the memory on success.
void PutGlobal(UINT format, const void* data, size_t bytes) {
  HGLOBAL copy = GlobalAlloc(GMEM_MOVEABLE, bytes);
  if (!copy) return;
  void* target = GlobalLock(copy);
  if (!target) {
    GlobalFree(copy);
    return;
  }
  memcpy(target, data, bytes);
  GlobalUnlock(copy);
  if (!SetClipboardData(format, copy)) GlobalFree(copy);
}

void RestoreClipboard(HWND owner, const Snapshot& saved) {
  if (!OpenClipboardRetrying(owner)) return;
  EmptyClipboard();
  for (const auto& [format, bytes] : saved) {
    PutGlobal(format, bytes.data(), bytes.size());
  }
  CloseClipboard();
}

// CF_HTML needs a header with byte offsets into the UTF-8 payload.
std::string HtmlClipboard(const std::string& html) {
  const std::string start = "<html><body><!--StartFragment-->";
  const std::string end = "<!--EndFragment--></body></html>";
  const char* header =
      "Version:0.9\r\nStartHTML:%010zu\r\nEndHTML:%010zu\r\n"
      "StartFragment:%010zu\r\nEndFragment:%010zu\r\n";
  char buffer[160];
  // Every number is printed as ten digits, so the header size is fixed.
  size_t header_size = static_cast<size_t>(snprintf(
      buffer, sizeof buffer, header, size_t{0}, size_t{0}, size_t{0},
      size_t{0}));
  size_t fragment = header_size + start.size();
  size_t total = fragment + html.size() + end.size();
  snprintf(buffer, sizeof buffer, header, header_size, total, fragment,
           fragment + html.size());
  return std::string(buffer) + start + html + end;
}

void SetClipboardText(HWND owner, const std::wstring& text,
                      const std::string* html) {
  if (!OpenClipboardRetrying(owner)) return;
  EmptyClipboard();
  PutGlobal(CF_UNICODETEXT, text.c_str(), (text.size() + 1) * sizeof(wchar_t));
  if (html) {
    static const UINT cf_html = RegisterClipboardFormatW(L"HTML Format");
    const std::string payload = HtmlClipboard(*html);
    PutGlobal(cf_html, payload.c_str(), payload.size() + 1);
  }
  CloseClipboard();
}

std::optional<std::wstring> ClipboardText(HWND owner) {
  if (!OpenClipboardRetrying(owner)) return std::nullopt;
  std::optional<std::wstring> text;
  if (HANDLE handle = GetClipboardData(CF_UNICODETEXT)) {
    if (const wchar_t* data = static_cast<const wchar_t*>(GlobalLock(handle))) {
      text = data;
      GlobalUnlock(handle);
    }
  }
  CloseClipboard();
  return text;
}

// The hotkey fires while Alt and Shift are still down. A Ctrl+C sent now
// would arrive as Ctrl+Alt+Shift+C, so wait up to 500 ms for a release.
void WaitForModifiersReleased() {
  for (int i = 0; i < 50; i++) {
    bool held = ((GetAsyncKeyState(VK_MENU) | GetAsyncKeyState(VK_SHIFT) |
                  GetAsyncKeyState(VK_LWIN) | GetAsyncKeyState(VK_RWIN)) &
                 0x8000) != 0;
    if (!held) return;
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
}

void SendCtrl(WORD key) {
  INPUT inputs[4] = {};
  const WORD keys[4] = {VK_CONTROL, key, key, VK_CONTROL};
  for (int i = 0; i < 4; i++) {
    inputs[i].type = INPUT_KEYBOARD;
    inputs[i].ki.wVk = keys[i];
    inputs[i].ki.dwFlags = i >= 2 ? KEYEVENTF_KEYUP : 0;
  }
  SendInput(4, inputs, sizeof(INPUT));
}

const std::string* StringArgument(const flutter::EncodableMap& args,
                                  const char* key) {
  auto found = args.find(flutter::EncodableValue(key));
  if (found == args.end()) return nullptr;
  return std::get_if<std::string>(&found->second);
}

}  // namespace

TextBridge::TextBridge(flutter::BinaryMessenger* messenger, HWND own_window)
    : own_window_(own_window),
      channel_(
          std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
              messenger, "grammar_guard/text_bridge",
              &flutter::StandardMethodCodec::GetInstance())) {
  channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    const std::string& method = call.method_name();
    if (method == "frontmostApp") return FrontmostApp(std::move(result));
    if (method == "copySelection") return CopySelection(std::move(result));
    if (method == "pasteInto") {
      const auto* args = std::get_if<flutter::EncodableMap>(call.arguments());
      const std::string* text = args ? StringArgument(*args, "text") : nullptr;
      if (!text) {
        return result->Error("arguments", "pid and text are required");
      }
      const std::string* html = StringArgument(*args, "html");
      return PasteInto(*text,
                       html ? std::optional<std::string>(*html) : std::nullopt,
                       std::move(result));
    }
    result->NotImplemented();
  });
}

void TextBridge::FrontmostApp(Result result) {
  HWND window = GetForegroundWindow();
  DWORD pid = 0;
  if (window) GetWindowThreadProcessId(window, &pid);
  // Nothing in front, or GrammarGuard itself (any of its windows).
  if (!window || pid == GetCurrentProcessId() ||
      GetAncestor(window, GA_ROOT) == GetAncestor(own_window_, GA_ROOT)) {
    return result->Success();
  }
  wchar_t path[MAX_PATH] = {};
  DWORD length = MAX_PATH;
  if (HANDLE process =
          OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid)) {
    QueryFullProcessImageNameW(process, 0, path, &length);
    CloseHandle(process);
  }
  std::wstring exe = PathFindFileNameW(path);  // "Discord.exe"
  std::wstring name = exe.substr(0, exe.rfind(L'.'));
  wchar_t title[512] = {};
  GetWindowTextW(window, title, 512);
  source_window_ = window;  // pasteInto brings it back

  result->Success(flutter::EncodableValue(flutter::EncodableMap{
      {flutter::EncodableValue("id"),
       flutter::EncodableValue(exe.empty() ? "unknown" : ToUtf8(exe))},
      {flutter::EncodableValue("name"),
       flutter::EncodableValue(name.empty() ? "Unknown app" : ToUtf8(name))},
      {flutter::EncodableValue("pid"),
       flutter::EncodableValue(static_cast<int32_t>(pid))},
      {flutter::EncodableValue("title"),
       flutter::EncodableValue(ToUtf8(title))},
  }));
}

void TextBridge::CopySelection(Result result) {
  Snapshot saved = SaveClipboard(own_window_);
  DWORD before = GetClipboardSequenceNumber();
  WaitForModifiersReleased();
  SendCtrl('C');
  for (int i = 0; i < 35 && GetClipboardSequenceNumber() == before; i++) {
    std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
  if (GetClipboardSequenceNumber() == before) {
    return result->Success();  // nothing selected
  }
  std::optional<std::wstring> text = ClipboardText(own_window_);
  RestoreClipboard(own_window_, saved);
  if (!text) return result->Success();
  result->Success(flutter::EncodableValue(ToUtf8(*text)));
}

void TextBridge::PasteInto(const std::string& text,
                           std::optional<std::string> html, Result result) {
  if (!source_window_ || !IsWindow(source_window_)) {
    return result->Success(flutter::EncodableValue(false));
  }
  Snapshot saved = SaveClipboard(own_window_);
  SetClipboardText(own_window_, ToWide(text), html ? &*html : nullptr);
  // Allowed: GrammarGuard is the foreground process when Enter is pressed.
  SetForegroundWindow(source_window_);
  std::this_thread::sleep_for(std::chrono::milliseconds(120));
  SendCtrl('V');
  // The target reads the clipboard asynchronously; restore after it did.
  std::this_thread::sleep_for(std::chrono::milliseconds(400));
  RestoreClipboard(own_window_, saved);
  result->Success(flutter::EncodableValue(true));
}
