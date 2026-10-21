# home-manager: `services.grammarguard.enable = true;` installs GrammarGuard
# and starts it with your session, through launchd on macOS and a systemd
# user service on Linux. It comes back after a crash, not after you quit it.
self:
{ config, lib, pkgs, ... }:
let
  cfg = config.services.grammarguard;
  darwin = pkgs.stdenv.hostPlatform.isDarwin;
  program =
    if darwin then
      "${cfg.package}/Applications/GrammarGuard.app/Contents/MacOS/GrammarGuard"
    else
      lib.getExe cfg.package;
in
{
  options.services.grammarguard = {
    enable = lib.mkEnableOption "GrammarGuard, started with your session";
    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      description = "The GrammarGuard package to run.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    { home.packages = [ cfg.package ]; }
    (lib.mkIf darwin {
      launchd.agents.grammarguard = {
        enable = true;
        config = {
          ProgramArguments = [ program ];
          RunAtLoad = true;
          KeepAlive.SuccessfulExit = false;
          ProcessType = "Interactive";
        };
      };
    })
    (lib.mkIf (!darwin) {
      systemd.user.services.grammarguard = {
        Unit = {
          Description = "GrammarGuard";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = program;
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    })
  ]);
}
