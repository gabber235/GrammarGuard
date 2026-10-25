#include "portal.h"

namespace {

struct Request {
  PortalResponse done;
  gpointer user_data;
  guint subscription;
};

void on_response(GDBusConnection* connection, const gchar*, const gchar*, const gchar*,
                 const gchar*, GVariant* parameters, gpointer user_data) {
  auto* request = static_cast<Request*>(user_data);
  g_dbus_connection_signal_unsubscribe(connection, request->subscription);
  guint32 code;
  g_autoptr(GVariant) results = nullptr;
  g_variant_get(parameters, "(u@a{sv})", &code, &results);
  request->done(code, results, request->user_data);
  delete request;
}

void on_called(GObject* source, GAsyncResult* result, gpointer user_data) {
  auto* request = static_cast<Request*>(user_data);
  g_autoptr(GError) error = nullptr;
  g_autoptr(GVariant) reply =
      g_dbus_connection_call_finish(G_DBUS_CONNECTION(source), result, &error);
  if (reply) return;  // the answer comes as the Response signal
  g_dbus_connection_signal_unsubscribe(G_DBUS_CONNECTION(source), request->subscription);
  request->done(2, nullptr, request->user_data);
  delete request;
}

}  // namespace

GDBusConnection* portal_connection() {
  static GDBusConnection* connection = [] {
    g_autofree gchar* address = g_dbus_address_get_for_bus_sync(G_BUS_TYPE_SESSION, nullptr, nullptr);
    if (!address) return static_cast<GDBusConnection*>(nullptr);
    GDBusConnection* opened = g_dbus_connection_new_for_address_sync(
        address,
        static_cast<GDBusConnectionFlags>(G_DBUS_CONNECTION_FLAGS_AUTHENTICATION_CLIENT |
                                          G_DBUS_CONNECTION_FLAGS_MESSAGE_BUS_CONNECTION),
        nullptr, nullptr, nullptr);
    if (!opened) return opened;
    // Fails on portals before 1.19 and without grammarguard.desktop; the
    // portal may still name the app from its systemd unit.
    g_autoptr(GVariant) registered G_GNUC_UNUSED = g_dbus_connection_call_sync(
        opened, kPortal, kPortalPath, "org.freedesktop.host.portal.Registry", "Register",
        g_variant_new("(sa{sv})", "grammarguard", nullptr), nullptr, G_DBUS_CALL_FLAGS_NONE, -1,
        nullptr, nullptr);
    return opened;
  }();
  return connection;
}

gchar* portal_token() {
  static guint count = 0;
  return g_strdup_printf("grammarguard%u", ++count);
}

void portal_request(const gchar* interface, const gchar* method, GVariant* arguments,
                    GVariantBuilder* options, PortalResponse done, gpointer user_data) {
  GDBusConnection* connection = portal_connection();
  g_autoptr(GVariant) owned_arguments = g_variant_ref_sink(arguments);
  if (!connection) {
    g_variant_builder_unref(options);
    done(2, nullptr, user_data);
    return;
  }
  g_autofree gchar* token = portal_token();
  g_autofree gchar* sender = g_strdup(g_dbus_connection_get_unique_name(connection) + 1);
  g_strdelimit(sender, ".", '_');
  g_autofree gchar* path =
      g_strdup_printf("/org/freedesktop/portal/desktop/request/%s/%s", sender, token);
  auto* request = new Request{done, user_data, 0};
  // Subscribed before the call, with no sender: the answer may arrive
  // before the call returns.
  request->subscription = g_dbus_connection_signal_subscribe(
      connection, nullptr, "org.freedesktop.portal.Request", "Response", path, nullptr,
      G_DBUS_SIGNAL_FLAGS_NONE, on_response, request, nullptr);
  g_variant_builder_add(options, "{sv}", "handle_token", g_variant_new_string(token));

  GVariantBuilder call;
  g_variant_builder_init(&call, G_VARIANT_TYPE_TUPLE);
  GVariantIter iter;
  g_variant_iter_init(&iter, owned_arguments);
  while (GVariant* argument = g_variant_iter_next_value(&iter)) {
    g_variant_builder_add_value(&call, argument);
    g_variant_unref(argument);
  }
  g_variant_builder_add_value(&call, g_variant_builder_end(options));
  g_variant_builder_unref(options);
  g_dbus_connection_call(connection, kPortal, kPortalPath, interface, method,
                         g_variant_builder_end(&call), G_VARIANT_TYPE("(o)"),
                         G_DBUS_CALL_FLAGS_NONE, -1, nullptr, on_called, request);
}
