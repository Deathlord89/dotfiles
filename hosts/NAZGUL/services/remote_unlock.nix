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
      secrets = {
        "/etc/ssh/ssh_host_ed25519_key" = "/etc/ssh/ssh_host_ed25519_key";
      };
      systemd = {
        enable = lib.mkForce true;
        services.zfs-remote-unlock = {
          description = "Prepare for ZFS remote unlock";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-networkd.service" ];
          path = with pkgs; [
            zfs
          ];
          serviceConfig.Type = "oneshot";
          script = ''
            # Import all pools
            zpool import -a
            # Add the load-key command to the .profile
            echo "zfs load-key -a; killall zfs" >> /root/.profile
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
