{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.games.prismlauncher;
in
{
  options.optional.games.prismlauncher = {
    enable = lib.mkEnableOption "Enable prismlauncher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
