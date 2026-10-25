#ifndef RUNNER_WAYLAND_SELECTION_H_
#define RUNNER_WAYLAND_SELECTION_H_

#include <glib.h>

// The primary selection (the text selected in any app) read through
// ext-data-control-v1, which needs no keyboard or pointer focus. Null when
// the compositor lacks the protocol (GNOME), nothing is selected, or the
// owning app does not answer in time. Blocks: call it off the main thread.
gchar* wayland_read_primary_selection();

#endif  // RUNNER_WAYLAND_SELECTION_H_
