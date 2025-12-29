{ config, ... }:
{
  backup.restic.enable = true;

  optional = {
    autoUpgrade = {
      enable = true;
      user = config.users.users.ma-gerbig.name;
      flakeDir = "/home/ma-gerbig/.dotfiles";
    };
    flatpak.enable = true;
    gaming.enable = true;
    libvirt.enable = true;
  };

  services.xserver.enable = true;
}
