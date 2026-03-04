{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.optional.appimage;
in
{
  options.optional.appimage = {
    enable = lib.mkEnableOption "Enable appimage integration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # remove stable when untable is fixed
      stable.gearlever
    ];

    programs.appimage = {
      enable = true;
      binfmt = true;
      # Some appimages still have issues, so you can override for additional pkgs
      #package = pkgs.appimage-run.override {
      #extraPkgs = pkgs: [
      #  pkgs.icu
      #  pkgs.libdrm
      #  pkgs.libxcrypt-legacy
      #  pkgs.python312
      #  pkgs.python312Packages.torch
      #];
      #};
    };
  };
}
