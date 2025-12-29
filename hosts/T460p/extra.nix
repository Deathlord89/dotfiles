{ config, ... }:
{
  optional = {
    autoUpgrade = {
      enable = true;
      user = config.users.users.ma-gerbig.name;
      flakeDir = "/home/ma-gerbig/.dotfiles";
    };
    flatpak.enable = true;
    gaming.enable = true;
    secureboot.enable = true;
    wireless.enable = true;
  };

  services.xserver.enable = true;
}
