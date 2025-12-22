{ pkgs, ... }:
{
  boot = {
    supportedFilesystems = [ "btrfs" ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
    };

    kernelModules = [
      "kvm-intel"
    ];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
}
