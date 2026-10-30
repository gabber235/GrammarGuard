#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <cwchar>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // One GrammarGuard at a time. Opening it again (Explorer, the Start menu,
  // a shortcut) asks the running one to show its window, which may be
  // hidden with no other way back, then quits. The lock is released when
  // the process ends. Debug runs stay separate from an installed one.
#ifdef _DEBUG
  ::CreateMutexW(nullptr, FALSE, L"Local\\GrammarGuard.debug");
#else
  ::CreateMutexW(nullptr, FALSE, L"Local\\GrammarGuard");
#endif
  if (::GetLastError() == ERROR_ALREADY_EXISTS) {
    // A login start finding GrammarGuard already running leaves it hidden.
    if (wcsstr(command_line, L"--background")) return EXIT_SUCCESS;
    // Right after the running one starts, its window may not exist yet.
    HWND running = nullptr;
    for (int tries = 0; !running && tries < 20; ++tries) {
      running = ::FindWindowW(L"FLUTTER_RUNNER_WIN32_WINDOW", L"GrammarGuard");
      if (!running) ::Sleep(100);
    }
    if (running) {
      DWORD process = 0;
      ::GetWindowThreadProcessId(running, &process);
      // This launch may take the foreground; let the running app have it.
      ::AllowSetForegroundWindow(process);
      ::PostMessageW(running, ReopenMessage(), 0, 0);
    }
    return EXIT_SUCCESS;
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"GrammarGuard", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
