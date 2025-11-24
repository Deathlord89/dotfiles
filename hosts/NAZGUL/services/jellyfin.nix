{ config, ... }:
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
  };

  optional.podman.enable = true;
  virtualisation.oci-containers = {
    containers = {
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
