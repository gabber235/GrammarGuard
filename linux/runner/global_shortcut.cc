#include "global_shortcut.h"

#include <xkbcommon/xkbcommon.h>

#include "portal.h"

namespace {

constexpr const char* kShortcuts = "org.freedesktop.portal.GlobalShortcuts";
constexpr const char* kShortcutId = "open";
constexpr const char* kDeclined = "The desktop did not allow the shortcut.";
constexpr const char* kReplaced = "A later shortcut change replaced this one.";

struct Shortcut {
  FlMethodChannel* channel = nullptr;
  gchar* session = nullptr;
  guint activations = 0;
  guint generation = 0;
};

Shortcut shortcut;

struct Binding {
  FlMethodCall* call;
  gchar* trigger;  // null when the key has no keysym name
  guint generation;
};

bool replaced(const Binding* binding) {
  return binding->generation != shortcut.generation;
}

void finish(Binding* binding) {
  g_object_unref(binding->call);
  g_free(binding->trigger);
  delete binding;
}

void close_portal_session(const gchar* session) {
  g_dbus_connection_call(portal_connection(), kPortal, session, "org.freedesktop.portal.Session",
                         "Close", nullptr, nullptr, G_DBUS_CALL_FLAGS_NONE, -1, nullptr, nullptr,
                         nullptr);
}

void close_session() {
  if (shortcut.activations) {
    g_dbus_connection_signal_unsubscribe(portal_connection(), shortcut.activations);
    shortcut.activations = 0;
  }
  if (!shortcut.session) return;
  close_portal_session(shortcut.session);
  g_clear_pointer(&shortcut.session, g_free);
}

// The keysym name ("g", "F5", "Return") that |keycode| types at the base
// level of the default layout (XKB_DEFAULT_LAYOUT, else us).
gchar* keysym_name(xkb_keycode_t keycode) {
  xkb_context* context = xkb_context_new(XKB_CONTEXT_NO_FLAGS);
  if (!context) return nullptr;
  xkb_keymap* keymap = xkb_keymap_new_from_names(context, nullptr, XKB_KEYMAP_COMPILE_NO_FLAGS);
  xkb_context_unref(context);
  if (!keymap) return nullptr;
  gchar* name = nullptr;
  const xkb_keysym_t* syms;
  char buffer[64];
  if (xkb_keymap_key_get_syms_by_level(keymap, keycode, 0, 0, &syms) > 0 &&
      xkb_keysym_get_name(syms[0], buffer, sizeof buffer) > 0) {
    name = g_strdup(buffer);
  }
  xkb_keymap_unref(keymap);
  return name;
}

// The shortcuts spec format ("CTRL+SHIFT+g"), or null when the key has no
// keysym name.
gchar* trigger_for(xkb_keycode_t keycode, FlValue* modifiers) {
  g_autofree gchar* key = keysym_name(keycode);
  if (!key) return nullptr;
  static const struct {
    const char* modifier;
    const char* name;
  } kModifierNames[] = {{"control", "CTRL"}, {"alt", "ALT"}, {"shift", "SHIFT"}, {"meta", "LOGO"}};
  g_autoptr(GString) trigger = g_string_new(nullptr);
  for (size_t i = 0; i < fl_value_get_length(modifiers); i++) {
    const gchar* modifier = fl_value_get_string(fl_value_get_list_value(modifiers, i));
    for (const auto& entry : kModifierNames) {
      if (g_strcmp0(modifier, entry.modifier) == 0) g_string_append_printf(trigger, "%s+", entry.name);
    }
  }
  g_string_append(trigger, key);
  return g_string_free(g_steal_pointer(&trigger), FALSE);
}

gchar* note_for(GVariant* results) {
  g_autoptr(GVariant) shortcuts =
      g_variant_lookup_value(results, "shortcuts", G_VARIANT_TYPE("a(sa{sv})"));
  if (shortcuts) {
    GVariantIter iter;
    g_variant_iter_init(&iter, shortcuts);
    const gchar* id;
    GVariant* properties;
    while (g_variant_iter_next(&iter, "(&s@a{sv})", &id, &properties)) {
      g_autoptr(GVariant) owned_properties G_GNUC_UNUSED = properties;
      const gchar* description;
      if (g_strcmp0(id, kShortcutId) == 0 &&
          g_variant_lookup(properties, "trigger_description", "&s", &description) && *description) {
        return g_strdup_printf(
            "Your desktop opens GrammarGuard with %s. Change the keys in its shortcut settings.",
            description);
      }
    }
  }
  return g_strdup(
      "Your desktop decides the keys. Assign them to Open GrammarGuard in its shortcut settings. "
      "Some, such as Hyprland, need a bind to grammarguard:open in their configuration.");
}

void decline(Binding* binding) {
  close_session();
  fl_method_call_respond_error(binding->call, "declined", kDeclined, nullptr, nullptr);
  finish(binding);
}

// The call that replaced it already closed its session.
void cancel(Binding* binding) {
  fl_method_call_respond_error(binding->call, "replaced", kReplaced, nullptr, nullptr);
  finish(binding);
}

void on_activated(GDBusConnection*, const gchar*, const gchar*, const gchar*, const gchar*,
                  GVariant* parameters, gpointer) {
  const gchar* session;
  const gchar* id;
  g_variant_get_child(parameters, 0, "&o", &session);
  g_variant_get_child(parameters, 1, "&s", &id);
  if (g_strcmp0(session, shortcut.session) != 0 || g_strcmp0(id, kShortcutId) != 0) return;
  fl_method_channel_invoke_method(shortcut.channel, "activated", nullptr, nullptr, nullptr,
                                  nullptr);
}

void on_bound(guint32 code, GVariant* results, gpointer user_data) {
  auto* binding = static_cast<Binding*>(user_data);
  if (replaced(binding)) {
    cancel(binding);
    return;
  }
  if (code != 0) {
    decline(binding);
    return;
  }
  g_autofree gchar* note = note_for(results);
  g_autoptr(FlValue) bound = fl_value_new_map();
  fl_value_set_string_take(bound, "note", fl_value_new_string(note));
  fl_method_call_respond_success(binding->call, bound, nullptr);
  finish(binding);
}

void on_created(guint32 code, GVariant* results, gpointer user_data) {
  auto* binding = static_cast<Binding*>(user_data);
  // A string in the spec, an object path in some portal versions.
  g_autoptr(GVariant) session =
      code == 0 ? g_variant_lookup_value(results, "session_handle", nullptr) : nullptr;
  if (replaced(binding)) {
    if (session) close_portal_session(g_variant_get_string(session, nullptr));
    cancel(binding);
    return;
  }
  if (!session) {
    decline(binding);
    return;
  }
  shortcut.session = g_variant_dup_string(session, nullptr);
  shortcut.activations = g_dbus_connection_signal_subscribe(
      portal_connection(), nullptr, kShortcuts, "Activated", kPortalPath, nullptr,
      G_DBUS_SIGNAL_FLAGS_NONE, on_activated, nullptr, nullptr);

  GVariantBuilder properties;
  g_variant_builder_init(&properties, G_VARIANT_TYPE_VARDICT);
  g_variant_builder_add(&properties, "{sv}", "description",
                        g_variant_new_string("Open GrammarGuard"));
  if (binding->trigger) {
    g_variant_builder_add(&properties, "{sv}", "preferred_trigger",
                          g_variant_new_string(binding->trigger));
  }
  GVariantBuilder shortcuts;
  g_variant_builder_init(&shortcuts, G_VARIANT_TYPE("a(sa{sv})"));
  g_variant_builder_add(&shortcuts, "(sa{sv})", kShortcutId, &properties);
  portal_request(kShortcuts, "BindShortcuts",
                 g_variant_new("(oa(sa{sv})s)", shortcut.session, &shortcuts, ""),
                 g_variant_builder_new(G_VARIANT_TYPE_VARDICT), on_bound, binding);
}

void register_shortcut(FlMethodCall* call) {
  FlValue* args = fl_method_call_get_args(call);
  auto keycode = static_cast<xkb_keycode_t>(fl_value_get_int(fl_value_lookup_string(args, "keycode")));
  FlValue* modifiers = fl_value_lookup_string(args, "modifiers");
  shortcut.generation++;
  close_session();

  GDBusConnection* connection = portal_connection();
  g_autoptr(GVariant) version =
      connection ? g_dbus_connection_call_sync(connection, kPortal, kPortalPath,
                                               "org.freedesktop.DBus.Properties", "Get",
                                               g_variant_new("(ss)", kShortcuts, "version"),
                                               nullptr, G_DBUS_CALL_FLAGS_NONE, -1, nullptr,
                                               nullptr)
                 : nullptr;
  if (!version) {
    fl_method_call_respond_error(call, "unavailable",
                                 "Your desktop has no global shortcut portal. Open GrammarGuard "
                                 "from your app launcher and press Ctrl+V to use the clipboard.",
                                 nullptr, nullptr);
    return;
  }

  auto* binding = new Binding{FL_METHOD_CALL(g_object_ref(call)), trigger_for(keycode, modifiers),
                              shortcut.generation};
  GVariantBuilder* options = g_variant_builder_new(G_VARIANT_TYPE_VARDICT);
  g_autofree gchar* token = portal_token();
  g_variant_builder_add(options, "{sv}", "session_handle_token", g_variant_new_string(token));
  portal_request(kShortcuts, "CreateSession", g_variant_new("()"), options, on_created, binding);
}

}  // namespace

static void handle(FlMethodChannel*, FlMethodCall* call, gpointer) {
  const gchar* method = fl_method_call_get_name(call);
  if (g_strcmp0(method, "register") == 0) {
    register_shortcut(call);
    return;
  }
  if (g_strcmp0(method, "unregister") == 0) {
    shortcut.generation++;
    close_session();
    fl_method_call_respond_success(call, nullptr, nullptr);
    return;
  }
  fl_method_call_respond_not_implemented(call, nullptr);
}

void global_shortcut_register(FlView* view) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlBinaryMessenger* messenger = fl_engine_get_binary_messenger(fl_view_get_engine(view));
  // Never released: the channel lives as long as the app.
  shortcut.channel = fl_method_channel_new(messenger, "grammar_guard/global_shortcut",
                                           FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(shortcut.channel, handle, nullptr, nullptr);
}
