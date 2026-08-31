{
  config,
  inputs,
  pkgs,
  ...
}:
let
  mediaGroup = "media";
in
{
  imports = [ inputs.vpn-confinement.nixosModules.default ];

  users.groups.${mediaGroup} = {
    members = [
      "${config.services.jellyfin.user}"
      # add main user to Jellyfin group for easier access to media files
      "ma-gerbig"
    ];
  };

  sops.secrets = {
    "jdownloader/env.enc" = {
      restartUnits = [ "podman-jdownloader2.service" ];
    };
    "last_fm/env.enc" = {
      owner = config.services.navidrome.user;
      inherit (config.services.navidrome) group;
    };
    radarr_api = {
      owner = config.services.recyclarr.user;
      inherit (config.services.recyclarr) group;
    };
    sonarr_api = {
      owner = config.services.recyclarr.user;
      inherit (config.services.recyclarr) group;
    };
    "umlautadaptarr/env.enc" = {
      restartUnits = [ "podman-umlautadaptarr.service" ];
    };
  };

  services = {
    jellyfin = {
      enable = true;
      group = mediaGroup;
      openFirewall = true;
    };

    navidrome = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
      settings = {
        Address = "192.168.10.10";
        Port = 4533;
        MusicFolder = "/var/data/media/music";
        "LastFM.Language" = "de";
      };
      environmentFile = config.sops.secrets."last_fm/env.enc".path;
      openFirewall = true;
    };

    sabnzbd = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
    };

    qbittorrent = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
      webuiPort = 8084;
      torrentingPort = 6881;
      openFirewall = true;
      serverConfig = {
        Preferences = {
          General.Locale = "de";
          WebUI = {
            Username = "ma-gerbig";
            Password_PBKDF2 = "@ByteArray(5IFzUKVSy9VPueMaVOGaPw==:maI2zM+slNQ4Ir/icw4PJvaO5xd3J9AU/0unQaEhb3WqhfBtOdtOWmd1GZ/vJOLCfowkmOhXtYWgSOPBaelmGA==)";
          };
        };
        Core.AutoDeleteAddedTorrentFile = "IfAdded";
        LegalNotice.Accepted = true;
        Network.PortForwardingEnabled = false;
        BitTorrent = {
          ExcludedFileNamesEnabled = true;
          Session = {
            TorrentContentLayout = "Subfolder";
            DefaultSavePath = "/var/data/downloads/complete/torrents";
            TempPathEnabled = true;
            TempPath = "/var/data/downloads/incomplete/torrents";
            DisableAutoTMMByDefault = false;
            DisableAutoTMMTriggers = {
              CategorySavePathChanged = false;
              DefaultSavePathChanged = false;
            };
            ExcludedFileNames = "*.rar, *.r[0-9]*, *.lnk, *.scr, *.arj";
            GlobalDLSpeedLimit = "4000";
            GlobalUPSpeedLimit = "750";
            MaxConnections = "-1";
            MaxConnectionsPerTorrent = "-1";
            MaxUploads = "-1";
            MaxUploadsPerTorrent = "-1";
            QueueingSystemEnabled = false;
            MaxActiveDownloads = "-1";
            MaxActiveTorrents = "-1";
            MaxActiveUploads = "-1";
          };
        };

      };
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
      openFirewall = true;
    };

    lidarr = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
      openFirewall = true;
    };

    recyclarr = {
      enable = true;
      configuration = {
        sonarr.main-sonarr = {
          api_key._secret = config.sops.secrets.sonarr_api.path;
          base_url = "http://localhost:${toString config.services.sonarr.settings.server.port}";
          delete_old_custom_formats = true;
          replace_existing_custom_formats = true;
          inherit (inputs.nix-secrets.recyclarr.main-sonarr) quality_profiles custom_formats;
        };
        radarr.main-radarr = {
          api_key._secret = config.sops.secrets.radarr_api.path;
          base_url = "http://localhost:${toString config.services.radarr.settings.server.port}";
          delete_old_custom_formats = true;
          replace_existing_custom_formats = true;
          inherit (inputs.nix-secrets.recyclarr.main-radarr) quality_profiles custom_formats;
        };
      };
    };
  };

  systemd.services = {
    # Add systemd service to VPN network namespace
    qbittorrent.vpnConfinement = {
      enable = true;
      vpnNamespace = "wg0";
    };
    # Add `yt-dlp` to jellyfin path
    jellyfin = {
      path = [ pkgs.yt-dlp ];
    };
  };

  optional.podman.enable = true;
  virtualisation.oci-containers = {
    containers = {
      "umlautadaptarr" = {
        image = "docker.io/pcjones/umlautadaptarr";
        autoStart = true;
        environment = {
          TZ = "Europe/Berlin";
          SONARR__ENABLED = "true";
          SONARR__HOST = "http://192.168.10.10:${toString config.services.sonarr.settings.server.port}";
          RADARR__ENABLED = "true";
          RADARR__HOST = "http://192.168.10.10:${toString config.services.radarr.settings.server.port}";
        };
        environmentFiles = [ "${config.sops.secrets."umlautadaptarr/env.enc".path}" ];
        ports = [ "5006:5006/tcp" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        log-driver = "journald";
      };

      "jdownloader2" = {
        image = "docker.io/jaymoulin/jdownloader";
        autoStart = true;
        user = "${builtins.toString config.users.users.jellyfin.uid}:${
          builtins.toString config.users.groups.${mediaGroup}.gid
        }";
        environmentFiles = [ "${config.sops.secrets."jdownloader/env.enc".path}" ];
        ports = [ "3129:3129/tcp" ];
        volumes = [
          "jdownloader_app:/opt/JDownloader/app:rw"
          "/var/lib/jdownloader:/opt/JDownloader/app/cfg:rw"
          "/var/data/downloads/incomplete/jdownloader:/opt/JDownloader/Downloads:rw"
          "/var/data/downloads/complete/jdownloader:/opt/JDownloader/Extract:rw"
          "/etc/localtime:/etc/localtime:ro"
        ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        log-driver = "journald";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    3129
    8081
  ];
}
