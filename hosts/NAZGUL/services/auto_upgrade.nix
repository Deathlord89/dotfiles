{ pkgs, config, ... }:
{
  systemd = {
    services = {
      pull_nixos_flake = {
        description = "Pull dotfiles from git repo";
        restartIfChanged = false;

        serviceConfig = {
          Type = "oneshot";
          User = "ma-gerbig";
          WorkingDirectory = "/home/ma-gerbig/.dotfiles";
        };

        path = with pkgs; [
          config.programs.ssh.package
          coreutils
          gitMinimal
        ];

        script =
          let
            test = "${pkgs.coreutils}/bin/test";
            git = "${pkgs.gitMinimal}/bin/git";
          in
          ''
            ${test} "$(${git} branch --show-current)" = "main"
            ${git} pull --ff-only
          '';

        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
      };
    };

    timers = {
      pull_nixos_flake = {
        description = "Timer to pull NixOS Flake";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*:0/15";
        };
      };
    };
  };
}
