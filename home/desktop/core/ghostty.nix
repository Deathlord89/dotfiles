{
  config,
  lib,
  ...
}:
{
  programs.ghostty.enable = true;

  # FIX
  # See: https://github.com/ghostty-org/ghostty/discussions/8899
  home.sessionVariables.GTK_IM_MODULE = "simple";

  stylix.targets.ghostty = lib.mkIf config.optional.stylix.enable {
    enable = true;
  };
}
