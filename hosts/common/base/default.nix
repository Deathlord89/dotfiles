{
  hostname,
  lib,
  libx,
  ...
}:
{
  imports = libx.scanPaths ./.;

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  programs = {
    fish.enable = true;
  };
}
