// The "grammar_guard/text_bridge" method channel on Linux, on X11 and on
// Wayland. Rich paste falls back to plain text here: GTK3 cannot offer
// text/html and text together without a custom target table, which no
// current Linux user has asked for.
#include "text_bridge.h"

#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/extensions/XTest.h>
#include <X11/keysym.h>
#include <gdk/gdkx.h>

#include <cstring>

#include "remote_desktop.h"
#include "wayland_keyboard.h"
#include "wayland_selection.h"
#include "wayland_toplevels.h"

namespace {

Window active_window(Display* display) {
  Atom property = XInternAtom(display, "_NET_ACTIVE_WINDOW", False);
  Atom type;
  int format;
  unsigned long count, after;
  unsigned char* data = nullptr;
  Window window = 0;
  if (XGetWindowProperty(display, DefaultRootWindow(display), property, 0, 1, False,
                         XA_WINDOW, &type, &format, &count, &after, &data) == Success &&
      data) {
    window = *reinterpret_cast<Window*>(data);
    XFree(data);
  }
  return window;
}

long window_pid(Display* display, Window window) {
  Atom property = XInternAtom(display, "_NET_WM_PID", False);
  Atom type;
  int format;
  unsigned long count, after;
  unsigned char* data = nullptr;
  long pid = 0;
  if (XGetWindowProperty(display, window, property, 0, 1, False, XA_CARDINAL, &type,
                         &format, &count, &after, &data) == Success && data) {
    pid = *reinterpret_cast<long*>(data);
    XFree(data);
  }
  return pid;
}

gchar* window_title(Display* display, Window window) {
  Atom property = XInternAtom(display, "_NET_WM_NAME", False);
  Atom utf8 = XInternAtom(display, "UTF8_STRING", False);
  Atom type;
  int format;
  unsigned long count, after;
  unsigned char* data = nullptr;
  gchar* title = nullptr;
  if (XGetWindowProperty(display, window, property, 0, 1024, False, utf8, &type, &format,
                         &count, &after, &data) == Success && data) {
    title = g_strndup(reinterpret_cast<gchar*>(data), count);
    XFree(data);
  }
  return title;
}

// Terminals paste with Ctrl+Shift+V, so a Ctrl+V would type nothing (or a
// control character). Matched on WM_CLASS or the Wayland app id, which name
// the terminal app.
bool is_terminal_name(const gchar* name) {
  static const char* const kTerminals[] = {
      "terminal",  // gnome-terminal, xfce4-terminal, and most others
      "konsole", "xterm", "rxvt", "alacritty", "kitty", "wezterm",
      "tilix", "terminator", "foot", "ghostty",
  };
  if (!name) return false;
  g_autofree gchar* lower = g_ascii_strdown(name, -1);
  for (const char* terminal : kTerminals) {
    if (strstr(lower, terminal)) return true;
  }
  return false;
}

bool is_terminal(Display* display, Window window) {
  XClassHint hint = {};
  if (!XGetClassHint(display, window, &hint)) return false;
  bool terminal = is_terminal_name(hint.res_name) || is_terminal_name(hint.res_class);
  if (hint.res_name) XFree(hint.res_name);
  if (hint.res_class) XFree(hint.res_class);
  return terminal;
}

void send_ctrl_v(Display* display) {
  KeyCode control = XKeysymToKeycode(display, XK_Control_L);
  KeyCode v = XKeysymToKeycode(display, XK_v);
  XTestFakeKeyEvent(display, control, True, CurrentTime);
  XTestFakeKeyEvent(display, v, True, CurrentTime);
  XTestFakeKeyEvent(display, v, False, CurrentTime);
  XTestFakeKeyEvent(display, control, False, CurrentTime);
  XFlush(display);
}

// The window that was active at capture time, brought back before pasting.
Window source_window = 0;
// Its app id on Wayland, where the compositor keeps the window itself.
gchar* source_app_id = nullptr;

void activate(Display* display, Window window) {
  XEvent event = {};
  event.xclient.type = ClientMessage;
  event.xclient.window = window;
  event.xclient.message_type = XInternAtom(display, "_NET_ACTIVE_WINDOW", False);
  event.xclient.format = 32;
  event.xclient.data.l[0] = 2;  // request comes from a pager-like tool
  event.xclient.data.l[1] = CurrentTime;
  XSendEvent(display, DefaultRootWindow(display), False,
             SubstructureRedirectMask | SubstructureNotifyMask, &event);
  XFlush(display);
}

struct PasteJob {
  FlMethodCall* call;
  gchar* saved;  // user's clipboard text, restored after the paste
  bool terminal;
};

gboolean paste_now(gpointer) {
  send_ctrl_v(GDK_DISPLAY_XDISPLAY(gdk_display_get_default()));
  return G_SOURCE_REMOVE;
}

gboolean restore_clipboard(gpointer user_data) {
  auto* job = static_cast<PasteJob*>(user_data);
  GtkClipboard* clipboard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD);
  if (job->saved) gtk_clipboard_set_text(clipboard, job->saved, -1);
  g_autoptr(FlValue) ok = fl_value_new_bool(TRUE);
  fl_method_call_respond_success(job->call, ok, nullptr);
  g_object_unref(job->call);
  g_free(job->saved);
  delete job;
  return G_SOURCE_REMOVE;
}

void on_remote_paste(const gchar* error_code, const gchar* message, gpointer user_data) {
  auto* job = static_cast<PasteJob*>(user_data);
  if (!error_code) {
    g_timeout_add(400, restore_clipboard, job);
    return;
  }
  fl_method_call_respond_error(job->call, error_code, message, nullptr, nullptr);
  g_object_unref(job->call);
  g_free(job->saved);
  delete job;
}

gboolean type_paste_now(gpointer user_data) {
  auto* job = static_cast<PasteJob*>(user_data);
  if (wayland_type_paste(job->terminal)) {
    g_timeout_add(400, restore_clipboard, job);
    return G_SOURCE_REMOVE;
  }
  remote_desktop_paste(on_remote_paste, job);
  return G_SOURCE_REMOVE;
}

void read_clipboard(GTask* task, gpointer, gpointer, GCancellable*) {
  g_task_return_pointer(task, wayland_read_selection(false), g_free);
}

void on_clipboard_read(GObject*, GAsyncResult* result, gpointer user_data) {
  auto* call = static_cast<FlMethodCall*>(user_data);
  FlValue* args = fl_method_call_get_args(call);
  const gchar* text = fl_value_get_string(fl_value_lookup_string(args, "text"));
  auto* saved = static_cast<gchar*>(g_task_propagate_pointer(G_TASK(result), nullptr));
  auto* job = new PasteJob{call, saved, is_terminal_name(source_app_id)};
  gtk_clipboard_set_text(gtk_clipboard_get(GDK_SELECTION_CLIPBOARD), text, -1);
  // Without a capture the compositor already refocused the window that was
  // in front when the popup hid.
  wayland_activate_captured_toplevel();
  g_timeout_add(120, type_paste_now, job);
}

// The user's clipboard is read on a thread: when GrammarGuard owns it, the
// main loop has to answer the read.
void paste_wayland(FlMethodCall* call) {
  g_autoptr(GTask) task = g_task_new(nullptr, nullptr, on_clipboard_read, g_object_ref(call));
  g_task_run_in_thread(task, read_clipboard);
}

void on_primary_text(GtkClipboard*, const gchar* text, gpointer user_data) {
  auto* call = static_cast<FlMethodCall*>(user_data);
  g_autoptr(FlValue) value = text ? fl_value_new_string(text) : fl_value_new_null();
  fl_method_call_respond_success(call, value, nullptr);
  g_object_unref(call);
}

// Without data-control (GNOME) the primary selection goes only to the
// client with keyboard focus, so the window is presented first and the
// selection read once it is active.
struct FocusWait {
  FlMethodCall* call;
  GtkWindow* window;
  gulong handler;
  guint timeout;
};

void read_primary(FocusWait* wait) {
  g_signal_handler_disconnect(wait->window, wait->handler);
  if (wait->timeout) g_source_remove(wait->timeout);
  gtk_clipboard_request_text(gtk_clipboard_get(GDK_SELECTION_PRIMARY), on_primary_text, wait->call);
  delete wait;
}

void on_active_changed(GtkWindow* window, GParamSpec*, gpointer user_data) {
  if (gtk_window_is_active(window)) read_primary(static_cast<FocusWait*>(user_data));
}

gboolean on_focus_timeout(gpointer user_data) {
  auto* wait = static_cast<FocusWait*>(user_data);
  wait->timeout = 0;
  read_primary(wait);
  return G_SOURCE_REMOVE;
}

void read_selection_when_focused(GtkWindow* window, FlMethodCall* call) {
  auto* wait = new FocusWait{FL_METHOD_CALL(g_object_ref(call)), window, 0, 0};
  wait->handler = g_signal_connect(window, "notify::is-active", G_CALLBACK(on_active_changed), wait);
  if (gtk_window_is_active(window)) {
    read_primary(wait);
    return;
  }
  wait->timeout = g_timeout_add(1000, on_focus_timeout, wait);
  gtk_window_present(window);
}

void read_with_data_control(GTask* task, gpointer, gpointer, GCancellable*) {
  g_task_return_pointer(task, wayland_read_selection(true), g_free);
}

void on_data_control_read(GObject* window, GAsyncResult* result, gpointer user_data) {
  auto* call = static_cast<FlMethodCall*>(user_data);
  g_autofree gchar* text = static_cast<gchar*>(g_task_propagate_pointer(G_TASK(result), nullptr));
  if (!text) {
    read_selection_when_focused(GTK_WINDOW(window), call);
    g_object_unref(call);
    return;
  }
  g_autoptr(FlValue) value = fl_value_new_string(text);
  fl_method_call_respond_success(call, value, nullptr);
  g_object_unref(call);
}

// Data-control reads the selection without focus, before the window shows,
// as on X11. It blocks until the owning app answers, so it runs on a thread.
void read_wayland_selection(GtkWindow* window, FlMethodCall* call) {
  g_autoptr(GTask) task = g_task_new(window, nullptr, on_data_control_read, g_object_ref(call));
  g_task_run_in_thread(task, read_with_data_control);
}

}  // namespace

static void handle(FlMethodChannel*, FlMethodCall* call, gpointer user_data) {
  auto* own = static_cast<GtkWindow*>(user_data);
  GdkDisplay* gdk_display = gdk_display_get_default();
  const gchar* method = fl_method_call_get_name(call);
  if (!GDK_IS_X11_DISPLAY(gdk_display)) {
    if (g_strcmp0(method, "frontmostApp") == 0) {
      ActiveToplevel active;
      if (!wayland_capture_active_toplevel(APPLICATION_ID, &active)) {
        g_clear_pointer(&source_app_id, g_free);
        fl_method_call_respond_success(call, nullptr, nullptr);
        return;
      }
      g_autoptr(FlValue) info = fl_value_new_map();
      fl_value_set_string_take(info, "id", fl_value_new_string(active.app_id));
      fl_value_set_string_take(info, "name", fl_value_new_string(active.app_id));
      // Wayland does not tell clients other apps' process ids.
      fl_value_set_string_take(info, "pid", fl_value_new_int(0));
      fl_value_set_string_take(info, "title", fl_value_new_string(active.title));
      g_free(source_app_id);
      source_app_id = active.app_id;
      g_free(active.title);
      fl_method_call_respond_success(call, info, nullptr);
      return;
    }
    if (g_strcmp0(method, "copySelection") == 0 || g_strcmp0(method, "waylandSelection") == 0) {
      read_wayland_selection(own, call);
      return;
    }
    if (g_strcmp0(method, "pasteInto") == 0) {
      paste_wayland(call);
      return;
    }
    fl_method_call_respond_success(call, nullptr, nullptr);
    return;
  }
  Display* display = GDK_DISPLAY_XDISPLAY(gdk_display);

  if (g_strcmp0(method, "frontmostApp") == 0) {
    Window window = active_window(display);
    GdkWindow* own_window = gtk_widget_get_window(GTK_WIDGET(own));
    if (!window || (own_window && window == GDK_WINDOW_XID(own_window))) {
      fl_method_call_respond_success(call, nullptr, nullptr);
      return;
    }
    XClassHint hint = {};
    XGetClassHint(display, window, &hint);
    g_autofree gchar* title = window_title(display, window);
    g_autoptr(FlValue) info = fl_value_new_map();
    fl_value_set_string_take(info, "id", fl_value_new_string(hint.res_class ? hint.res_class : "unknown"));
    fl_value_set_string_take(info, "name", fl_value_new_string(hint.res_class ? hint.res_class : "Unknown app"));
    fl_value_set_string_take(info, "pid", fl_value_new_int(window_pid(display, window)));
    fl_value_set_string_take(info, "title", title ? fl_value_new_string(title) : fl_value_new_null());
    source_window = window;
    if (hint.res_name) XFree(hint.res_name);
    if (hint.res_class) XFree(hint.res_class);
    fl_method_call_respond_success(call, info, nullptr);
    return;
  }

  if (g_strcmp0(method, "copySelection") == 0) {
    // X11 keeps the current selection in PRIMARY: no key press needed and
    // the user's clipboard is never touched.
    gtk_clipboard_request_text(gtk_clipboard_get(GDK_SELECTION_PRIMARY), on_primary_text,
                               g_object_ref(call));
    return;
  }

  if (g_strcmp0(method, "waylandSelection") == 0) {
    // X11 reads the selection through copySelection, before taking focus.
    fl_method_call_respond_success(call, nullptr, nullptr);
    return;
  }

  if (g_strcmp0(method, "pasteInto") == 0) {
    if (!source_window) {
      // No capture from another window yet, so there is nowhere to paste.
      g_autoptr(FlValue) failed = fl_value_new_bool(FALSE);
      fl_method_call_respond_success(call, failed, nullptr);
      return;
    }
    if (is_terminal(display, source_window)) {
      // Type nothing and leave the clipboard alone: Dart copies the text and
      // shows this message, so the user pastes it with the right keys.
      fl_method_call_respond_error(call, "terminal", "Terminals paste with Ctrl+Shift+V.",
                                   nullptr, nullptr);
      return;
    }
    FlValue* args = fl_method_call_get_args(call);
    const gchar* text = fl_value_get_string(fl_value_lookup_string(args, "text"));
    GtkClipboard* clipboard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD);
    auto* job = new PasteJob{FL_METHOD_CALL(g_object_ref(call)), gtk_clipboard_wait_for_text(clipboard), false};
    gtk_clipboard_set_text(clipboard, text, -1);
    activate(display, source_window);
    g_timeout_add(120, paste_now, nullptr);         // let the focus change land
    g_timeout_add(520, restore_clipboard, job);     // after the target read it
    return;
  }

  fl_method_call_respond_not_implemented(call, nullptr);
}

// Called from my_application.cc after the FlView is created.
void text_bridge_register(FlView* view, GtkWindow* window) {
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlBinaryMessenger* messenger = fl_engine_get_binary_messenger(fl_view_get_engine(view));
  // Never released: the channel lives as long as the app.
  FlMethodChannel* channel = fl_method_channel_new(messenger, "grammar_guard/text_bridge",
                                                   FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, handle, window, nullptr);
}
