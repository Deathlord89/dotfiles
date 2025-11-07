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
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    btop
    lazygit
    mc
    neovim
    wl-clipboard
    xclip
  ];
}
