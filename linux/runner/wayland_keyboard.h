#ifndef RUNNER_WAYLAND_KEYBOARD_H_
#define RUNNER_WAYLAND_KEYBOARD_H_

// Types Ctrl+V, or Ctrl+Shift+V when |shift|, into the focused window
// through zwp_virtual_keyboard_v1. False when the compositor lacks it
// (GNOME, KDE).
bool wayland_type_paste(bool shift);

#endif  // RUNNER_WAYLAND_KEYBOARD_H_
