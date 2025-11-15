{
  desktop,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}:
{
  # Only import desktop configuration if the host is desktop enabled
  # Only import user specific configuration if they have bespoke settings
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    ./cli
  ]
  # Include custom nixos modules
  ++ (builtins.attrValues outputs.homeManagerModules)
  # Include desktop config if a desktop is defined
  ++ lib.optional (builtins.isString desktop) ./desktop
  # Include user specific settings
  ++ lib.optional (builtins.pathExists (./. + "/users/${username}")) ./users/${username};

  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";

    sessionVariables = {
      EDITOR = "nvim";
      NH_FLAKE = "$HOME/.dotfiles";
    };

    # Reload font cache on rebuild to avoid issues similar to
    # https://www.reddit.com/r/NixOS/comments/1kwogzf/after_moving_to_2505_system_fonts_no_longer/
    activation.reloadFontCache = lib.hm.dag.entryAfter [ "linkActivation" ] ''
      if [ -x "${pkgs.fontconfig}/bin/fc-cache" ]; then
        ${pkgs.fontconfig}/bin/fc-cache -f
      fi
    '';
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-unstable

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
