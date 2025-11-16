{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.gaming.prismlauncher;
in
{
  options.optional.gaming.prismlauncher = {
    enable = lib.mkEnableOption "Enable Prismlauncher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.prismlauncher ];
  };
}
