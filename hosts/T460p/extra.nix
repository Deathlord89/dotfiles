{
  imports = [
    #../common/optional/wireless.nix
  ];

  optional = {
    flatpak.enable = true;
    gaming.enable = true;
    secureboot.enable = true;
  };
}
