{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set fish_greeting ""
    '';
    shellAbbrs = {
      st = "systemctl status";
      sr = "systemctl restart";
      stu = "systemctl --user status";
      sru = "systemctl --user restart";
    };
    shellAliases = {
      cat = "bat";
      gst = "git status -sb";
      man = "batman";
      neofetch = "fastfetch";
      tree = "eza --tree";
    };
    functions = {
      flake-build-all = {
        # https://discourse.nixos.org/t/best-practices-for-auto-updating-remotely-deployed-systems/67535/4
        description = "Build all flake configurations with pueue";
        body = ''
          for host in (nix flake show --json | jq -r '.nixosConfigurations | keys[]')
              pueue add "nix build --out-link result-$host .#nixosConfigurations.$host.config.system.build.toplevel"
          end
        '';
      };
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
