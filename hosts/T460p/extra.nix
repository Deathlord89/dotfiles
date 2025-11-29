{ config, ... }:
{
  optional = {
    autoUpgrade = {
      enable = true;
      user = config.users.users.ma-gerbig.name;
      flakeDir = "${config.users.users.ma-gerbig.home}/.dotfiles";
    };
    flatpak.enable = true;
    gaming.enable = true;
    secureboot.enable = true;
    wireless.enable = true;
  };

  services.xserver.enable = true;
}
