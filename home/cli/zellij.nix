{
  config,
  lib,
  ...
}:
{
  programs.zellij = {
    enable = true;
  };

  stylix.targets.zellij = lib.mkIf config.optional.stylix.enable {
    enable = true;
  };
}
