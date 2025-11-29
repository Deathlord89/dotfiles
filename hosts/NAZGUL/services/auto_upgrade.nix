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

        environment = {
          inherit (config.environment.sessionVariables) NIX_PATH;
          HOME = "/root";
        };

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

      rebuild_nixos_system = {
        description = "Rebuilds and activates system config";
        restartIfChanged = false;

        serviceConfig = {
          Type = "oneshot";
          # User = "ma-gerbig";
          #WorkingDirectory = "/home/ma-gerbig/.dotfiles";
        };

        path = with pkgs; [
          config.programs.ssh.package
          coreutils
          gitMinimal
        ];
        script =
          let
            nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
            readlink = "${pkgs.coreutils}/bin/readlink";
            shutdown = "${config.systemd.package}/bin/shutdown";
          in
          ''
            ${nixos-rebuild} boot --no-update-lock-file --flake path:/home/ma-gerbig/.dotfiles
            booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
            built="$(${readlink} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

            if [ "''${booted}" = "''${built}" ]; then
              ${nixos-rebuild} switch --no-update-lock-file --flake path:/home/ma-gerbig/.dotfiles
            else
              ${nixos-rebuild} switch --no-update-lock-file --flake path:/home/ma-gerbig/.dotfiles
              #${shutdown} -r +1
            fi
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
