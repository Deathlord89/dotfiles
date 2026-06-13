{
  config,
  lib,
  pkgs,
  sopsFolder,
  ...
}:
let
  cfg = config.backup.restic;
in
{
  options.backup.restic = {
    enable = lib.mkEnableOption "enable restic jobs";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      "restic_pass" = {
        sopsFile = "${sopsFolder}/shared.yaml";
      };
      "rclone_conf" = {
        sopsFile = "${sopsFolder}/shared.yaml";
        path = "/root/.config/rclone/rclone.conf";
      };
    };

    environment.systemPackages = with pkgs; [
      restic
      rclone
    ];
  };
}
