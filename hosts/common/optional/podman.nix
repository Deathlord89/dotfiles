{
  config,
  lib,
  ...
}:
let
  cfg = config.optional.podman;
in
{
  options.optional.podman = {
    enable = lib.mkEnableOption "Enable Podman and container auto update";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        # Required for container networking to be able to use names.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    ### Enable Auto-Update
    systemd.services.podman-auto-update = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
    };

    systemd.timers.podman-auto-update = {
      enable = true;
      description = "Periodic Podman container auto-update";
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    networking.firewall.interfaces.podman1 = {
      allowedUDPPorts = [ 53 ]; # this needs to be there so that containers can look eachother's names up over DNS
    };
  };
}
