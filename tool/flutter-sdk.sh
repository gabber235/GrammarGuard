#!/usr/bin/env bash
# Prints the path of the Flutter SDK this project pins, installing it first
# if needed. The version is `environment: flutter:` in pubspec.yaml, the one
# place it is set: CI reads the same line (flutter-version-file).
#
# SDKs live in ~/.cache/flutter-sdk/<version>, shared by every project, as a
# plain checkout: Flutter from Nix keeps its files read only in the Nix
# store, and the macOS build cannot copy its framework out of it.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
version=$(sed -n 's/^  flutter: *"\{0,1\}\([0-9][0-9.]*\)"\{0,1\} *$/\1/p' "$root/pubspec.yaml")
if [[ -z $version ]]; then
  echo "pubspec.yaml needs an exact Flutter version, for example \`  flutter: 3.47.5\` under environment." >&2
  exit 1
fi

sdk="${XDG_CACHE_HOME:-$HOME/.cache}/flutter-sdk/$version"
if [[ ! -x $sdk/bin/flutter ]]; then
  echo "Installing Flutter $version into $sdk (once, shared by every project)..." >&2
  mkdir -p "$(dirname "$sdk")"
  rm -rf "$sdk.partial"
  git -c advice.detachedHead=false clone --quiet --depth 1 --branch "$version" https://github.com/flutter/flutter.git "$sdk.partial" >&2
  # Downloads Dart and the engine now, so the first real command is quick.
  "$sdk.partial/bin/flutter" --version >/dev/null 2>&1
  mv "$sdk.partial" "$sdk"
fi
echo "$sdk"
