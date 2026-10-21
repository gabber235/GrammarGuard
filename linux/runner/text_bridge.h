#ifndef RUNNER_TEXT_BRIDGE_H_
#define RUNNER_TEXT_BRIDGE_H_

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

// Registers the "grammar_guard/text_bridge" method channel on |view|'s
// engine. |window| is GrammarGuard's own window, so frontmostApp can tell it
// apart from other apps.
void text_bridge_register(FlView* view, GtkWindow* window);

#endif  // RUNNER_TEXT_BRIDGE_H_
