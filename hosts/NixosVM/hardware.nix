{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (import ./disks.nix { inherit lib; })

    ../common/hardware/yubikey.nix
  ];

  services = {
    # Enable SPICE guest additions
    spice-vdagentd.enable = true;
    qemuGuest.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
