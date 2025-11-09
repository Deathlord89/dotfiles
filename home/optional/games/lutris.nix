{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.games.lutris;
in
{
  options.optional.games.lutris = {
    enable = lib.mkEnableOption "Enable lutris games manager";
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
