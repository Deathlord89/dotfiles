{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1d9e4c92-7b02-4809-a370-8a994844a7dd";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/060B-8503";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];
}
