#ifndef RUNNER_PORTAL_H_
#define RUNNER_PORTAL_H_

#include <gio/gio.h>

constexpr const char* kPortal = "org.freedesktop.portal.Desktop";
constexpr const char* kPortalPath = "/org/freedesktop/portal/desktop";

// A private session bus connection for xdg-desktop-portal calls, registered
// as the host app "grammarguard". Private because the portal accepts the
// registration only as the first portal call on a connection, and GTK has
// already used the shared one. Null when there is no session bus.
GDBusConnection* portal_connection();

// Answer of a portal Request: the response code (0 success, 1 cancelled,
// 2 other) and its results.
typedef void (*PortalResponse)(guint32 code, GVariant* results, gpointer user_data);

// Calls |method| on |interface| of the portal with |arguments| followed by
// an options vardict built from |options| plus a fresh handle_token, and
// delivers the Request's Response to |done|. A D-Bus error (no portal, no
// such interface) is delivered as code 2 with null results.
void portal_request(const gchar* interface, const gchar* method, GVariant* arguments,
                    GVariantBuilder* options, PortalResponse done, gpointer user_data);

// A token unique within this process, for handle_token and
// session_handle_token.
gchar* portal_token();

#endif  // RUNNER_PORTAL_H_
