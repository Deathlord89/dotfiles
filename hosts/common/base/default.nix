{
  hostname,
  lib,
  libx,
  outputs,
  ...
}:
{
  imports = libx.scanPaths ./. ++ (builtins.attrValues outputs.nixosModules);

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  programs = {
    fish.enable = true;
  };
}
