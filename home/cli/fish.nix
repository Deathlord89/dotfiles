{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting ""
    '';
    shellAliases = {
      cat = "bat";
      gst = "git status -sb";
      man = "batman";
      neofetch = "fastfetch";
      tree = "eza --tree";
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
