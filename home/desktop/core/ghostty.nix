{
  config,
  lib,
  ...
}:
{
  programs.ghostty.enable = true;

  stylix.targets.ghostty = lib.mkIf config.optional.stylix.enable {
    enable = true;
  };
}
