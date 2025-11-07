{
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting ""
    '';
    shellAliases = {
      cat = "bat";
      gst = "git status -sb";
      neofetch = "fastfetch";
      tree = "eza --tree";
    };
  };
}
