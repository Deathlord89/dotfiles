{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disks.nix

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    ../common/hardware/yubikey.nix
  ];

  # Bleeding edge mesa_git
  # chaotic.mesa-git.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
