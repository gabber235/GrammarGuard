// Every key of the main window, in one table. The key bindings, the footer,
// the Keys view, the bar's rows and the tips all read it, so what is shown
// cannot drift from what works.
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

/// How the table groups commands in the Keys view.
enum CommandGroup {
  review("Review"),
  rewrite("Change the rewrite"),
  view("View"),
  window("Window");

  const CommandGroup(this.label);

  final String label;
}

/// What must exist for a command to do anything, so the Keys view lists only
/// what works right now.
enum CommandNeed { nothing, text, result }

/// Keys pressed together, as drawn on screen: [primaryModifier] stands for
/// Cmd on macOS and Ctrl elsewhere.
List<String> keyLabels(List<String> keys) => keys.map((key) => key == primaryModifier ? primaryKey : key).toList();

const primaryModifier = "Cmd";

/// The modifier shortcuts are drawn with: Cmd on macOS, Ctrl elsewhere.
/// Both work everywhere; this is only the label.
String get primaryKey => defaultTargetPlatform == TargetPlatform.macOS ? "Cmd" : "Ctrl";

/// One thing the main window can do. Each command has at most one key
/// combination, so two keys side by side always mean "press them together".
enum AppCommand {
  next(
    CommandGroup.review,
    "Next change",
    short: "next",
    keys: ["n"],
    activators: [SingleActivator(LogicalKeyboardKey.keyN)],
    need: CommandNeed.result,
  ),
  previous(
    CommandGroup.review,
    "Previous change",
    short: "previous",
    keys: ["p"],
    activators: [SingleActivator(LogicalKeyboardKey.keyP)],
    need: CommandNeed.result,
  ),
  accept(
    CommandGroup.review,
    "Accept the change",
    short: "accept",
    keys: ["y"],
    activators: [SingleActivator(LogicalKeyboardKey.keyY)],
    need: CommandNeed.result,
  ),
  reject(
    CommandGroup.review,
    "Reject the change",
    short: "reject",
    keys: ["x"],
    activators: [SingleActivator(LogicalKeyboardKey.keyX)],
    need: CommandNeed.result,
  ),
  undoDecision(
    CommandGroup.review,
    "Undo the last decision",
    keys: ["u"],
    activators: [SingleActivator(LogicalKeyboardKey.keyU)],
    need: CommandNeed.result,
    tip: "undoes your last decision",
  ),
  why(
    CommandGroup.review,
    "Why this change",
    keys: ["w"],
    activators: [SingleActivator(LogicalKeyboardKey.keyW)],
    need: CommandNeed.result,
    tip: "explains this change",
  ),
  paste(
    CommandGroup.review,
    "Paste back",
    short: "paste back",
    keys: ["Enter"],
    activators: [SingleActivator(LogicalKeyboardKey.enter)],
    need: CommandNeed.result,
    inBar: false,
  ),

  openBar(
    CommandGroup.rewrite,
    "Search everything",
    keys: ["Space"],
    activators: [SingleActivator(LogicalKeyboardKey.space)],
    tip: "searches everything",
    inBar: false,
  ),
  changeModel(
    CommandGroup.rewrite,
    "Change the model",
    short: "change model",
    keys: ["m"],
    activators: [SingleActivator(LogicalKeyboardKey.keyM)],
    tip: "changes the model",
  ),
  less(
    CommandGroup.rewrite,
    "Change less",
    keys: ["["],
    activators: [SingleActivator(LogicalKeyboardKey.bracketLeft)],
    need: CommandNeed.text,
    tip: "changes less of your text",
  ),
  more(
    CommandGroup.rewrite,
    "Change more",
    keys: ["]"],
    activators: [SingleActivator(LogicalKeyboardKey.bracketRight)],
    need: CommandNeed.text,
    tip: "changes more of your text",
  ),
  compare(
    CommandGroup.rewrite,
    "Compare with another model",
    keys: ["c"],
    activators: [SingleActivator(LogicalKeyboardKey.keyC)],
    need: CommandNeed.text,
    tip: "compares two models",
  ),
  retry(
    CommandGroup.rewrite,
    "Try again",
    short: "try again",
    keys: ["r"],
    activators: [SingleActivator(LogicalKeyboardKey.keyR)],
    need: CommandNeed.text,
    tip: "tries again",
  ),
  saveForApp(
    CommandGroup.rewrite,
    "Keep what you picked for this app",
    keys: ["s"],
    activators: [SingleActivator(LogicalKeyboardKey.keyS)],
    need: CommandNeed.text,
    tip: "keeps your picks for this app",
  ),
  ask(
    CommandGroup.rewrite,
    "Ask the assistant",
    keys: [primaryModifier, "?"],
    activators: [
      SingleActivator(LogicalKeyboardKey.slash, shift: true, meta: true),
      SingleActivator(LogicalKeyboardKey.slash, shift: true, control: true),
    ],
    inBar: false,
  ),

  sideBySide(
    CommandGroup.view,
    "Side by side",
    keys: ["h"],
    activators: [SingleActivator(LogicalKeyboardKey.keyH)],
    need: CommandNeed.result,
    tip: "shows both texts side by side",
  ),
  preview(
    CommandGroup.view,
    "Preview the final text",
    keys: ["v"],
    activators: [SingleActivator(LogicalKeyboardKey.keyV)],
    need: CommandNeed.result,
    tip: "previews the final text",
  ),
  editor(
    CommandGroup.view,
    "Edit in the Vim editor",
    keys: ["Tab"],
    activators: [SingleActivator(LogicalKeyboardKey.tab)],
    need: CommandNeed.result,
    tip: "edits the text yourself",
  ),
  scrollDown(
    CommandGroup.view,
    "Scroll down",
    keys: ["j"],
    activators: [SingleActivator(LogicalKeyboardKey.keyJ)],
    need: CommandNeed.result,
    inBar: false,
  ),
  scrollUp(
    CommandGroup.view,
    "Scroll up",
    keys: ["k"],
    activators: [SingleActivator(LogicalKeyboardKey.keyK)],
    need: CommandNeed.result,
    inBar: false,
  ),
  pageDown(
    CommandGroup.view,
    "Scroll half a page",
    keys: ["d"],
    activators: [SingleActivator(LogicalKeyboardKey.keyD)],
    need: CommandNeed.result,
    inBar: false,
  ),

  allKeys(
    CommandGroup.window,
    "All keys",
    short: "all keys",
    keys: ["?"],
    activators: [SingleActivator(LogicalKeyboardKey.slash, shift: true)],
  ),
  clipboard(
    CommandGroup.window,
    "Rewrite what is on the clipboard",
    keys: [primaryModifier, "V"],
    activators: [
      SingleActivator(LogicalKeyboardKey.keyV, meta: true),
      SingleActivator(LogicalKeyboardKey.keyV, control: true),
    ],
  ),
  settings(
    CommandGroup.window,
    "Settings",
    keys: [primaryModifier, ","],
    activators: [
      SingleActivator(LogicalKeyboardKey.comma, meta: true),
      SingleActivator(LogicalKeyboardKey.comma, control: true),
    ],
    whileTyping: true,
  ),
  back(
    CommandGroup.window,
    "Back, stop, or hide",
    short: "back",
    keys: ["Esc"],
    activators: [SingleActivator(LogicalKeyboardKey.escape)],
    inBar: false,
    whileTyping: true,
  ),

  // Only in the bar: no key of their own.
  history(CommandGroup.window, "History and setup changes"),
  undoSetupChange(CommandGroup.window, "Undo the last setup change");

  const AppCommand(
    this.group,
    this.title, {
    this.short,
    this.keys = const [],
    this.activators = const [],
    this.need = CommandNeed.nothing,
    this.tip,
    this.inBar = true,
    this.whileTyping = false,
  });

  final CommandGroup group;

  /// The full name: the Keys view's row and the bar's row.
  final String title;

  /// The footer's word for it, when the title is too long there.
  final String? short;

  /// Pressed together. Empty for commands only the bar offers.
  final List<String> keys;
  final List<ShortcutActivator> activators;
  final CommandNeed need;

  /// Finishes "Tip: press this key, it ...", for keys the footer leaves out.
  final String? tip;

  /// Whether the bar offers it. Not the bar itself, or what means nothing
  /// once it closed.
  final bool inBar;

  /// Works while a text field has the keys (the bar, the assistant).
  final bool whileTyping;

  List<String> get labels => keyLabels(keys);

  String get hint => short ?? title;
}

/// A key of a view with its own small set: the bar, comparing, the assistant,
/// the Vim editor. Those views act on their keys themselves; this is what
/// they show.
class KeyEntry {
  const KeyEntry(this.keys, this.what);

  final List<String> keys;
  final String what;

  List<String> get labels => keyLabels(keys);
}

const barKeys = [
  KeyEntry(["Enter"], "for now"),
  KeyEntry(["Shift", "Enter"], "for this app"),
  KeyEntry([primaryModifier, "Enter"], "always"),
  KeyEntry(["Tab"], "ask"),
  KeyEntry(["Esc"], "back"),
];
const compareBarKeys = [
  KeyEntry(["Enter"], "compare"),
  KeyEntry(["Esc"], "back"),
];
const compareKeys = [
  KeyEntry(["Left"], "use left"),
  KeyEntry(["Right"], "use right"),
  KeyEntry(["Esc"], "back"),
];
const assistantKeys = [
  KeyEntry(["Enter"], "send"),
  KeyEntry(["Esc"], "back to the text"),
];
const proposalKeys = [
  KeyEntry(["n"], "next"),
  KeyEntry(["p"], "previous"),
  KeyEntry(["y"], "accept"),
  KeyEntry(["x"], "reject"),
  KeyEntry(["Enter"], "apply"),
  KeyEntry(["Tab"], "reply"),
];
const editorKeys = [
  KeyEntry([primaryModifier, "Y"], "accept"),
  KeyEntry([primaryModifier, "N"], "reject"),
  KeyEntry([primaryModifier, "Shift", "Y"], "accept all"),
  KeyEntry([primaryModifier, "Shift", "N"], "reject all"),
  KeyEntry([primaryModifier, "Z"], "undo"),
  KeyEntry(["Enter"], "paste back"),
  KeyEntry(["Esc"], "back"),
];

/// The other views, for the full list in Settings.
const otherKeyGroups = <(String, List<KeyEntry>)>[
  ("In the bar", barKeys),
  ("Comparing two models", compareKeys),
  ("The assistant", assistantKeys),
  ("The assistant's proposal", proposalKeys),
  ("The Vim editor", editorKeys),
];
