# GrammarGuard

**Select text anywhere, press a shortcut, review the rewrite word by word, and paste it back.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/in_use.webp" alt="GrammarGuard in use: the hotkey, the rewrite streaming in as a diff, reviewing changes, and the bar" width="100%">

GrammarGuard is a desktop app for macOS, Linux and Windows. It waits in the background until you press its
shortcut over selected text. The rewrite streams in as a diff of your own words, you keep or undo each change,
and Enter pastes the result back where it came from.

The images on this page are rendered from the app on every change to `main`, so they always show the current
version.

## What it does

<table>
<tr>
<td width="50%"><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/review.webp" alt="The review"></td>
<td width="50%"><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/bar.webp" alt="The bar"></td>
</tr>
<tr>
<td><b>Review every change.</b> Removed words are struck through next to their replacement. <kbd>n</kbd> and <kbd>p</kbd> move between changes, <kbd>y</kbd> keeps one, <kbd>x</kbd> undoes it, <kbd>?</kbd> asks the model why. The line above the text says what shaped the rewrite and why.</td>
<td><b>One place to type.</b> <kbd>Space</kbd> opens the bar: what is on for this text, every instruction, profile and model, and free text as a request. <kbd>Enter</kbd> applies it now, <kbd>Shift</kbd>+<kbd>Enter</kbd> for this app, <kbd>Cmd</kbd>+<kbd>Enter</kbd> always.</td>
</tr>
<tr>
<td><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/assistant_proposal.webp" alt="The assistant"></td>
<td><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/compare.webp" alt="Two models compared"></td>
</tr>
<tr>
<td><b>An assistant for your setup.</b> Ask for "friendlier Discord replies" and it proposes instructions and profiles, tested on your own text. Nothing changes until you review the proposal and press <kbd>Enter</kbd>.</td>
<td><b>Compare two models.</b> <kbd>c</kbd> runs a second model next to the first; <kbd>Left</kbd> or <kbd>Right</kbd> keeps one.</td>
</tr>
<tr>
<td><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/settings_profiles.webp" alt="Profiles in Settings"></td>
<td><img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/screens/review_light.webp" alt="The light theme"></td>
</tr>
<tr>
<td><b>Profiles per app.</b> Discord text gets Discord markdown and a casual tone, email gets short paragraphs and is pasted with formatting, code stays untouched. Profiles match the app, window title, URL, language, length or content.</td>
<td><b>Light and dark</b>, following the system, on frosted glass.</td>
</tr>
</table>

<details>
<summary>Motion</summary>

Opening the bar, going back, the preview and Settings:

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/open_bar.webp" alt="Opening the bar" width="49%"> <img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/close_bar.webp" alt="Back to the text" width="49%">
<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/preview.webp" alt="The preview" width="49%"> <img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/open_settings.webp" alt="Opening Settings" width="49%">

</details>

## Keys

| Key | What it does |
|---|---|
| <kbd>Option</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd> (<kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd>) | Rewrite the selected text. Change it in Settings. |
| <kbd>Cmd</kbd>+<kbd>V</kbd> (<kbd>Ctrl</kbd>+<kbd>V</kbd>) in the window | Rewrite what is on the clipboard |
| <kbd>n</kbd> <kbd>p</kbd> | Next and previous change |
| <kbd>y</kbd> <kbd>x</kbd> <kbd>u</kbd> | Keep, undo, undo the last decision |
| <kbd>?</kbd> | Why this change |
| <kbd>Enter</kbd> | Paste back |
| <kbd>Space</kbd>, <kbd>m</kbd> | The bar; the bar on models |
| <kbd>1</kbd> to <kbd>9</kbd> | Turn a pinned instruction on or off |
| <kbd>[</kbd> <kbd>]</kbd> | Change less or more (Fix only, Polish, Enhance, Rewrite) |
| <kbd>c</kbd> | Compare with another model |
| <kbd>s</kbd> | Keep what you picked for this app |
| <kbd>r</kbd> | Try again |
| <kbd>h</kbd> <kbd>v</kbd> | Side by side; preview the final text |
| <kbd>Tab</kbd> | Edit in the Vim editor |
| <kbd>Cmd</kbd>+<kbd>,</kbd> | Settings |
| <kbd>Esc</kbd> | Back, stop, or hide |

## Models

Bring a key for Anthropic, OpenAI, Google Gemini, DeepSeek, xAI, Groq, Phind or OpenRouter, or run models
yourself with Ollama or any OpenAI compatible server (LM Studio, llama.cpp). On a Mac with Apple Intelligence,
the on-device model works without a key. Keys are kept in the system keychain. The footer shows what each
rewrite cost.

## Your setup

Everything GrammarGuard does comes from one file, `library.yaml`, in the app's support folder. It starts as a
copy of [the built-in setup](assets/library.yaml):

* **Instructions** are a name and a sentence or two for the model, such as "Use a relaxed, friendly tone."
  Groups keep choices exclusive, so only one tone is on at a time.
* **Profiles** turn instructions on for some text: an app, a window title, a URL, a language, a length, or what
  the text contains.
* **Defaults** apply everywhere.

Edit the file, use Settings, or ask the assistant. Changes apply at once; Settings lists every change in History, and the bar can undo the last one.

## Install

Download a build from [Releases](https://github.com/gabber235/GrammarGuard/releases).

* **macOS:** paste back needs the Accessibility permission (System Settings, Privacy & Security,
  Accessibility). Releases are signed with the same certificate every time, so the permission survives updates.
* **Linux:** the global shortcut works in X11 sessions. On Wayland the app stays a normal window; copy text and
  press <kbd>Ctrl</kbd>+<kbd>V</kbd> in it. A keyring service (GNOME Keyring or KWallet) stores the keys.
* **Windows:** works as is.

## Building from source

Install Flutter 3.47 or newer, then run `flutter pub get`.

* **macOS:** `flutter run -d macos`
* **Linux:** install GTK 3, `libsecret-1-dev`, `libkeybinder-3.0-dev`, `libxtst-dev` and
  `libayatana-appindicator3-dev`, then `flutter run -d linux`
* **Windows:** Visual Studio with the Desktop development with C++ workload and the C++ ATL libraries, then
  `flutter run -d windows`

## Development

Common tasks are [just](https://github.com/casey/just) recipes:

| Recipe | What it does |
|---|---|
| `just gen` | Regenerate Riverpod and Freezed code |
| `just check` | Format, analyze and test |
| `just demo` | Run the app with a fake model and a scripted scenario |
| `just goldens` | Refresh the golden screenshots of every state |
| `just media` | Render every screen and the motion films as WebP into `build/media/web` |
| `just shots` | Screenshot the real macOS app on every screen |
| `just it` | Run the real app with only the model faked |
| `just eval <backend/model>` | Measure rewrite quality against a real model |

Every pull request gets a comment with the screens it changed, before and after, plus the motion films. CI
renders them and keeps them on the `ui-media` branch, which also serves the images on this page.

## Contributing

Open an issue or a pull request against `main`. Please include tests for behavior changes, and refresh the
goldens (`just goldens`) when the UI changes.
