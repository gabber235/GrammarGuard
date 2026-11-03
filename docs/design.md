# Design decisions

Why the product is the way it is, for anyone changing it. Each entry holds the rule, the reasoning, what was
rejected, and what checks it.

A change that overrides an entry updates that entry in the same pull request. Git keeps the old text. Keep this
file under about 150 lines: when it grows, delete what tests or code now hold. Details of one widget belong in its
doc comment, and how a screen looks belongs in the goldens and `media`.

## One window, views swap

**Rule.** Result, bar, assistant, compare, keys and settings are views that replace each other in one window.
Nothing floats over it: no dialogs, sheets, menus or overlays. Forms and confirmations take the page's place or open
in place, like `InlinePicker`.

**Words.** "Popup" in the code (`setPopup`) is this window without a title bar, above other apps. It is never a layer
inside the window.

**Why.** A bar floating over the window and rows of chips read as clutter. One window that changes view reads as one
thing. Default Material dialogs also break the single glass look.

**Rejected.** The bar as a floating layer. An `AlertDialog` for editing an instruction.

**Allowed.** Notes that ask nothing and take no focus: tooltips, snackbars, toasts, the reason under a change. Windows
from the operating system.

**Checked by.** `test/architecture_test.dart`, "nothing floats over the window".

## Everything is an instruction

**Rule.** Every rewrite option is an instruction: a name and prompt text, optionally a key and a group. Profiles turn
instructions on per app. A new option is a new instruction or profile field, not a new setting or enum.

**Why.** Fixed groups of settings would copy what every other tool does. Instructions let one model cover Fix only,
Discord markdown, Casual and Shorter, and whatever a user thinks of next.

**Rejected.** Fixed setting groups for tone, format and edit level.

**Checked by.** Review only.

## Language is not a setting

**Rule.** The model always writes in the language of the text. There is no language setting.

**Why.** A setting would be wrong as soon as the selected text is in another language.

**Checked by.** `test/instructions/compose_test.dart`, "the text is wrapped and the model is told never to follow it".

## Every rewrite is reviewed

**Rule.** A rewrite reaches the other app only after the review. There is no mode that skips it.

**Why.** Reviewing each change is what the product is. Text pasted unseen could say something its author did not mean.

**Rejected.** A skip review mode.

**Checked by.** Review only.

## The assistant only proposes

**Rule.** The assistant's setup edits are proposals. Nothing is saved until the user reviews and applies them, and
every saved change is logged and can be undone.

**Why.** The assistant gets as many tools and as much context as possible. That is safe because the user's setup only
changes when the user says so.

**Checked by.** `test/flows/assistant_flow_test.dart`, "the assistant proposes a profile and nothing is saved until
Enter".

## The rewrite prompt names the app only

**Rule.** The window title is used to match profiles and is never part of a rewrite prompt, which names the app only.
The assistant is the exception: its `current_context` tool reads the title and URL when a request needs them.

**Why.** A window title can hold private names, such as a chat partner's or a document's. A rewrite does not need them,
while the assistant needs them to set up a profile that matches a title or URL.

**Checked by.** `test/instructions/compose_test.dart`, "the destination is the app name, never the window title". The
assistant's access is review only.

## What is applied is a quiet line, not chips

**Rule.** The main view shows what a rewrite uses as one line of text above it, grouped by why each item is on
(`SetupLine`). The bar lists the same things and changes them.

**Why.** A row of chips above the text was not intuitive and cluttered the window, but the main view must still show
what is on.

**Rejected.** A row of chips or tags above the text.

**Checked by.** Review only.
