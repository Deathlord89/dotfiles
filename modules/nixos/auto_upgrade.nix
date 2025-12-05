{
  config,
  lib,
  pkgs,
  sopsFolder,
  ...
}:
let
  cfg = config.optional.autoUpgrade;
in
{
  options = {
    optional.autoUpgrade = {
      enable = lib.mkEnableOption "Enables automatic system updates.";

      flakeDir = lib.mkOption {
        type = lib.types.str;
        description = "Path where your NixOS configuration files are stored.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "Which user account to use for git commands";
      };

      flags = lib.mkOption {
        default = "";
        type = lib.types.str;
        description = "Any additional flags passed to {command}`nixos-rebuild`.";
      };

      onCalendar = lib.mkOption {
        default = "daily";
        type = lib.types.str;
        description = "How frequently to run updates. See systemd.timer(5) and systemd.time(7) for configuration details.";
      };

      operation = lib.mkOption {
        default = "switch";
        type = lib.types.enum [
          "boot"
          "switch"
        ];
        description = ''
          Whether to run
          `nixos-rebuild switch --upgrade` or run
          `nixos-rebuild boot --upgrade`
        '';
      };

      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "If true, the time when the service unit was last triggered is stored on disk. When the timer is activated, the service unit is triggered immediately if it would have been triggered at least once during the time when the timer was inactive. This is useful to catch up on missed runs of the service when the system was powered down.";
      };

      upgrade = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable rebuild service";
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = lib.types.str;
        example = "45min";
        description = ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      fixedRandomDelay = lib.mkOption {
        default = false;
        type = lib.types.bool;
        example = true;
        description = ''
          Make the randomized delay consistent between runs.
          This reduces the jitter between automatic upgrades.
          See {option}`randomizedDelaySec` for configuring the randomized delay.
        '';
      };

      allowReboot = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Reboot the system into the new generation instead of a switch
          if the new generation uses a different kernel, kernel modules
          or initrd than the booted system.
          See {option}`rebootWindow` for configuring the times at which a reboot is allowed.
        '';
      };

      rebootWindow = lib.mkOption {
        default = null;
        description = ''
          Define a lower and upper time value (in HH:MM format) which
          constitute a time window during which reboots are allowed after an upgrade.
          This option only has an effect when {option}`allowReboot` is enabled.
          The default value of `null` means that reboots are allowed at any time.
        '';
        example = {
          lower = "01:00";
          upper = "05:00";
        };
        type =
          with lib.types;
          nullOr (submodule {
            options = {
              lower = lib.mkOption {
                description = "Lower limit of the reboot window";
                type = lib.types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "01:00";
              };

              upper = lib.mkOption {
                description = "Upper limit of the reboot window";
                type = lib.types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "05:00";
              };
            };
          });
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Assert that system.autoUpgrade is not also enabled
    assertions = [
      {
        assertion = !config.system.autoUpgrade.enable;
        message = "The system.autoUpgrade option conflicts with this module.";
      }
    ];

    sops.secrets."tokens/github_deploy_key" = {
      sopsFile = "${sopsFolder}/shared.yaml";
    };

    systemd = {
      services = {
        nixos-autoupgrade-pull = {
          description = "Pull dotfiles from git repo";
          restartIfChanged = false;

          # TODO Enable rebuild script after testing the CI part on github!
          # onSuccess = [ "nixos-autoupgrade-rebuild.service" ];

          serviceConfig = {
            Type = "oneshot";
            User = "${cfg.user}";
            WorkingDirectory = "${cfg.flakeDir}";
          };

          environment = {
            inherit (config.environment.sessionVariables) NIX_PATH;
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

        # TODO Enable rebuild script after testing the CI part on github!
        nixos-autoupgrade-rebuild = lib.mkIf cfg.upgrade {
          description = "Rebuilds and activates system config";
          restartIfChanged = false;

          serviceConfig = {
            Type = "oneshot";
          };

          environment = {
            inherit (config.environment.sessionVariables) NIX_PATH;
            HOME = "/root";
            GIT_SSH_COMMAND = "ssh -i ${config.sops.secrets."tokens/github_deploy_key".path}";
          };

          path = with pkgs; [
            config.programs.ssh.package
            coreutils
            gitMinimal
          ];
          script =
            let
              date = "${pkgs.coreutils}/bin/date";
              nixos-rebuild = "${config.system.build.nixos-rebuild}/bin/nixos-rebuild";
              readlink = "${pkgs.coreutils}/bin/readlink";
              shutdown = "${config.systemd.package}/bin/shutdown";
            in
            if cfg.allowReboot then
              ''
                  ${nixos-rebuild} boot --no-update-lock-file ${cfg.flags} --flake path:${cfg.flakeDir}
                  booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
                  built="$(${readlink} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

                  ${lib.optionalString (cfg.rebootWindow != null) ''
                    current_time="$(${date} +%H:%M)"

                    lower="${cfg.rebootWindow.lower}"
                    upper="${cfg.rebootWindow.upper}"

                    if [[ "''${lower}" < "''${upper}" ]]; then
                      if [[ "''${current_time}" > "''${lower}" ]] && \
                         [[ "''${current_time}" < "''${upper}" ]]; then
                        do_reboot="true"
                      else
                        do_reboot="false"
                      fi
                    else
                      # lower > upper, so we are crossing midnight (e.g. lower=23h, upper=6h)
                      # we want to reboot if cur > 23h or cur < 6h
                      if [[ "''${current_time}" < "''${upper}" ]] || \
                         [[ "''${current_time}" > "''${lower}" ]]; then
                        do_reboot="true"
                      else
                        do_reboot="false"
                      fi
                    fi
                  ''}

                if [ "''${booted}" = "''${built}" ]; then
                  ${nixos-rebuild} ${cfg.operation} --no-update-lock-file ${cfg.flags} --flake path:${cfg.flakeDir}
                ${lib.optionalString (cfg.rebootWindow != null) ''
                  elif [ "''${do_reboot}" != true ]; then
                    echo "Outside of configured reboot window, skipping."
                ''}
                else
                  ${shutdown} -r +1
                fi
              ''
            else
              ''
                ${nixos-rebuild} ${cfg.operation} --no-update-lock-file ${cfg.flags} --flake path:${cfg.flakeDir}
              '';

          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
        };
      };

      timers = {
        nixos-autoupgrade-pull = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.onCalendar;
            RandomizedDelaySec = cfg.randomizedDelaySec;
            FixedRandomDelay = cfg.fixedRandomDelay;
            Persistent = cfg.persistent;
          };
        };
      };
    };
  };
}
