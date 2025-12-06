{
  config,
  inputs,
  pkgs,
  sopsFolder,
  ...
}:
{
  backup.restic.enable = true;

  sops.secrets = {
    "nextcloud/adminpass" = {
      owner = "nextcloud";
    };
    "nextcloud/web_env.enc" = {
      owner = "nextcloud";
    };
    "nextcloud/restic_pass" = {
      sopsFile = "${sopsFolder}/shared.yaml";
      key = "restic_pass";
      owner = "nextcloud";
    };
    "nextcloud/rclone_conf" = {
      sopsFile = "${sopsFolder}/shared.yaml";
      key = "rclone_conf";
      owner = "nextcloud";
    };
  };

  services = {
    nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      hostName = "cloud.${inputs.nix-secrets.domain}";
      # home dir is default: /var/lib/nextcloud
      datadir = "/var/cloud";
      database.createLocally = false;
      configureRedis = false;
      secretFile = "${config.sops.secrets."nextcloud/web_env.enc".path}";
      maxUploadSize = "20G";
      phpOptions = {
        "opcache.interned_strings_buffer" = "32";
      };

      config = {
        dbtype = "pgsql";
        dbhost = "/run/postgresql";
        dbname = "nextcloud";
        dbuser = "nextcloud";

        adminuser = "admin";
        adminpassFile = "${config.sops.secrets."nextcloud/adminpass".path}";
      };

      # this only loads the modules, config is below in extraOptions
      caching = {
        apcu = true;
        memcached = false;
        redis = true;
      };

      settings = {
        # caching
        "redis"."host" = "/run/redis-nextcloud/redis.sock";
        "memcache.local" = "\\OC\\Memcache\\APCu";
        "memcache.distributed" = "\\OC\\Memcache\\Redis";
        "memcache.locking" = "\\OC\\Memcache\\Redis"; # this must be Redis to avoid data loss

        # email sending
        "mail_smtpmode" = "smtp";
        "mail_smtpsecure" = "ssl";
        "mail_smtpauth" = true;
        "mail_sendmailmode" = "smtp";
        "mail_smtpport" = 465;
        # mail_smtppassword is set via secretFile

        log_type = "errorlog";
        loglevel = 1;

        overwriteprotocol = "https";
        trusted_proxies = [ "192.168.1.1" ];
        "overwrite.cli.url" = "http://cloud.${inputs.nix-secrets.domain}";

        "maintenance_window_start" = "1"; # run daily jobs between 01:00 and 05:00 UTC
        default_phone_region = "DE"; # this sets the default country code for phone numbers, here +49

        "trashbin_retention_obligation" = "30, 90";
      };
    };

    postgresql = {
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "nextcloud" ];
    };

    redis.servers.nextcloud = {
      enable = true;
      appendOnly = true;
    };

    nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 8080;
        }
      ];
    };

    restic.backups = {
      nextcloud = {
        repository = "rclone:pCloud:Backups/Homeserver";
        user = "nextcloud";
        backupPrepareCommand = ''
          ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --on
          ${config.services.postgresql.package}/bin/pg_dump --clean -d nextcloud -f /var/cloud/backup.sql
        '';
        backupCleanupCommand = ''
          rm /var/cloud/backup.sql
          ${config.services.nextcloud.occ}/bin/nextcloud-occ maintenance:mode --off
        '';
        passwordFile = config.sops.secrets."nextcloud/restic_pass".path;
        rcloneConfigFile = config.sops.secrets."nextcloud/rclone_conf".path;
        paths = [
          "/var/cloud/"
        ];
        pruneOpts = [
          "--tag nextcloud"
          "--keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 1"
        ];
        extraBackupArgs = [
          "--tag nextcloud"
          "--limit-upload 750"
        ];
        exclude = [
          "*.log"
          "/var/cloud/config"
          "/var/cloud/data/*/cache/"
          "/var/cloud/data/*/files_trashbin/"
          "/var/cloud/data/*/uploads/"
          "/var/cloud/data/appdata_*/preview/"
        ];
        timerConfig = {
          OnCalendar = "03:00";
          RandomizedDelaySec = "120";
        };
      };
    };
  };

  users.users.nextcloud.extraGroups = [ "redis-nextcloud" ];
  networking.firewall.allowedTCPPorts = [ 8080 ];

  systemd.services.nextcloud-setup = {
    after = [
      "postgresql.service"
      "redis-nextcloud.service"
    ];
    requires = [
      "postgresql.service"
      "redis-nextcloud.service"
    ];
  };
}
