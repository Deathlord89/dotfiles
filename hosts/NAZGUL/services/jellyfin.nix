{
  config,
  pkgs,
  ...
}:
let
  mediaGroup = "media";
in
{
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

    sabnzbd = {
      enable = true;
      inherit (config.services.jellyfin) user;
      group = mediaGroup;
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

    prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };

  # Add `yt-dlp` to jellyfin path
  systemd.services.jellyfin = {
    path = [ pkgs.yt-dlp ];
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
          SONARR__HOST = "http://192.168.10.10:8989";
          RADARR__ENABLED = "true";
          RADARR__HOST = "http://192.168.10.10:7878";
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
          "/var/media/downloads:/opt/JDownloader/Downloads:rw"
          "/var/media/videos/neu:/opt/JDownloader/Extract:rw"
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
