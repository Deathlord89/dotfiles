{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.flatpak;
in
{
  options.optional.flatpak = {
    enable = lib.mkEnableOption "Enable Flatpak Package Manager";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    systemd.services = {
      flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };
      flatpak-automatic-update = {
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak --system uninstall --unused -y --noninteractive ; flatpak --system update -y --noninteractive ; flatpak --system repair
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
    systemd.timers = {
      flatpak-automatic-update = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          RandomizedDelaySec = "10m";
          OnBootSec = "2m";
          OnCalendar = "*-*-* 4:00:00";
          Persistent = true;
        };
      };
    };
  };
}
