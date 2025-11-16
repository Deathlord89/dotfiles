# Reference:
# https://github.com/librephoenix/nixos-config/blob/main/user/style/stylix.nix
{
  config,
  desktop,
  lib,
  libx,
  pkgs,
  ...
}:
let
  cfg = config.optional.stylix;
  theme = import (libx.relativeToRoot "themes" + ("/" + config.optional.stylix.theme));
in
{
  options.optional.stylix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = desktop != null;
      description = "Enable Stylix";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "nord";
      description = "The name oh the theme to enable. A list of themes can be found in the `themes` directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      autoEnable = false;

      targets = {
        gtk.enable = lib.mkDefault true;
        qt.enable = lib.mkDefault true;
      };

      inherit (theme) polarity;
      #image = pkgs.fetchurl {
      #  url = theme.backgroundUrl;
      #  sha256 = theme.backgroundSha256;
      #};

      base16Scheme = theme;

      cursor = {
        size = 24;
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };

      opacity = {
        desktop = 1.0;
        popups = 0.95;
        terminal = 0.90;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono NF";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-color-emoji;
        };
      };
    };

    #stylix.targets = {
    #  vscode.profileNames = [ "default" ];
    #  firefox.profileNames = [ "${config.home.username}" ];
    #};

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ config.stylix.fonts.monospace.name ];
        sansSerif = [ config.stylix.fonts.sansSerif.name ];
        serif = [ config.stylix.fonts.serif.name ];
      };
    };
  };
}
