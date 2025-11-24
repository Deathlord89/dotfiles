{
  services = {
    zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };
    nfs.server.enable = true;
    # Enable automatic shutdown when APC UPS has low battery power
    apcupsd.enable = true;
  };

  # HostID needed for zfs
  networking = {
    hostId = "205ed76c";
  };

  #Open Ports for zfs shares
  networking.firewall.allowedTCPPorts = [ 2049 ];

  # Preserve space by sacrificing documentation
  documentation = {
    nixos.enable = false;
  };
}
