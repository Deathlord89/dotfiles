{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.gaming.lutris;
in
{
  options.optional.gaming.lutris = {
    enable = lib.mkEnableOption "Enable Lutris games manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.lutris.override {
        extraPkgs = pkgs: [
          pkgs.wineWowPackages.stableFull
          #pkgs.wineWowPackages.stagingFull
          pkgs.winetricks
        ];
      })
    ];
  };
}
