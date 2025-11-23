{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = {
    plymouth.enable = lib.mkForce false;

    initrd = {
      availableKernelModules = [ "r8169" ];
      secrets = {
        "/etc/ssh/ssh_host_ed25519_key" = "/etc/ssh/ssh_host_ed25519_key";
      };
      systemd = {
        enable = lib.mkForce true;
        network.networks."enp3s0" = {
          enable = true;
          name = "enp3s0";
          DHCP = "yes";
        };
        services.zfs-remote-unlock = {
          description = "Prepare for ZFS remote unlock";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-networkd.service" ];
          path = with pkgs; [
            zfs
          ];
          serviceConfig.Type = "oneshot";
          script = ''
            echo "systemctl default" >> /var/empty/.profile
          '';
        };
      };
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
          authorizedKeys = config.users.users.ma-gerbig.openssh.authorizedKeys.keys;
        };
      };
    };
  };
}
