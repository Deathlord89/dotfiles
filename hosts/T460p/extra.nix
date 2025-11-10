{
  imports = [
    #../common/optional/flatpak.nix
    #../common/optional/steam.nix
    #../common/optional/wireless.nix
  ];

  optional = {
    secureboot.enable = true;
    flatpak.enable = true;
  };
}
