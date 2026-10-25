#include "wayland_selection.h"

#include <fcntl.h>
#include <poll.h>
#include <unistd.h>
#include <wayland-client.h>

#include <cstring>

#include "ext-data-control-v1-client-protocol.h"

namespace {

constexpr const char* kTextTypes[] = {"text/plain;charset=utf-8", "UTF8_STRING", "text/plain"};

// An app that owns the selection but hangs must not hang the shortcut.
constexpr int kReadTimeoutMs = 500;

struct Globals {
  wl_seat* seat = nullptr;
  ext_data_control_manager_v1* manager = nullptr;
};

void on_global(void* data, wl_registry* registry, uint32_t name, const char* interface,
               uint32_t) {
  auto* globals = static_cast<Globals*>(data);
  if (!globals->seat && strcmp(interface, wl_seat_interface.name) == 0) {
    globals->seat = static_cast<wl_seat*>(wl_registry_bind(registry, name, &wl_seat_interface, 1));
  } else if (strcmp(interface, ext_data_control_manager_v1_interface.name) == 0) {
    globals->manager = static_cast<ext_data_control_manager_v1*>(
        wl_registry_bind(registry, name, &ext_data_control_manager_v1_interface, 1));
  }
}

void on_global_remove(void*, wl_registry*, uint32_t) {}

constexpr wl_registry_listener kRegistryListener = {on_global, on_global_remove};

// Each offer's user data is the preferred text type it offers, or null.
void on_offer_type(void* data, ext_data_control_offer_v1* offer, const char* mime_type) {
  auto* best = static_cast<const char*>(data);
  for (const char* type : kTextTypes) {
    if (type == best) return;
    if (strcmp(type, mime_type) == 0) {
      ext_data_control_offer_v1_set_user_data(offer, const_cast<char*>(type));
      return;
    }
  }
}

constexpr ext_data_control_offer_v1_listener kOfferListener = {on_offer_type};

void on_data_offer(void*, ext_data_control_device_v1*, ext_data_control_offer_v1* offer) {
  ext_data_control_offer_v1_add_listener(offer, &kOfferListener, nullptr);
}

void on_selection(void*, ext_data_control_device_v1*, ext_data_control_offer_v1* offer) {
  if (offer) ext_data_control_offer_v1_destroy(offer);
}

void on_finished(void*, ext_data_control_device_v1*) {}

void on_primary_selection(void* data, ext_data_control_device_v1*,
                          ext_data_control_offer_v1* offer) {
  auto** primary = static_cast<ext_data_control_offer_v1**>(data);
  if (*primary) ext_data_control_offer_v1_destroy(*primary);
  *primary = offer;
}

constexpr ext_data_control_device_v1_listener kDeviceListener = {on_data_offer, on_selection,
                                                                 on_finished, on_primary_selection};

gchar* read_until_closed(int fd) {
  g_autoptr(GString) text = g_string_new(nullptr);
  char buffer[4096];
  pollfd readable = {fd, POLLIN, 0};
  while (poll(&readable, 1, kReadTimeoutMs) > 0) {
    ssize_t count = read(fd, buffer, sizeof buffer);
    if (count < 0) return nullptr;
    if (count == 0) return g_string_free(g_steal_pointer(&text), FALSE);
    g_string_append_len(text, buffer, count);
  }
  return nullptr;
}

gchar* receive_text(wl_display* display, ext_data_control_offer_v1* offer) {
  auto* type = static_cast<const char*>(ext_data_control_offer_v1_get_user_data(offer));
  if (!type) return nullptr;
  int fds[2];
  if (pipe2(fds, O_CLOEXEC) != 0) return nullptr;
  ext_data_control_offer_v1_receive(offer, type, fds[1]);
  wl_display_flush(display);
  close(fds[1]);
  gchar* text = read_until_closed(fds[0]);
  close(fds[0]);
  return text;
}

}  // namespace

gchar* wayland_read_primary_selection() {
  // A connection of its own: GTK's belongs to the main thread.
  wl_display* display = wl_display_connect(nullptr);
  if (!display) return nullptr;
  Globals globals;
  wl_registry* registry = wl_display_get_registry(display);
  wl_registry_add_listener(registry, &kRegistryListener, &globals);
  wl_display_roundtrip(display);

  gchar* text = nullptr;
  if (globals.seat && globals.manager) {
    ext_data_control_offer_v1* primary = nullptr;
    ext_data_control_device_v1* device =
        ext_data_control_manager_v1_get_data_device(globals.manager, globals.seat);
    ext_data_control_device_v1_add_listener(device, &kDeviceListener, &primary);
    // The current selections arrive right after the device is created.
    wl_display_roundtrip(display);
    if (primary) {
      text = receive_text(display, primary);
      ext_data_control_offer_v1_destroy(primary);
    }
    ext_data_control_device_v1_destroy(device);
  }

  if (globals.manager) ext_data_control_manager_v1_destroy(globals.manager);
  if (globals.seat) wl_seat_destroy(globals.seat);
  wl_registry_destroy(registry);
  wl_display_disconnect(display);
  return text;
}
