# Draft for nixpkgs: pkgs/by-name/gr/grammarguard/package.nix.
# The released, signed binaries. On Linux, reviewers may ask for a source
# build with buildFlutterApplication instead (it needs pubspec.lock.json and
# hashes for the git dependencies); macOS has to stay binary, since Flutter's
# macOS build needs Xcode.
{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  unzip,
  autoPatchelfHook,
  wrapGAppsHook3,
  gtk3,
  libsecret,
  keybinder3,
  libxtst,
  libx11,
  libxi,
  libxkbcommon,
  libayatana-appindicator,
}:
let
  pname = "grammarguard";
  version = "1.1.1";
  base = "https://github.com/gabber235/GrammarGuard/releases/download/v${version}";
  meta = {
    description = "Rewrite selected text anywhere and review every change";
    homepage = "https://github.com/gabber235/GrammarGuard";
    changelog = "https://github.com/gabber235/GrammarGuard/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ]; # add yourself
    mainProgram = "grammarguard";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    inherit pname version;
    src = fetchurl {
      url = "${base}/GrammarGuard-macos.zip";
      hash = "sha256-2N6ha7yq+rrUILxMFjSiZeFIAvwhyj5j1La+LinYw+s=";
    };
    nativeBuildInputs = [ unzip ];
    sourceRoot = ".";
    # Fixups would break the code signature, and with it the Accessibility
    # permission.
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications $out/bin
      cp -R GrammarGuard.app $out/Applications/
      ln -s $out/Applications/GrammarGuard.app/Contents/MacOS/GrammarGuard $out/bin/grammarguard
      runHook postInstall
    '';
    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  }
else
  stdenv.mkDerivation {
    inherit pname version;
    src = fetchurl {
      url = "${base}/GrammarGuard-linux-x64.tar.gz";
      hash = "sha256-iZntN04+HJI+qJY7SVlxD/M41c0wvy82LEbFg/AkTNg=";
    };
    nativeBuildInputs = [
      autoPatchelfHook
      wrapGAppsHook3
    ];
    buildInputs = [
      gtk3
      libsecret
      keybinder3
      libxtst
      libx11
      libxi
      libxkbcommon
      # The pinned release still links it; drop once a release without it is out.
      libayatana-appindicator
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/opt $out/bin
      cp -R . $out/opt/grammarguard
      ln -s $out/opt/grammarguard/grammarguard $out/bin/grammarguard
      install -Dm644 grammarguard.desktop $out/share/applications/grammarguard.desktop
      install -Dm644 grammarguard.png $out/share/icons/hicolor/512x512/apps/grammarguard.png
      runHook postInstall
    '';
    meta = meta // {
      platforms = [ "x86_64-linux" ];
    };
  }
