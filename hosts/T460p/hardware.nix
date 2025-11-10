{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix

    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t460p

    #../common/hardware/nvidia
    #../common/hardware/nvidia/optimus.nix
    ../common/hardware/yubikey.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
