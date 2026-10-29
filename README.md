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

<p>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-macos.zip"><img alt="Download for macOS" src="https://img.shields.io/badge/Download-macOS-1D2330?style=for-the-badge&logo=apple&logoColor=white"></a>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-windows-setup.exe"><img alt="Download for Windows" src="https://img.shields.io/badge/Download-Windows-1D2330?style=for-the-badge&logo=windows&logoColor=white"></a>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-linux-x86_64.AppImage"><img alt="Download for Linux" src="https://img.shields.io/badge/Download-Linux-1D2330?style=for-the-badge&logo=linux&logoColor=white"></a>
<a href="https://github.com/gabber235/GrammarGuard/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/gabber235/GrammarGuard?style=for-the-badge&color=FFC94D&labelColor=1D2330"></a>
</p>

Or with a package manager:

| | Command |
|---|---|
| **Homebrew** (macOS) | `brew install gabber235/tap/grammarguard` |
| **Scoop** (Windows) | `scoop bucket add gabber235 https://github.com/gabber235/scoop-bucket` then `scoop install grammarguard` |
| **Arch Linux** | build the package with `makepkg`, [below](#arch-linux) |
| **Debian, Ubuntu** | the [`.deb`](https://github.com/gabber235/GrammarGuard/releases/latest/download/GrammarGuard-linux-amd64.deb) from the latest release |
| **Nix** | `nix run github:gabber235/GrammarGuard`, or the modules below |

Every release lists all files, with the changes since the last one, on the [releases page](https://github.com/gabber235/GrammarGuard/releases).

> [!NOTE]
> **Help wanted: winget.** The first winget version has to be submitted from a Windows machine, and the project
> has none. If you have one and want to help, open an issue; the manifests are in
> [`packaging/winget`](packaging/winget) and the steps in [docs/publishing.md](docs/publishing.md#winget).
> After that first version, every release reaches winget automatically.

### Arch Linux

> [!NOTE]
> **Not on the AUR yet.** AUR account registration is blocked right now, so `grammarguard-bin` cannot be
> published. Once registration opens again it will be, and `yay -S grammarguard-bin` will work.

Until then, build the same package from this repository; it fills in the latest release and installs it with
pacman:

```sh
git clone https://github.com/gabber235/GrammarGuard && cd GrammarGuard/packaging/aur
v=$(git describe --tags --abbrev=0)
sed -i "s/@VERSION@/${v#v}/; s/@SHA256@/SKIP/" PKGBUILD
makepkg -si
```

### First launch

* **macOS:** GrammarGuard is signed with its own certificate, not notarized by Apple. The first time, open it,
  then allow it under System Settings, Privacy & Security ("Open Anyway"). Paste back needs the Accessibility
  permission (Privacy & Security, Accessibility). Every release is signed with the same certificate, so both
  permissions survive updates.
* **Windows:** SmartScreen may warn about an unknown publisher the first time; choose "More info", then "Run
  anyway". The installer can start GrammarGuard when you sign in.
* **Linux:** the global shortcut works in X11 and Wayland sessions. On Wayland GrammarGuard asks the desktop for it
  through the XDG GlobalShortcuts portal, and the desktop has the final say on the keys; most desktops ask you to
  confirm them. Some compositors, such as Hyprland, ignore the suggested keys and need a bind in their own
  configuration to the shortcut `grammarguard:open`. X11 and Wayland both read the selected text and paste the
  result back. On Wayland, compositors such as Hyprland and Sway paste directly; GNOME and KDE ask once for
  permission to type and remember the answer; there, terminals need <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd>
  by hand, and GNOME leaves the result on the clipboard instead of restoring it. Where pasting is not possible, the
  result is copied for <kbd>Ctrl</kbd>+<kbd>V</kbd>. Without the portal the app stays a normal window; copy text
  and press <kbd>Ctrl</kbd>+<kbd>V</kbd> in it. A keyring service (GNOME Keyring or KWallet) stores the keys.

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

## Building from source

The quickest way is [devenv](https://devenv.sh): `devenv shell` installs the exact Flutter version this project
pins (`environment: flutter:` in `pubspec.yaml`, the same one CI uses) and every other tool, then
`flutter run`. Without devenv, install that Flutter version yourself and run `flutter pub get`.

* **macOS:** Xcode, then `flutter run -d macos`
* **Linux:** inside devenv, `flutter run -d linux`. Without it, install GTK 3, `libsecret-1-dev`,
  `libkeybinder-3.0-dev`, `libxtst-dev`, `libx11-dev` and `libxi-dev` first.
* **Windows:** Visual Studio with the Desktop development with C++ workload and the C++ ATL libraries, then
  `flutter run -d windows`

## Development

`devenv shell` lists these commands when it starts:

| Command | What it does |
|---|---|
| `check` | What CI runs: generated code, formatting, analysis and every test (`devenv test` adds the git hooks) |
| `gen` | Regenerate Riverpod, Freezed and JSON code |
| `fmt` | Format the Dart code |
| `demo [scenario]` | Run the app with a fake model and a scripted scenario |
| `goldens` | Refresh the golden screenshots of every state |
| `media` | Render every screen and the motion films as WebP into `build/media/web` |
| `shots` | Screenshot the real macOS app on every screen |
| `it [device]` | Run the real app with only the model faked |
| `eval-model <backend/model>` | Measure rewrite quality against a real model |
| `package` | Build this OS's release packages into `dist/`, as CI does |
| `prices` | Refresh model names and prices from models.dev |

Git hooks run on every commit: Dart formatting with the project's own Dart, conventional commit messages (they
drive the version and changelog), a secrets scan, shellcheck, actionlint, nixfmt, and YAML and JSON checks.
For editors, the pinned Flutter SDK is linked at `.devenv/flutter`.

Every pull request gets a comment with the screens it changed, before and after, plus the motion films. CI
renders them and keeps them on the `ui-media` branch, which also serves the images on this page. Each pull
request also builds the app for every platform, packaged like a release, to download from the workflow run.

### Releases

Releases follow [conventional commits](https://www.conventionalcommits.org): `fix:` makes a patch release,
`feat:` a minor one, and a `!` (or `BREAKING CHANGE:`) a major one. [release-please](https://github.com/googleapis/release-please)
keeps a release pull request open with the next version and its changelog. Merging it tags the release, and CI
builds every platform, attaches the files, and updates Homebrew, Scoop and the Nix flake. The AUR and winget
follow once their accounts are set up (see [docs/publishing.md](docs/publishing.md)).

## Contributing

Open an issue or a pull request against `main`. Please include tests for behavior changes, and refresh the
goldens (`goldens` in devenv) when the UI changes.
