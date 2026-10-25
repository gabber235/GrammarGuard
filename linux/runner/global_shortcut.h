#ifndef RUNNER_GLOBAL_SHORTCUT_H_
#define RUNNER_GLOBAL_SHORTCUT_H_

#include <flutter_linux/flutter_linux.h>

// The "grammar_guard/global_shortcut" method channel: register (keycode,
// modifiers) and unregister from Dart, activated to Dart. Wayland only.
void global_shortcut_register(FlView* view);

#endif  // RUNNER_GLOBAL_SHORTCUT_H_
