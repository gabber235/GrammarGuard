#include "wayland_keyboard.h"

#include <glib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <wayland-client.h>
#include <xkbcommon/xkbcommon.h>

#include <cstring>

#include "virtual-keyboard-unstable-v1-client-protocol.h"

namespace {

// evdev codes, which the protocol takes: xkb keycodes minus 8.
constexpr uint32_t kControl = 29;
constexpr uint32_t kShift = 42;
constexpr uint32_t kV = 47;

struct Globals {
  wl_seat* seat = nullptr;
  zwp_virtual_keyboard_manager_v1* manager = nullptr;
};

void on_global(void* data, wl_registry* registry, uint32_t name, const char* interface,
               uint32_t) {
  auto* globals = static_cast<Globals*>(data);
  if (!globals->seat && strcmp(interface, wl_seat_interface.name) == 0) {
    globals->seat = static_cast<wl_seat*>(wl_registry_bind(registry, name, &wl_seat_interface, 1));
  } else if (strcmp(interface, zwp_virtual_keyboard_manager_v1_interface.name) == 0) {
    globals->manager = static_cast<zwp_virtual_keyboard_manager_v1*>(
        wl_registry_bind(registry, name, &zwp_virtual_keyboard_manager_v1_interface, 1));
  }
}

void on_global_remove(void*, wl_registry*, uint32_t) {}

constexpr wl_registry_listener kRegistryListener = {on_global, on_global_remove};

// The keymap is the default layout (XKB_DEFAULT_LAYOUT, else us). Ctrl and V
// sit on the same physical keys in Latin layouts, and the compositor switches
// back to the real keyboard's keymap at its next key press.
bool send_keymap(zwp_virtual_keyboard_v1* keyboard, xkb_keymap* keymap) {
  g_autofree gchar* text = xkb_keymap_get_as_string(keymap, XKB_KEYMAP_FORMAT_TEXT_V1);
  if (!text) return false;
  size_t size = strlen(text) + 1;
  int fd = memfd_create("grammarguard-keymap", MFD_CLOEXEC);
  if (fd < 0) return false;
  bool written = write(fd, text, size) == static_cast<ssize_t>(size);
  if (written) zwp_virtual_keyboard_v1_keymap(keyboard, WL_KEYBOARD_KEYMAP_FORMAT_XKB_V1, fd, size);
  close(fd);
  return written;
}

void type_paste(zwp_virtual_keyboard_v1* keyboard, xkb_keymap* keymap, bool shift) {
  uint32_t ctrl = 1u << xkb_keymap_mod_get_index(keymap, XKB_MOD_NAME_CTRL);
  uint32_t ctrl_shift = ctrl | 1u << xkb_keymap_mod_get_index(keymap, XKB_MOD_NAME_SHIFT);
  uint32_t time = g_get_monotonic_time() / 1000;
  zwp_virtual_keyboard_v1_key(keyboard, time, kControl, WL_KEYBOARD_KEY_STATE_PRESSED);
  zwp_virtual_keyboard_v1_modifiers(keyboard, ctrl, 0, 0, 0);
  if (shift) {
    zwp_virtual_keyboard_v1_key(keyboard, time, kShift, WL_KEYBOARD_KEY_STATE_PRESSED);
    zwp_virtual_keyboard_v1_modifiers(keyboard, ctrl_shift, 0, 0, 0);
  }
  zwp_virtual_keyboard_v1_key(keyboard, time, kV, WL_KEYBOARD_KEY_STATE_PRESSED);
  zwp_virtual_keyboard_v1_key(keyboard, time, kV, WL_KEYBOARD_KEY_STATE_RELEASED);
  if (shift) {
    zwp_virtual_keyboard_v1_key(keyboard, time, kShift, WL_KEYBOARD_KEY_STATE_RELEASED);
    zwp_virtual_keyboard_v1_modifiers(keyboard, ctrl, 0, 0, 0);
  }
  zwp_virtual_keyboard_v1_key(keyboard, time, kControl, WL_KEYBOARD_KEY_STATE_RELEASED);
  zwp_virtual_keyboard_v1_modifiers(keyboard, 0, 0, 0, 0);
}

}  // namespace

bool wayland_type_paste(bool shift) {
  wl_display* display = wl_display_connect(nullptr);
  if (!display) return false;
  Globals globals;
  wl_registry* registry = wl_display_get_registry(display);
  wl_registry_add_listener(registry, &kRegistryListener, &globals);
  wl_display_roundtrip(display);

  bool typed = false;
  if (globals.seat && globals.manager) {
    xkb_context* context = xkb_context_new(XKB_CONTEXT_NO_FLAGS);
    xkb_keymap* keymap = xkb_keymap_new_from_names(context, nullptr, XKB_KEYMAP_COMPILE_NO_FLAGS);
    zwp_virtual_keyboard_v1* keyboard =
        zwp_virtual_keyboard_manager_v1_create_virtual_keyboard(globals.manager, globals.seat);
    if (keymap && send_keymap(keyboard, keymap)) {
      type_paste(keyboard, keymap, shift);
      typed = true;
    }
    wl_display_roundtrip(display);
    zwp_virtual_keyboard_v1_destroy(keyboard);
    xkb_keymap_unref(keymap);
    xkb_context_unref(context);
  }

  if (globals.manager) zwp_virtual_keyboard_manager_v1_destroy(globals.manager);
  if (globals.seat) wl_seat_destroy(globals.seat);
  wl_registry_destroy(registry);
  wl_display_disconnect(display);
  return typed;
}
