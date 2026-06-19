{
  config,
  inputs,
  sopsFolder,
  ...
}:
{
  backup.restic.enable = true;

  sops.secrets = {
    "vaultwarden_env.enc" = {
      owner = "vaultwarden";
    };
    "vaultwarden/restic_pass" = {
      sopsFile = "${sopsFolder}/shared.yaml";
      key = "restic_pass";
      owner = "vaultwarden";
    };
    "vaultwarden/rclone_conf" = {
      sopsFile = "${sopsFolder}/shared.yaml";
      key = "rclone_conf";
      owner = "vaultwarden";
    };
  };

  services = {
    vaultwarden = {
      enable = true;

      dbBackend = "postgresql";
      configurePostgres = false;

      environmentFile = "${config.sops.secrets."vaultwarden_env.enc".path}";
      config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vault.${inputs.nix-secrets.domain}";

        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql&user=vaultwarden";
      };
    };

    postgresql = {
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "vaultwarden" ];
    };

    restic.backups = {
      vaultwarden = {
        repository = "rclone:pCloud:Backups/Homeserver";
        user = "vaultwarden";
        backupPrepareCommand = "${config.services.postgresql.package}/bin/pg_dump --clean -d vaultwarden > /var/lib/bitwarden_rs/backup.sql";
        backupCleanupCommand = "rm /var/lib/bitwarden_rs/backup.sql";
        passwordFile = config.sops.secrets."vaultwarden/restic_pass".path;
        rcloneConfigFile = config.sops.secrets."vaultwarden/rclone_conf".path;
        paths = [
          "/var/lib/bitwarden_rs"
        ];
        pruneOpts = [
          "--tag vaultwarden"
          "--keep-hourly 8 --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 1"
        ];
        extraBackupArgs = [
          "--tag vaultwarden"
          "--limit-upload 750"
        ];
        exclude = [
          "*.log"
          "/var/lib/bitwarden_rs/icon_cache"
          "/var/lib/bitwarden_rs/tmp"
        ];
        timerConfig = {
          OnCalendar = "*-*-* 00,03,06,09,12,15,18,21:00:00";
          RandomizedDelaySec = "120";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    8222
  ];
}
