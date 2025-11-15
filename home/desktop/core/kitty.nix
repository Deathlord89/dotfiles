{
  config,
  lib,
  pkgs,
  ...
}:
let
  icon = pkgs.fetchurl {
    url = "https://github.com/DinkDonk/kitty-icon/blob/main/kitty-dark.png?raw=true";
    sha256 = "McF0F74s6scdwNc+QSubVDk1PRD/4YiTI1iFju3LynA=";
  };
in
{
  config = {
    xdg.dataFile."icons/hicolor/256x256/apps/kitty.png".source = icon;
    xdg.dataFile."icons/hicolor/scalable/apps/kitty.png".source = icon;

    programs.kitty = {
      enable = true;
      settings = {
        allow_remote_control = "no";
        confirm_os_window_close = "-1";
        disable_ligatures = "cursor";
        remember_window_size = "no";
        strip_trailing_spaces = "smart";
        term = "xterm-256color";
        window_padding_width = "2";
        # OS specific
        linux_display_server = "x11";
      };
    };

    stylix.targets.kitty = lib.mkIf config.optional.stylix.enable {
      enable = true;
    };
  };
}
