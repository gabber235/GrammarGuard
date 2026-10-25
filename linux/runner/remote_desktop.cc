#include "remote_desktop.h"

#include <glib/gstdio.h>

#include "portal.h"

namespace {

constexpr const char* kRemoteDesktop = "org.freedesktop.portal.RemoteDesktop";
constexpr const char* kDeclined =
    "Allow GrammarGuard to type in the desktop's dialog to paste back. The text is on the "
    "clipboard.";
constexpr const char* kUnsupported = "This desktop cannot type into other apps. Press Ctrl+V.";

constexpr gint32 kKeysymControlL = 0xffe3;
constexpr gint32 kKeysymV = 0x76;
constexpr guint32 kKeyReleased = 0;
constexpr guint32 kKeyPressed = 1;
constexpr guint32 kDeviceKeyboard = 1;
constexpr guint32 kPersistUntilRevoked = 2;

struct Paste {
  RemotePasteDone done;
  gpointer user_data;
  gchar* session = nullptr;
  bool restoring = false;
};

gchar* token_path() {
  return g_build_filename(g_get_user_data_dir(), APPLICATION_ID, "remote_desktop_token", nullptr);
}

// Closes the session even after a successful paste, so the desktop does not
// show a remote control indicator until GrammarGuard quits.
void finish(Paste* paste, const gchar* error_code, const gchar* message) {
  if (paste->session) {
    g_dbus_connection_call(portal_connection(), kPortal, paste->session,
                           "org.freedesktop.portal.Session", "Close", nullptr, nullptr,
                           G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr, nullptr);
    g_free(paste->session);
  }
  paste->done(error_code, message, paste->user_data);
  delete paste;
}

void fail(Paste* paste, guint32 code) {
  if (code == 1) {
    finish(paste, "declined", kDeclined);
    return;
  }
  finish(paste, "unsupported", kUnsupported);
}

bool press_key(const gchar* session, gint32 keysym, guint32 state) {
  g_autoptr(GVariant) reply = g_dbus_connection_call_sync(
      portal_connection(), kPortal, kPortalPath, kRemoteDesktop, "NotifyKeyboardKeysym",
      g_variant_new("(oa{sv}iu)", session, nullptr, keysym, state), nullptr,
      G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr);
  return reply != nullptr;
}

bool type_paste(const gchar* session) {
  if (!press_key(session, kKeysymControlL, kKeyPressed)) return false;
  bool typed = press_key(session, kKeysymV, kKeyPressed) && press_key(session, kKeysymV, kKeyReleased);
  return press_key(session, kKeysymControlL, kKeyReleased) && typed;
}

gboolean type_and_finish(gpointer user_data) {
  auto* paste = static_cast<Paste*>(user_data);
  if (type_paste(paste->session)) {
    finish(paste, nullptr, nullptr);
  } else {
    finish(paste, "unsupported", kUnsupported);
  }
  return G_SOURCE_REMOVE;
}

void save_token(const gchar* restore_token) {
  g_autofree gchar* path = token_path();
  g_autofree gchar* directory = g_path_get_dirname(path);
  g_mkdir_with_parents(directory, 0700);
  g_file_set_contents(path, restore_token, -1, nullptr);
}

void on_started(guint32 code, GVariant* results, gpointer user_data) {
  auto* paste = static_cast<Paste*>(user_data);
  if (code != 0) {
    fail(paste, code);
    return;
  }
  guint32 devices = 0;
  g_variant_lookup(results, "devices", "u", &devices);
  if (!(devices & kDeviceKeyboard)) {
    finish(paste, "declined", kDeclined);
    return;
  }
  const gchar* restore_token;
  if (g_variant_lookup(results, "restore_token", "&s", &restore_token)) save_token(restore_token);
  if (paste->restoring) {
    type_and_finish(paste);
    return;
  }
  // Gives focus time to return from the permission dialog to the source app.
  g_timeout_add(300, type_and_finish, paste);
}

void on_devices_selected(guint32 code, GVariant*, gpointer user_data) {
  auto* paste = static_cast<Paste*>(user_data);
  if (code != 0) {
    fail(paste, code);
    return;
  }
  portal_request(kRemoteDesktop, "Start", g_variant_new("(os)", paste->session, ""),
                 g_variant_builder_new(G_VARIANT_TYPE_VARDICT), on_started, paste);
}

void on_created(guint32 code, GVariant* results, gpointer user_data) {
  auto* paste = static_cast<Paste*>(user_data);
  // A string in the spec, an object path in some portal versions.
  g_autoptr(GVariant) handle =
      code == 0 ? g_variant_lookup_value(results, "session_handle", nullptr) : nullptr;
  if (!handle) {
    fail(paste, code == 0 ? 2 : code);
    return;
  }
  paste->session = g_variant_dup_string(handle, nullptr);

  GVariantBuilder* options = g_variant_builder_new(G_VARIANT_TYPE_VARDICT);
  g_variant_builder_add(options, "{sv}", "types", g_variant_new_uint32(kDeviceKeyboard));
  g_variant_builder_add(options, "{sv}", "persist_mode", g_variant_new_uint32(kPersistUntilRevoked));
  g_autofree gchar* path = token_path();
  g_autofree gchar* restore_token = nullptr;
  if (g_file_get_contents(path, &restore_token, nullptr, nullptr)) {
    g_variant_builder_add(options, "{sv}", "restore_token", g_variant_new_string(restore_token));
    paste->restoring = true;
  }
  portal_request(kRemoteDesktop, "SelectDevices", g_variant_new("(o)", paste->session), options,
                 on_devices_selected, paste);
}

}  // namespace

void remote_desktop_paste(RemotePasteDone done, gpointer user_data) {
  auto* paste = new Paste{done, user_data};
  GVariantBuilder* options = g_variant_builder_new(G_VARIANT_TYPE_VARDICT);
  g_autofree gchar* token = portal_token();
  g_variant_builder_add(options, "{sv}", "session_handle_token", g_variant_new_string(token));
  portal_request(kRemoteDesktop, "CreateSession", g_variant_new("()"), options, on_created, paste);
}
