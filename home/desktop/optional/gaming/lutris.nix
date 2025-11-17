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
    programs.lutris = {
      enable = true;
      # steamPackage = osConfig.programs.steam.package;
      steamPackage = pkgs.steam;
      winePackages = [ pkgs.wineWowPackages.stableFull ];
      extraPackages = with pkgs; [
        umu-launcher
        winetricks
      ];
      protonPackages = [ pkgs.unstable.proton-ge-bin ];
      defaultWinePackage = pkgs.unstable.proton-ge-bin;
    };
  };
}
