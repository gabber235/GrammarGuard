# The development environment: `devenv shell` (or direnv) gives the pinned
# Flutter, every tool the scripts below use, and git hooks that keep commits
# formatted, conventional and free of secrets. `devenv test` runs what CI runs.
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  # The Flutter release pubspec.yaml pins (`environment: flutter:`), the one
  # place the version is set: CI reads the same line (flutter-version-file).
  flutterVersion =
    let
      pinned = builtins.match ".*\n  flutter: \"?([^\"\n ]+)\"? *\n.*" (builtins.readFile ./pubspec.yaml);
    in
    if pinned == null then
      throw "pubspec.yaml needs an exact Flutter version, for example `  flutter: 3.47.8` under environment."
    else
      builtins.head pinned;
  flutter =
    inputs.flutter-overlay.legacyPackages.${pkgs.stdenv.hostPlatform.system}.versions.${flutterVersion}
      or (throw "flutter-overlay has no Flutter ${flutterVersion}; update it with `devenv update flutter-overlay`.");
  # Generated code is formatted with the project, but never by hand.
  dartFiles = ''$(git ls-files 'lib/*.dart' 'test/*.dart' 'integration_test/*.dart' 'eval/*.dart' 'tool/*.dart' | grep -v -e '\.g\.dart$' -e '\.freezed\.dart$')'';
in
{
  packages = [
    flutter
    pkgs.git
    pkgs.gh # pull requests, release checks
    pkgs.libwebp # cwebp and img2webp for `media`
    pkgs.openssl # `signing-cert`
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.cocoapods # the macOS build's plugins
    # flutter_tools copies the engine framework out of the read only store with
    # the rsync on PATH. macOS's own (openrsync) ignores --chmod, so the copy
    # stays read only and lipo cannot thin it (flutter/flutter#195257, fixed
    # in Flutter 3.50).
    # TODO: remove this rsync once pubspec.yaml pins Flutter 3.50 or later,
    # then check that `flutter build macos --debug` still builds in the shell.
    # https://github.com/flutter/flutter/issues/195257
    pkgs.rsync
  ]
  ++ lib.optionals pkgs.stdenv.isLinux [
    # What `flutter build linux` links against, as in CI and the AUR package.
    pkgs.clang
    pkgs.cmake
    pkgs.ninja
    pkgs.pkg-config
    pkgs.gtk3
    pkgs.libsecret
    pkgs.keybinder3
    pkgs.libxtst
    pkgs.libx11
    pkgs.libxi
    pkgs.wayland
    pkgs.libxkbcommon
    pkgs.wayland-scanner
  ];

  # On macOS, Xcode builds everything native: its SDK, compiler and linker.
  # Nix's (from the default stdenv) would win on PATH and in CC, LD and
  # NIX_LDFLAGS, and Xcode's link step fails with them ("ld: unknown options").
  apple.sdk = null;
  stdenv = if pkgs.stdenv.isDarwin then pkgs.stdenvNoCC else pkgs.stdenv;

  # Prebuilt Flutter releases from flutter-overlay's CI.
  cachix.pull = [ "gabber235" ];

  # Tools started outside the flutter command (dart run build_runner, editors)
  # find the SDK through FLUTTER_ROOT. Xcode stays the system's.
  env.FLUTTER_ROOT = "${flutter.sdk}";

  enterShell = ''
    # The Xcode project sets its own minimum macOS; Nix's would override it.
    unset MACOSX_DEPLOYMENT_TARGET
    export PATH="$HOME/.pub-cache/bin:$PATH"
    ${lib.optionalString pkgs.stdenv.isLinux ''
      # Dart build hooks get PATH but not PKG_CONFIG_PATH, and cnativeapi's
      # hook (tray_manager) asks pkg-config for GTK, X11 and Xi. This
      # pkg-config carries the shell's search path with it.
      mkdir -p "$DEVENV_STATE/bin"
      printf '#!${pkgs.runtimeShell}\nPKG_CONFIG_PATH=%q exec %q "$@"\n' "$PKG_CONFIG_PATH" "$(command -v pkg-config)" >"$DEVENV_STATE/bin/pkg-config"
      chmod +x "$DEVENV_STATE/bin/pkg-config"
      export PATH="$DEVENV_STATE/bin:$PATH"
    ''}
    # A fixed path for editors: point the Flutter SDK setting at .devenv/flutter.
    ln -sfn "$FLUTTER_ROOT" "$DEVENV_ROOT/.devenv/flutter"
    if [[ $(uname) == Darwin ]] && ! xcode-select -p >/dev/null 2>&1; then
      echo "Xcode is not set up; macOS builds need it (xcode-select --install, or Xcode from the App Store)." >&2
    fi
    echo "GrammarGuard, Flutter ${flutterVersion}. Commands:"
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: script:
        ''printf '  %-14s %s\n' ${lib.escapeShellArg name} ${lib.escapeShellArg script.description}''
      ) (lib.filterAttrs (_: script: script.description != "") config.scripts)
    )}
  '';

  scripts = {
    gen = {
      description = "Regenerate Freezed, JSON and Riverpod code";
      exec = ''
        cd "$DEVENV_ROOT"
        dart run build_runner build --delete-conflicting-outputs
        # Generators wrap lines their own way; the project's style settles them.
        dart format $(git ls-files '*.g.dart' '*.freezed.dart') >/dev/null
      '';
    };
    fmt = {
      description = "Format the Dart code";
      exec = ''
        cd "$DEVENV_ROOT"
        dart format ${dartFiles}
      '';
    };
    check = {
      description = "What CI runs: generated code, formatting, analysis, every test";
      exec = ''
        set -e
        cd "$DEVENV_ROOT"
        flutter pub get >/dev/null
        # Generated code must match its sources: gen may not change it. A
        # fingerprint, not git diff, so uncommitted work can be checked too.
        generated() { find lib test -name '*.g.dart' -o -name '*.freezed.dart' | sort | xargs shasum | shasum; }
        before=$(generated)
        gen
        if [[ $(generated) != "$before" ]]; then
          echo "Generated code was out of date; gen has updated it. Review and commit the changes." >&2
          git status --short -- '*.g.dart' '*.freezed.dart' >&2
          exit 1
        fi
        dart format --set-exit-if-changed ${dartFiles}
        flutter analyze --no-fatal-infos
        flutter test
      '';
    };
    goldens = {
      description = "Refresh the golden screenshots of every state";
      exec = ''
        cd "$DEVENV_ROOT"
        flutter test test/goldens --update-goldens "$@"
      '';
    };
    media = {
      description = "Every screen and the motion films as WebP in build/media/web";
      exec = ''
        set -e
        cd "$DEVENV_ROOT"
        flutter test test/media --run-skipped
        tool/media.sh encode
      '';
    };
    demo = {
      description = "The app with a fake model: demo [discord|slow|long|error]";
      exec = ''
        cd "$DEVENV_ROOT"
        flutter run -t lib/main_demo.dart --dart-entrypoint-args "''${1:-discord}"
      '';
    };
    shots = {
      description = "Screenshots of the real macOS app into build/screenshots";
      exec = ''
        cd "$DEVENV_ROOT"
        flutter run -d macos --no-resident -t integration_test/tour/screenshot_tour.dart \
          --dart-define=SHOTS_DIR="$DEVENV_ROOT/build/screenshots"
      '';
    };
    it = {
      description = "The real app with only the model faked: it [macos|linux|windows]";
      exec = ''
        cd "$DEVENV_ROOT"
        flutter test integration_test -d "''${1:-macos}"
      '';
    };
    eval-model = {
      description = "Rewrite quality against a real model: eval-model anthropic/claude-haiku-4-5";
      exec = ''
        cd "$DEVENV_ROOT"
        if [[ -z ''${1:-} ]]; then echo "Usage: eval-model <backend/model>; the key comes from EVAL_API_KEY." >&2; exit 1; fi
        EVAL_MODEL="$1" flutter test eval --run-skipped
      '';
    };
    prices = {
      description = "Refresh model names and prices from models.dev";
      exec = ''
        cd "$DEVENV_ROOT"
        dart run tool/update_models.dart
      '';
    };
    package = {
      description = "Release packages of this OS into dist/, as CI makes them";
      exec = ''
        set -e
        cd "$DEVENV_ROOT"
        version=$(sed -n 's/^version: \([0-9.]*\).*/\1/p' pubspec.yaml)
        case $(uname) in
          Darwin) flutter build macos --release && tool/release.sh macos ;;
          Linux) flutter build linux --release && tool/release.sh linux "$version" ;;
          *) echo "Windows packages are built in CI (Inno Setup)." >&2; exit 1 ;;
        esac
      '';
    };
    signing-cert = {
      description = "Create the self-signed release certificate (once, maintainers)";
      exec = ''
        set -e
        dir="$HOME/.config/grammarguard-signing"
        if [[ -f $dir/signing.p12 ]]; then echo "$dir/signing.p12 exists; replacing it resets every user's Accessibility permission." >&2; exit 1; fi
        mkdir -p "$dir" && chmod 700 "$dir" && cd "$dir"
        openssl req -x509 -newkey rsa:2048 -nodes -days 3650 -subj "/CN=GrammarGuard Self Signed" \
          -addext "extendedKeyUsage=codeSigning" -addext "keyUsage=digitalSignature" -keyout signing.key -out signing.crt
        openssl rand -base64 24 | tr -d '\n' > password.txt
        openssl pkcs12 -export -legacy -inkey signing.key -in signing.crt -out signing.p12 -passout file:password.txt
        chmod 600 ./*
        base64 -i signing.p12 | gh secret set MACOS_SELF_SIGNED_P12
        gh secret set MACOS_SELF_SIGNED_PASSWORD < password.txt
        echo "Saved in $dir and as the two GitHub secrets. Keep a copy in your password manager."
      '';
    };
  };

  # Runs before every commit (and in `devenv test`, so CI checks them too).
  git-hooks.hooks = {
    # The pinned Flutter's Dart: nixpkgs' Dart can format differently.
    dart-format = {
      enable = true;
      name = "dart format";
      # The page width (120) comes from analysis_options.yaml, which dart
      # format only reads once packages are fetched; without them it falls
      # back to 80 and rewraps everything (a fresh CI checkout).
      entry = "${pkgs.writeShellScript "dart-format" ''
        [[ -f .dart_tool/package_config.json ]] || ${flutter}/bin/flutter pub get >/dev/null
        exec ${flutter}/bin/dart format --set-exit-if-changed "$@"
      ''}";
      files = "\\.dart$";
      excludes = [
        "\\.g\\.dart$"
        "\\.freezed\\.dart$"
      ];
    };
    # release-please turns commit messages into versions and the changelog.
    convco.enable = true;
    gitleaks.enable = true;
    shellcheck = {
      enable = true;
      # A makepkg template: its variables are read by makepkg, not used here.
      excludes = [ "PKGBUILD$" ];
    };
    actionlint.enable = true;
    nixfmt.enable = true;
    check-yaml.enable = true;
    check-json.enable = true;
    check-merge-conflicts.enable = true;
  };

  enterTest = ''
    check
  '';
}
