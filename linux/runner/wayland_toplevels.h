#ifndef RUNNER_WAYLAND_TOPLEVELS_H_
#define RUNNER_WAYLAND_TOPLEVELS_H_

#include <glib.h>

// The window in front, through wlr-foreign-toplevel-management (Hyprland,
// Sway and other wlroots compositors). GNOME and KDE do not offer it.
struct ActiveToplevel {
  gchar* app_id;
  gchar* title;
};

// Remembers the active window unless its app id is |own_app_id|, and fills
// |out| (caller frees both strings). False when there is none or the
// compositor lacks the protocol.
bool wayland_capture_active_toplevel(const gchar* own_app_id, ActiveToplevel* out);

// Focuses the window remembered by the last capture. False when it is gone.
bool wayland_activate_captured_toplevel();

#endif  // RUNNER_WAYLAND_TOPLEVELS_H_
