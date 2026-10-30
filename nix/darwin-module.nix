# nix-darwin: `services.grammarguard.enable = true;` installs GrammarGuard and
# starts it at login. launchd brings it back if it crashes, but not after
# you quit it from the menu bar.
self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.grammarguard;
in
{
  options.services.grammarguard = {
    enable = lib.mkEnableOption "GrammarGuard, started at login";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      description = "The GrammarGuard package to run.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    launchd.user.agents.grammarguard.serviceConfig = {
      ProgramArguments = [
        "${cfg.package}/Applications/GrammarGuard.app/Contents/MacOS/GrammarGuard"
        "--background"
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      ProcessType = "Interactive";
    };
  };
}
