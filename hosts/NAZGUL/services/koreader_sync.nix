let
  dataDir = "/var/lib/koreader-sync-server";
in
{
  optional.podman.enable = true;

  networking.firewall.allowedTCPPorts = [ 17200 ];

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 root root -"
    "d ${dataDir}/logs 0750 root root -"
    "d ${dataDir}/logs/app 0750 root root -"
    "d ${dataDir}/logs/redis 0750 root root -"
    "d ${dataDir}/data 0750 root root -"
    "d ${dataDir}/data/redis 0750 root root -"
  ];

  virtualisation.oci-containers = {
    containers = {
      "koreader-sync-server" = {
        image = "docker.io/koreader/kosync";
        autoStart = true;
        volumes = [
          "${dataDir}/logs/app:/app/koreader-sync-server/logs"
          "${dataDir}/logs/redis:/var/log/redis"
          "${dataDir}/data/redis:/var/lib/redis"
        ];
        ports = [ "17200:17200/tcp" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        log-driver = "journald";
      };
    };
  };
}
