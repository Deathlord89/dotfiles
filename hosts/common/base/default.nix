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

  environment.systemPackages = [ pkgs.git ];

  programs.fish.enable = true;

}
