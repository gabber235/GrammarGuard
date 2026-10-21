# Everyday commands. `just` lists them.

default:
    @just --list

# Regenerate Freezed, json and Riverpod code.
gen:
    dart run build_runner build --delete-conflicting-outputs

# What CI runs: generated code is fresh, formatting, analysis, every test.
check:
    dart run build_runner build --delete-conflicting-outputs
    git diff --exit-code -- '*.g.dart' '*.freezed.dart'
    dart format --set-exit-if-changed $(find lib test integration_test eval tool -name '*.dart' ! -name '*.g.dart' ! -name '*.freezed.dart')
    flutter analyze --no-fatal-infos
    flutter test

# The real app with a fake model and source app: no key, no network.
# Scenarios: discord, slow, long, error.
demo scenario="discord":
    flutter run -t lib/main_demo.dart --dart-entrypoint-args {{scenario}}

# Screenshots of every screen. CI goldens are committed; the platform
# goldens (real fonts) land in test/goldens/goldens/macos for looking at.
goldens:
    flutter test test/goldens --update-goldens

# Frames of every view change (open/close the bar, preview, Settings) into
# build/motion, for judging motion by eye.
motion:
    flutter test test/goldens/motion_test.dart --run-skipped

# Real screenshots of every screen into build/screenshots (macOS only).
# The window pops up for about a minute; leave it in front.
shots:
    flutter run -d macos --no-resident -t integration_test/tour/screenshot_tour.dart --dart-define=SHOTS_DIR={{justfile_directory()}}/build/screenshots

# The real app on this OS with only the model faked.
it device="macos":
    flutter test integration_test -d {{device}}

# Rewrite quality against a real model, for example
# `just eval anthropic/claude-haiku-4-5`. Reads the key from EVAL_API_KEY.
eval model:
    EVAL_MODEL={{model}} flutter test eval --run-skipped

# Refresh model names and prices in assets/models.json from models.dev.
prices:
    dart run tool/update_models.dart

# Run once by the maintainer. Creates the self-signed code signing
# certificate for releases; the output goes into the two GitHub secrets.
# openssl must be OpenSSL 3 or later (Homebrew), since -legacy is needed for
# a p12 that macOS `security import` accepts. It asks for an export password.
make-signing-cert:
    openssl req -x509 -newkey rsa:2048 -nodes -days 3650 \
      -subj "/CN=GrammarGuard Self Signed" \
      -addext "extendedKeyUsage=codeSigning" -addext "keyUsage=digitalSignature" \
      -keyout signing.key -out signing.crt
    openssl pkcs12 -export -legacy -inkey signing.key -in signing.crt -out signing.p12
    base64 -i signing.p12 | pbcopy
    @echo "Copied. Save as MACOS_SELF_SIGNED_P12, the password as MACOS_SELF_SIGNED_PASSWORD."
