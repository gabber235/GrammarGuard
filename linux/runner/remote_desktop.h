#ifndef RUNNER_REMOTE_DESKTOP_H_
#define RUNNER_REMOTE_DESKTOP_H_

#include <glib.h>

// Answer of a paste through the portal: null on success, else why not.
typedef void (*RemotePasteDone)(const gchar* error_code, const gchar* message, gpointer user_data);

// Types Ctrl+V into the focused window through the RemoteDesktop portal.
// The first call asks for permission (keyboard only); later calls reuse the
// grant through a restore token where the desktop supports it. Each call
// opens its own portal session and closes it after typing.
void remote_desktop_paste(RemotePasteDone done, gpointer user_data);

#endif  // RUNNER_REMOTE_DESKTOP_H_
