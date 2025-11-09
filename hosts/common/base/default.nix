{
  hostname,
  lib,
  libx,
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

  programs = {
    fish.enable = true;
  };
}
