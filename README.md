# GrammarGuard

**Select text in any app, press a shortcut, review the rewrite word by word, and paste it back.**

[![Latest release](https://img.shields.io/github/v/release/gabber235/GrammarGuard?color=FFC94D&labelColor=1D2330)](https://github.com/gabber235/GrammarGuard/releases/latest)
![macOS, Windows, Linux](https://img.shields.io/badge/platforms-macOS%20%7C%20Windows%20%7C%20Linux-1D2330)
[![License: MIT](https://img.shields.io/badge/license-MIT-1D2330)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: light)" srcset="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/in_use_light.webp">
  <img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/in_use.webp" alt="A chat message is typed with mistakes and selected. Option Shift G opens GrammarGuard, the rewrite streams in as a diff of the message, n moves to a change, ? explains it, y keeps it, and Enter pastes the corrected message back into the chat." width="100%">
</picture>

GrammarGuard is a desktop app for macOS, Windows and Linux that rewrites text where you write it: a chat, an
email, an issue, a document. It stays out of sight until you press its shortcut. The rewrite shows as changes to
your own words, so you see exactly what it changed, and you decide what to keep before anything is pasted.

It works with the model you choose: a cloud model with your own key, a model on your own computer, or Apple's
on-device model.

<p>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-macos.zip"><img alt="Download for macOS" src="https://img.shields.io/badge/Download-macOS-1D2330?style=for-the-badge&logo=apple&logoColor=white"></a>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-windows-setup.exe"><img alt="Download for Windows" src="https://img.shields.io/badge/Download-Windows-1D2330?style=for-the-badge&logo=windows&logoColor=white"></a>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-linux-x86_64.AppImage"><img alt="Download for Linux" src="https://img.shields.io/badge/Download-Linux-1D2330?style=for-the-badge&logo=linux&logoColor=white"></a>
</p>

Package managers and first launch steps are under [Install](#install).

## What it does

### Review every change

Removed words are struck through next to their replacement. <kbd>n</kbd> and <kbd>p</kbd> move between
changes, <kbd>y</kbd> keeps one, <kbd>x</kbd> undoes it, and <kbd>?</kbd> asks the model why it made it. The
line above the text says what shaped the rewrite: the profile for this app, the defaults, and the model.
<kbd>Enter</kbd> pastes the result back where it came from. The film above shows the whole round.

### Ask for something different

<kbd>Space</kbd> opens the bar. Type what you want, such as "shorter, and upbeat", and <kbd>Enter</kbd> rewrites
the text again with that request. The bar also lists every instruction, profile and model, so the same place
turns on a tone or switches the model. <kbd>Shift</kbd>+<kbd>Enter</kbd> keeps the choice for this app,
<kbd>Cmd</kbd>+<kbd>Enter</kbd> keeps it everywhere.

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/request.webp" alt="In the review, Space opens the bar, the request shorter, and upbeat is typed, and Enter streams a new, shorter rewrite." width="100%">

### Compare two models

<kbd>c</kbd> runs a second model next to the first. <kbd>Left</kbd> or <kbd>Right</kbd> keeps one.

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/compare.webp" alt="c opens the model list, Claude Sonnet is picked, both rewrites show side by side, and Right keeps the second one." width="100%">

### Set it up by asking

Tell the assistant what you want, such as "make my Discord replies friendlier", and it proposes new instructions
and profile changes. Nothing changes until you review the proposal and press <kbd>Enter</kbd>.

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/assistant.webp" alt="A request is typed in the bar and Tab hands it to the assistant, which proposes a new instruction and a changed Discord profile. Enter applies both." width="100%">

### Profiles per app

Discord text gets Discord markdown and a casual tone, email gets short paragraphs and is pasted with formatting,
code stays untouched. A profile matches the app, the window title, the URL, the language, the length, or what
the text contains. <kbd>Cmd</kbd>+<kbd>,</kbd> opens Settings.

<img src="https://github.com/gabber235/GrammarGuard/raw/ui-media/readme/films/settings.webp" alt="Settings opens on Models, then Instructions, then Profiles, where the Discord profile opens to show the instructions it turns on." width="100%">

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

On Windows and Linux, <kbd>Ctrl</kbd> takes the place of <kbd>Cmd</kbd>.

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

Edit the file, use Settings, or ask the assistant. Changes apply at once. Settings lists every change in
History, and the bar can undo the last one.

## Install

Download the app with the buttons at the top, or use a package manager:

| | Command |
|---|---|
| **Homebrew** (macOS) | `brew install gabber235/tap/grammarguard` |
| **Scoop** (Windows) | `scoop bucket add gabber235 https://github.com/gabber235/scoop-bucket` then `scoop install grammarguard` |
| **Debian, Ubuntu** | the [`.deb`](https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-linux-amd64.deb) from the latest release |
| **Arch Linux** | build the package with `makepkg`, see [Arch Linux](#arch-linux) |
| **Nix** | `nix run github:gabber235/GrammarGuard`, or the modules in [Nix](#nix) |

Every release lists all its files and the changes since the last one on the
[releases page](https://github.com/gabber235/GrammarGuard/releases).

### First launch

<details>
<summary><b>macOS</b>: allow it once in Privacy &amp; Security</summary>

GrammarGuard is signed with its own certificate, not notarized by Apple. The first time, open it, then allow it
under System Settings, Privacy & Security ("Open Anyway"). Paste back needs the Accessibility permission
(Privacy & Security, Accessibility). Every release is signed with the same certificate, so both permissions
survive updates. GrammarGuard needs macOS 12 or later.

</details>

<details>
<summary><b>Windows</b>: SmartScreen may warn once</summary>

SmartScreen may warn about an unknown publisher the first time; choose "More info", then "Run anyway". The
installer can start GrammarGuard when you sign in.

</details>

<details>
<summary><b>Linux</b>: X11 and Wayland, with notes per desktop</summary>

The global shortcut works in X11 and Wayland sessions. On Wayland, GrammarGuard asks the desktop for it through
the XDG GlobalShortcuts portal, and the desktop has the final say on the keys; most desktops ask you to confirm
them. Some compositors, such as Hyprland, ignore the suggested keys and need a bind in their own configuration
to the shortcut `grammarguard:open`.

X11 and Wayland both read the selected text and paste the result back. On Wayland, compositors such as Hyprland
and Sway paste directly. GNOME and KDE ask once for permission to type and remember the answer; there,
terminals need <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> by hand, and GNOME leaves the result on the
clipboard instead of restoring it. Where pasting is not possible, the result is copied for
<kbd>Ctrl</kbd>+<kbd>V</kbd>.

Without the portal the app stays a normal window; copy text and press <kbd>Ctrl</kbd>+<kbd>V</kbd> in it. A
keyring service (GNOME Keyring or KWallet) stores the keys.

</details>

### Arch Linux

GrammarGuard is not on the AUR yet, because AUR account registration is closed for now. Once it opens,
`grammarguard-bin` will be published there. Until then, build the same package from this repository; it fills
in the latest release and installs it with pacman:

```sh
git clone https://github.com/gabber235/GrammarGuard && cd GrammarGuard/packaging/aur
v=$(git describe --tags --abbrev=0)
sed -i "s/@VERSION@/${v#v}/; s/@SHA256@/SKIP/" PKGBUILD
makepkg -si
```

### Nix

The flake has the package and modules that install GrammarGuard and start it with your session:

```nix
# flake inputs
grammarguard.url = "github:gabber235/GrammarGuard";

# nix-darwin: installs it and starts it at login
imports = [ grammarguard.darwinModules.default ];
services.grammarguard.enable = true;

# or home-manager, on macOS (launchd) and Linux (systemd user service)
imports = [ grammarguard.homeManagerModules.default ];
services.grammarguard.enable = true;
```

Opening GrammarGuard shows its window, also when it already runs. A login item you add yourself (macOS Login
Items, a Linux autostart entry) can pass `--background` to start hidden until the shortcut, as the Windows
installer and these modules do.

## Contributing

Issues and pull requests are welcome. [CONTRIBUTING.md](CONTRIBUTING.md) covers building from source, the
development commands, and how releases are made.

> [!NOTE]
> **Help wanted: winget.** The first winget version has to be submitted from a Windows machine, and the project
> has none. If you have one and want to help, open an issue; the manifests are in
> [`packaging/winget`](packaging/winget) and the steps in [docs/publishing.md](docs/publishing.md#winget).
> After that first version, every release reaches winget automatically.

## License

[MIT](LICENSE)
