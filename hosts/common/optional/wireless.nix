{
  config,
  lib,
  sopsFolder,
  ...
}:
let
  cfg = config.optional.wireless;
in
{
  options.optional.wireless = {
    enable = lib.mkEnableOption "Enable Wireless Networking";
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."wireless.env" = {
      sopsFile = "${sopsFolder}/shared.yaml";
    };

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [ config.sops.secrets."wireless.env".path ];
      profiles = {
        "$home1_ssid" = {
          connection = {
            id = "$home1_ssid";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$home1_ssid";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$home1_psk";
          };
        };
        "$home2_ssid" = {
          connection = {
            id = "$home2_ssid";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$home2_ssid";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$home2_psk";
          };
        };
        "$work1_ssid" = {
          connection = {
            id = "$work_guest_ssid";
            type = "wifi";
          };
          ipv4 = {
            method = "auto";
            dhcp-send-hostname = false;
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
            dhcp-send-hostname = false;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$work_guest_ssid";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$work_guest_psk";
          };
        };
      };
    };
  };
}
