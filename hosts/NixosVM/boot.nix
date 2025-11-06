{
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "sr_mod"
        "virtio_blk"
        "virtio_pci"
        "xhci_pci"
      ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };
}
