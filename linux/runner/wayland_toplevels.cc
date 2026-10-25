#include "wayland_toplevels.h"

#include <glib-unix.h>
#include <wayland-client.h>

#include <algorithm>
#include <cstring>
#include <vector>

#include "wlr-foreign-toplevel-management-unstable-v1-client-protocol.h"

namespace {

struct Toplevel {
  zwlr_foreign_toplevel_handle_v1* handle = nullptr;
  gchar* app_id = nullptr;
  gchar* title = nullptr;
  bool activated = false;
  bool pending_activated = false;
};

struct Connection {
  wl_display* display = nullptr;
  wl_registry* registry = nullptr;
  wl_seat* seat = nullptr;
  zwlr_foreign_toplevel_manager_v1* manager = nullptr;
  guint events = 0;
  std::vector<Toplevel*> toplevels;
  Toplevel* captured = nullptr;
};

Connection connection;
bool protocol_missing = false;

void free_toplevel(Toplevel* toplevel) {
  zwlr_foreign_toplevel_handle_v1_destroy(toplevel->handle);
  g_free(toplevel->app_id);
  g_free(toplevel->title);
  delete toplevel;
}

void disconnect() {
  if (connection.events) g_source_remove(connection.events);
  for (Toplevel* toplevel : connection.toplevels) free_toplevel(toplevel);
  if (connection.manager) zwlr_foreign_toplevel_manager_v1_destroy(connection.manager);
  if (connection.seat) wl_seat_destroy(connection.seat);
  wl_registry_destroy(connection.registry);
  wl_display_disconnect(connection.display);
  connection = Connection{};
}

void on_global(void*, wl_registry* registry, uint32_t name, const char* interface,
               uint32_t version) {
  if (!connection.seat && strcmp(interface, wl_seat_interface.name) == 0) {
    connection.seat =
        static_cast<wl_seat*>(wl_registry_bind(registry, name, &wl_seat_interface, 1));
  } else if (strcmp(interface, zwlr_foreign_toplevel_manager_v1_interface.name) == 0) {
    connection.manager = static_cast<zwlr_foreign_toplevel_manager_v1*>(wl_registry_bind(
        registry, name, &zwlr_foreign_toplevel_manager_v1_interface, MIN(version, 3u)));
  }
}

void on_global_remove(void*, wl_registry*, uint32_t) {}

constexpr wl_registry_listener kRegistryListener = {on_global, on_global_remove};

void on_title(void* data, zwlr_foreign_toplevel_handle_v1*, const char* title) {
  auto* toplevel = static_cast<Toplevel*>(data);
  g_free(toplevel->title);
  toplevel->title = g_strdup(title);
}

void on_app_id(void* data, zwlr_foreign_toplevel_handle_v1*, const char* app_id) {
  auto* toplevel = static_cast<Toplevel*>(data);
  g_free(toplevel->app_id);
  toplevel->app_id = g_strdup(app_id);
}

void on_output(void*, zwlr_foreign_toplevel_handle_v1*, wl_output*) {}

void on_state(void* data, zwlr_foreign_toplevel_handle_v1*, wl_array* states) {
  auto* toplevel = static_cast<Toplevel*>(data);
  toplevel->pending_activated = false;
  auto* begin = static_cast<uint32_t*>(states->data);
  auto* end = begin + states->size / sizeof(uint32_t);
  for (uint32_t* state = begin; state < end; state++) {
    if (*state == ZWLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED) {
      toplevel->pending_activated = true;
    }
  }
}

void on_done(void* data, zwlr_foreign_toplevel_handle_v1*) {
  auto* toplevel = static_cast<Toplevel*>(data);
  toplevel->activated = toplevel->pending_activated;
}

void on_closed(void* data, zwlr_foreign_toplevel_handle_v1*) {
  auto* toplevel = static_cast<Toplevel*>(data);
  auto& list = connection.toplevels;
  list.erase(std::remove(list.begin(), list.end(), toplevel), list.end());
  if (connection.captured == toplevel) {
    connection.captured = nullptr;
  }
  free_toplevel(toplevel);
}

void on_parent(void*, zwlr_foreign_toplevel_handle_v1*, zwlr_foreign_toplevel_handle_v1*) {}

constexpr zwlr_foreign_toplevel_handle_v1_listener kHandleListener = {
    on_title, on_app_id, on_output, on_output, on_state, on_done, on_closed, on_parent};

void on_toplevel(void*, zwlr_foreign_toplevel_manager_v1*, zwlr_foreign_toplevel_handle_v1* handle) {
  auto* toplevel = new Toplevel;
  toplevel->handle = handle;
  connection.toplevels.push_back(toplevel);
  zwlr_foreign_toplevel_handle_v1_add_listener(handle, &kHandleListener, toplevel);
}

void on_finished(void*, zwlr_foreign_toplevel_manager_v1*) {}

constexpr zwlr_foreign_toplevel_manager_v1_listener kManagerListener = {on_toplevel, on_finished};

// Keeps reading between captures, so events do not pile up until the
// compositor drops the client, and a lost connection is noticed. Not
// wl_display_dispatch: it blocks when a capture's roundtrip has already read
// what woke this source.
gboolean on_events(gint, GIOCondition, gpointer) {
  wl_display* display = connection.display;
  if (wl_display_dispatch_pending(display) >= 0 && wl_display_prepare_read(display) == 0 &&
      wl_display_read_events(display) >= 0 && wl_display_dispatch_pending(display) >= 0) {
    return G_SOURCE_CONTINUE;
  }
  connection.events = 0;
  disconnect();
  return G_SOURCE_REMOVE;
}

bool connect_once() {
  if (connection.display) return true;
  if (protocol_missing) return false;
  connection.display = wl_display_connect(nullptr);
  if (!connection.display) return false;
  connection.registry = wl_display_get_registry(connection.display);
  wl_registry_add_listener(connection.registry, &kRegistryListener, nullptr);
  if (wl_display_roundtrip(connection.display) < 0) {
    disconnect();
    return false;
  }
  if (!connection.manager) {
    protocol_missing = true;
    disconnect();
    return false;
  }
  zwlr_foreign_toplevel_manager_v1_add_listener(connection.manager, &kManagerListener, nullptr);
  connection.events = g_unix_fd_add(wl_display_get_fd(connection.display),
                                    static_cast<GIOCondition>(G_IO_IN | G_IO_ERR | G_IO_HUP),
                                    on_events, nullptr);
  return true;
}

}  // namespace

bool wayland_capture_active_toplevel(const gchar* own_app_id, ActiveToplevel* out) {
  if (!connect_once()) return false;
  if (wl_display_roundtrip(connection.display) < 0 ||
      wl_display_roundtrip(connection.display) < 0) {
    disconnect();
    return false;
  }
  wl_display_dispatch_pending(connection.display);

  for (Toplevel* toplevel : connection.toplevels) {
    if (!toplevel->activated || !toplevel->app_id) continue;
    if (g_strcmp0(toplevel->app_id, own_app_id) == 0) return false;
    connection.captured = toplevel;
    out->app_id = g_strdup(toplevel->app_id);
    out->title = g_strdup(toplevel->title ? toplevel->title : "");
    return true;
  }
  return false;
}

bool wayland_activate_captured_toplevel() {
  if (!connection.captured) return false;
  zwlr_foreign_toplevel_handle_v1_activate(connection.captured->handle, connection.seat);
  wl_display_flush(connection.display);
  return true;
}
