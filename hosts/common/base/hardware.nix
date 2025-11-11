{ lib, ... }:
{
  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = lib.mkDefault true;
}
