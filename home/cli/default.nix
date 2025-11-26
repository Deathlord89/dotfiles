{
  libx,
  pkgs,
  ...
}:
{
  imports = libx.scanPaths ./.;

  programs = {
    # Enable home-manager
    home-manager.enable = true;

    # Enable Home Manager integration in the default shell, because without it,
    # environment variables such as SSH_AUTH_SOCK will not be populated.
    bash = {
      enable = true;
      enableCompletion = true;
    };

    bat.enable = true;
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    bat-extras.core
    btop # Resource monitor
    doggo # DNS client for humans
    fastfetch # Command-line system information tool
    fd # search for files by name, faster than find
    fzf # Interactively filter its input using fuzzy searching, not limit to filenames.
    gping # ping, but with a graph(TUI)
    just # a command runner like make, but simpler
    lazygit # Git terminal UI
    mc # Dual-pane file manager
    ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
    neovim # Texteditor
    ripgrep # search for files by its content, replacement of grep
    tree # list contents of directories in a tree-like format
    wl-clipboard # Wayland clipboard
    xclip # X11 clipboard
  ];
}
