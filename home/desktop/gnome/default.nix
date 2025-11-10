{ pkgs, ... }:
{
  gtk.enable = true;

  dconf.settings = {
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        "kitty.desktop"
        "codium.desktop"
        "steam.desktop"
        "bitwarden.desktop"
      ];
      # 'gnome-extensions list' for a list
      enabled-extensions = [
        "AlphabeticalAppGrid@stuarthayhurst"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
        "gnome-ui-tune@itstime.tech"
        "gsconnect@andyholmes.github.io"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
      ];
      disabled-extensions = [
        "pop-shell@system76.com"
      ];
    };
    "org/gnome/desktop/interface" = {
      font-antialiasing = "grayscale";
      clock-show-seconds = true;
      clock-show-weekday = true;
      font-hinting = "slight";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:close";
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small-plus";
    };

    # Extensions settings
    "org/gnome/shell/extensions/caffeine" = {
      indicator-position = -1;
      indicator-position-index = -1;
      screen-blank = "never";
      show-indicator = "only-active";
      show-notifications = false;
      toggle-shortcut = [ "<Super>c" ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-fixed = false;
      dock-position = "BOTTOM";
      height-fraction = 0.9;
      dash-max-icon-size = 48;
      preview-size-scale = 0.0;
      require-pressure-to-show = false;
      intellihide-mode = "ALL_WINDOWS";
      show-dock-urgent-notify = true;
      autohide = true;
      show-favorites = true;
      show-trash = false;
      show-mounts = true;
      show-mounts-only-mounted = true;
      show-mounts-network = false;
      custom-theme-shrink = true;
      apply-custom-theme = false;
    };
    "org/gnome/shell/extensions/gnome-ui-tune" = {
      increase-thumbnails-size = 100;
      hide-search = true;
      restore-thumbnails-background = true;
      always-show-thumbnails = false;
      overview-firefox-pip = true;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    # Gnome keybindings
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      home = [ "<Super>e" ];
      restore-shortcuts = [ "" ];
      screensaver = [ "<Super>l" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Ctrl><Alt>t";
      command = "kitty";
      name = "Kitty";
    };
  };

  # Install gnome extensions
  home = {
    packages =
      (with pkgs; [ dconf-editor ])
      ++ (with pkgs.gnomeExtensions; [
        alphabetical-app-grid
        appindicator
        blur-my-shell
        caffeine
        dash-to-dock
        gnome-40-ui-improvements
        fuzzy-app-search
        gsconnect
        native-window-placement
        pop-shell
        user-themes
      ]);
  };
}
