#!/usr/bin/env bash
# Release packaging, run by .github/workflows/release.yml after a release
# build (and usable locally for testing). Everything lands in dist/.
#
#   tool/release.sh macos                  dist/GrammarGuard-macos.zip
#   tool/release.sh linux <version>        dist/GrammarGuard-linux-x64.tar.gz, .deb and .AppImage
#   tool/release.sh windows <version>      dist/GrammarGuard-windows-x64.zip and -setup.exe
#   tool/release.sh fill <template> <version> <sha256> <out>
#                                          a package manifest from packaging/
#   tool/release.sh pins <version>         nix/release.json, packaging/winget and
#                                          packaging/nixpkgs for the release
set -euo pipefail

dist=dist
repo=gabber235/GrammarGuard

macos() {
  mkdir -p "$dist"
  # ditto keeps the code signature and extended attributes intact.
  ditto -c -k --sequesterRsrc --keepParent build/macos/Build/Products/Release/GrammarGuard.app "$dist/GrammarGuard-macos.zip"
}

linux() {
  local version=$1 bundle=build/linux/x64/release/bundle stage
  mkdir -p "$dist"
  stage=$(mktemp -d)

  # The tarball: the Flutter bundle plus what a package needs around it.
  mkdir -p "$stage/grammarguard"
  cp -R "$bundle/." "$stage/grammarguard/"
  cp linux/packaging/grammarguard.desktop linux/packaging/grammarguard.png LICENSE "$stage/grammarguard/"
  tar -C "$stage" -czf "$dist/GrammarGuard-linux-x64.tar.gz" grammarguard

  # The .deb: the bundle in /opt, a command, a menu entry and an icon.
  local deb=$stage/deb
  mkdir -p "$deb/DEBIAN" "$deb/opt/grammarguard" "$deb/usr/bin" "$deb/usr/share/applications" \
    "$deb/usr/share/icons/hicolor/512x512/apps"
  cp -R "$bundle/." "$deb/opt/grammarguard/"
  ln -s /opt/grammarguard/grammarguard "$deb/usr/bin/grammarguard"
  cp linux/packaging/grammarguard.desktop "$deb/usr/share/applications/"
  cp linux/packaging/grammarguard.png "$deb/usr/share/icons/hicolor/512x512/apps/"
  cat >"$deb/DEBIAN/control" <<EOF
Package: grammarguard
Version: $version
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Gabber235 <gabber200@icloud.com>
Depends: libgtk-3-0, libsecret-1-0, libkeybinder-3.0-0, libxtst6, libx11-6, libxi6
Homepage: https://github.com/$repo
Description: Rewrite selected text anywhere and review every change
 Select text in any app, press a shortcut, review the rewrite word by word
 and paste it back.
EOF
  dpkg-deb --root-owner-group --build "$deb" "$dist/GrammarGuard-linux-amd64.deb"

  # The AppImage: the same bundle, run from wherever it is.
  local app=$stage/GrammarGuard.AppDir
  mkdir -p "$app/usr"
  cp -R "$bundle/." "$app/usr/"
  cp linux/packaging/grammarguard.desktop linux/packaging/grammarguard.png "$app/"
  cat >"$app/AppRun" <<'EOF'
#!/bin/sh
here=$(dirname "$(readlink -f "$0")")
exec "$here/usr/grammarguard" "$@"
EOF
  chmod +x "$app/AppRun"
  local tool=$stage/appimagetool
  curl -fsSL -o "$tool" https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
  chmod +x "$tool"
  ARCH=x86_64 APPIMAGE_EXTRACT_AND_RUN=1 "$tool" --no-appstream "$app" "$dist/GrammarGuard-linux-x86_64.AppImage"
  rm -rf "$stage"
}

windows() {
  local version=$1 release=build/windows/x64/runner/Release stage
  mkdir -p "$dist"
  stage=$(mktemp -d)
  mkdir -p "$stage/GrammarGuard"
  cp -R "$release/." "$stage/GrammarGuard/"
  (cd "$stage" && 7z a -tzip -bso0 "$OLDPWD/$dist/GrammarGuard-windows-x64.zip" GrammarGuard)
  rm -rf "$stage"
  "/c/Program Files (x86)/Inno Setup 6/ISCC.exe" -Q "-DAppVersion=$version" windows/packaging/installer.iss
}

fill() {
  local template=$1 version=$2 sha=$3 out=$4
  mkdir -p "$(dirname "$out")"
  sed -e "s/@VERSION@/$version/g" -e "s/@SHA256@/$sha/g" "$template" >"$out"
}

# Files in this repository that name one release: the Nix pin, the winget
# manifests for a first submission by hand, and the nixpkgs draft.
pins() {
  local version=$1
  local base="https://github.com/$repo/releases/download/v$version"
  local mac linux setup
  sri() { echo "sha256-$(curl -fsSL "$1" | openssl dgst -sha256 -binary | base64)"; }
  mac=$(sri "$base/GrammarGuard-macos.zip")
  linux=$(sri "$base/GrammarGuard-linux-x64.tar.gz")
  setup=$(curl -fsSL "$base/GrammarGuard-windows-setup.exe" | openssl dgst -sha256 -r | cut -d' ' -f1 | tr a-f A-F)

  cat >nix/release.json <<EOF
{
  "version": "$version",
  "macos": { "url": "$base/GrammarGuard-macos.zip", "hash": "$mac" },
  "linux": { "url": "$base/GrammarGuard-linux-x64.tar.gz", "hash": "$linux" }
}
EOF

  # perl -i, since GNU and BSD sed disagree on -i.
  V=$version SETUP=$setup DATE=$(gh release view "v$version" --repo "$repo" --json publishedAt -q '.publishedAt[:10]') perl -pi -e '
    s/^PackageVersion: .*/PackageVersion: $ENV{V}/;
    s{/v\d[^/]*/}{/v$ENV{V}/};
    s{/tag/v.*}{/tag/v$ENV{V}};
    s/^ReleaseDate: .*/ReleaseDate: $ENV{DATE}/;
    s/InstallerSha256: .*/InstallerSha256: $ENV{SETUP}/;
  ' packaging/winget/*.yaml

  # Each hash sits on the line after its file's url.
  V=$version MAC=$mac LINUX=$linux perl -pi -e '
    s/version = ".*";/version = "$ENV{V}";/;
    $want = $ENV{MAC} if /GrammarGuard-macos\.zip/;
    $want = $ENV{LINUX} if /GrammarGuard-linux-x64\.tar\.gz/;
    $want = undef if $want && s/hash = ".*"/hash = "$want"/;
  ' packaging/nixpkgs/package.nix
}

case ${1:-} in
  macos) macos ;;
  linux) linux "$2" ;;
  windows) windows "$2" ;;
  fill) fill "$2" "$3" "$4" "$5" ;;
  pins) pins "$2" ;;
  *)
    sed -n '2,13p' "$0"
    exit 1
    ;;
esac
