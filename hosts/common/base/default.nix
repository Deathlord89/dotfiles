{
  hostname,
  lib,
  libx,
  pkgs,
  ...
}:
{
  imports = libx.scanPaths ./.;

  users.mutableUsers = false;

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    lm_sensors
    pciutils
    usbutils
    wget
  ];

  programs.fish.enable = true;
}
