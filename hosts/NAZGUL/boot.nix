{ pkgs, ... }:
{
  boot = {
    # Add zfs support
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "zstorage" ];

    initrd = {
      availableKernelModules = [
        "sd_mod"
        "usb_storage"
        "usbhid"
        "ahci"
        "nvme"
        "ehci_pci"
        "xhci_pci"
      ];
      kernelModules = [ "r8169" ];
    };

    kernelModules = [
      "it87"
      "kvm-intel"
      "coretemp"
      "r8169"
    ];

    extraModulePackages = with pkgs.linuxPackages; [ it87 ];

    # Use the latest Linux / ChachyOS kernel, rather than the default LTS
    #kernelPackages = pkgs.linuxPackages_latest;
  };
}
