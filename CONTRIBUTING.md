# Contributing

Open an issue or a pull request against `main`. Please include tests for behavior changes, and refresh the
goldens (`goldens` in devenv) when the UI changes.

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
| `media` | Render every screen and the films of the app in use as WebP into `build/media/web` |
| `shots` | Screenshot the real macOS app on every screen |
| `it [device]` | Run the real app with only the model faked |
| `eval-model <backend/model>` | Measure rewrite quality against a real model |
| `package` | Build this OS's release packages into `dist/`, as CI does |
| `prices` | Refresh model names and prices from models.dev |

Git hooks run on every commit: Dart formatting with the project's own Dart, conventional commit messages (they
drive the version and changelog), a secrets scan, shellcheck, actionlint, nixfmt, and YAML and JSON checks.
For editors, the pinned Flutter SDK is linked at `.devenv/flutter`.

Each pull request also builds the app for every platform, packaged like a release, to download from the
workflow run.

## Films and screens

The films in the README and on pull requests come from `test/media/media_test.dart`. Each film is a short story
on a stage (`test/media/stage.dart`): a chat app where text is typed, selected and pasted back, the app's window
over it, and the keys being pressed. The app inside is the real app with only the operating system and the
model faked, so the films always show the current version.

To add or change a film, edit its timeline: the acts it plays and when, in milliseconds. `media` renders
everything; open `build/media/web/films` to watch the result.

CI renders the films and screens on every pull request and comments with the films and the screens it changed,
before and after. It keeps them on the `ui-media` branch, which also serves the README's films after every
push to `main`.

## Releases

Releases follow [conventional commits](https://www.conventionalcommits.org): `fix:` makes a patch release,
`feat:` a minor one, and a `!` (or `BREAKING CHANGE:`) a major one.
[release-please](https://github.com/googleapis/release-please) keeps a release pull request open with the next
version and its changelog. Merging it tags the release, and CI builds every platform, attaches the files, and
updates Homebrew, Scoop and the Nix flake. The AUR and winget follow once their accounts are set up (see
[docs/publishing.md](docs/publishing.md)).
