{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting ""
    '';
    shellAliases = {
      tree = "eza --tree";
      neofetch = "fastfetch";
      gst = "git status -sb";
      cat = "bat";
    };
    plugins = [
      {
        name = "autopair";
        inherit (pkgs.fishPlugins.autopair) src;
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "puffer";
        inherit (pkgs.fishPlugins.puffer) src;
      }
    ];

  };
}
