{ pkgs, ... }:
{
  boot = {
    supportedFilesystems = [ "btrfs" ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
    };

    kernelModules = [
      "kvm_amd"
      # "vhost_vsock"
    ];

    # Building for Rasoberry Pi
    #binfmt.emulatedSystems = ["aarch64-linux"];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };
}
