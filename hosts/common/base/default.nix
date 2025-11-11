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
    wget
    lm_sensors
    pciutils
    usbutils
    git
  ];

  programs.fish.enable = true;
}
