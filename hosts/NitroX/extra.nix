{
  backup.restic.enable = true;

  optional = {
    flatpak.enable = true;
    gaming.enable = true;
    libvirt.enable = true;
  };

  services.xserver.enable = true;
}
