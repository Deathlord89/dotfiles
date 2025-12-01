{
  config,
  inputs,
  lib,
  ...
}:
{
  multimedia.youtubeDownloader = {
    enable = true;
    inherit (config.services.jellyfin) user;
    inherit (config.services.jellyfin) group;
    outputDir = "/var/media/videos/YouTube";
    inherit (inputs.nix-secrets.youtubeDownloader) channels;
    inherit (inputs.nix-secrets.youtubeDownloader) playlists;
    inherit (inputs.nix-secrets.youtubeDownloader) uniques;
  };

  optional.autoUpgrade = {
    enable = true;
    user = config.users.users.ma-gerbig.name;
    flakeDir = "${config.users.users.ma-gerbig.home}/.dotfiles";
    onCalendar = "*:0/15";
    upgrade = true;
    persistent = false;
  };

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

  # Disable ZramSwap for better zfs memory management
  zramSwap.enable = lib.mkForce false;

  #Open Ports for zfs shares
  networking.firewall.allowedTCPPorts = [ 2049 ];

  # Preserve space by sacrificing documentation
  documentation = {
    nixos.enable = false;
  };
}
