# GrammarGuard from its GitHub release. The release workflow updates
# release.json after each release, so the flake always installs the latest.
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
  wayland,
  libxkbcommon,
  libayatana-appindicator,
}:
let
  release = lib.importJSON ./release.json;
  meta = {
    description = "Rewrite selected text anywhere and review every change";
    homepage = "https://github.com/gabber235/GrammarGuard";
    license = lib.licenses.mit;
    mainProgram = "grammarguard";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  stdenvNoCC.mkDerivation {
    pname = "grammarguard";
    inherit (release) version;
    src = fetchurl { inherit (release.macos) url hash; };
    nativeBuildInputs = [ unzip ];
    sourceRoot = ".";
    # The app is signed; fixups would change files and break the signature,
    # and with it the Accessibility permission.
    dontFixup = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications $out/bin
      cp -R GrammarGuard.app $out/Applications/
      ln -s $out/Applications/GrammarGuard.app/Contents/MacOS/GrammarGuard $out/bin/grammarguard
      runHook postInstall
    '';
    meta = meta // {
      platforms = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    };
  }
else
  stdenv.mkDerivation {
    pname = "grammarguard";
    inherit (release) version;
    src = fetchurl { inherit (release.linux) url hash; };
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
      wayland
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
