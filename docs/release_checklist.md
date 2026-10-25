# Release checklist

Paste back talks to real apps through native code that no CI runner can
drive. Before each release, run through this on every OS the release
ships for. A row passes when the expected result happens and the clipboard
still holds what was on it before.

## Setup

1. Install the release build (not a debug run).
2. Copy a marker text, for example `clipboard before`.
3. For each app below: type a sentence with a typo, select it, press the
   hotkey, wait for the result, press Enter.

## Apps

| App | Expected on macOS | Expected on Windows | Expected on Linux (X11) |
|---|---|---|---|
| Discord | Replaced, Discord markdown | Replaced | Replaced |
| Slack | Replaced, Slack formatting | Replaced | Replaced |
| Mail (Outlook on Windows, Thunderbird on Linux) | Replaced as rich text | Replaced as rich text | Replaced |
| Word (LibreOffice Writer on Linux) | Replaced as rich text | Replaced as rich text | Replaced |
| A browser text field (Chrome or Firefox) | Replaced | Replaced | Replaced |
| A terminal | Replaced | Replaced | Not typed; toast says "Copied. Terminals paste with Ctrl+Shift+V." and the result is on the clipboard |

After every row: paste somewhere else and check it still gives
`clipboard before`.

## Permissions and updates (macOS)

- Fresh install without Accessibility: the hotkey uses the clipboard and
  Enter shows "Copied. Allow GrammarGuard in System Settings, Privacy and
  Security, Accessibility."
- After granting it: the selection is read and replaced.
- Install the new release over the previous one: the Accessibility grant
  and the saved API keys are still there (the self signed certificate must
  be the same).

## Wayland

- The shortcut registers through the GlobalShortcuts portal: the desktop
  asks to confirm it, or (Hyprland and similar) a bind to
  `grammarguard:open` in the compositor configuration takes effect.
- The shortcut takes the selected text, with the mouse anywhere, and
  falls back to the clipboard when nothing is selected. Enter pastes the
  result back; pressing the shortcut again closes the window.
- The result pastes into a text field and into a terminal. On GNOME and
  KDE a terminal needs Ctrl+Shift+V by hand.
- On compositors with data control (Hyprland, Sway, KDE) the clipboard is
  restored after the paste.
- On GNOME and KDE the permission dialog to type appears once and is
  remembered after a restart.
- On GNOME and KDE no remote control indicator stays after a paste.
- Without the GlobalShortcuts portal the window opens at launch instead.
- Cmd or Ctrl+V in the window takes the clipboard; Enter copies the result.
