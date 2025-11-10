{
  config,
  lib,
  ...
}:
let
  cfg = config.optional.syncthing;
in
{
  options.optional.syncthing = {
    enable = lib.mkEnableOption "Enable Syncthinc Service";
  };

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        openDefaultPorts = true;
        user = "ma-gerbig";
        dataDir = "/home/ma-gerbig"; # Default folder for new synced folders, instead of /var/lib/syncthing
        configDir = "/home/ma-gerbig/.config/syncthing"; # Folder for Syncthing's settings and keys. Will be overwritten by Nix!
        overrideDevices = true; # overrides any devices added or deleted through the WebUI
        overrideFolders = true; # overrides any folders added or deleted through the WebUI
        key = config.sops.secrets.syncthing_key.path;
        cert = config.sops.secrets.syncthing_cert.path;
        settings = {
          devices = {
            # Existing devices here!
            NAZGUL.id = "M7YFRFP-ST3RR2M-U6JV32F-RUHRVVQ-SMXSDQJ-YRWAB3B-VKEUHCB-NDCBJQ2";
            NitroX.id = "4WNOAB3-IS6D344-VDWQTSU-OPGJT65-7XC3OIH-Q63QAS4-OVRV4OJ-ZXLZWAE";
            steamdeck.id = "IGM62YB-NUY5QXD-QRBBMQX-PFWSSZG-5NEN3ZQ-XH6CGWW-3DWS2TA-DMW77AG";
            T460p.id = "7H7UMNA-IBPSUGV-7ZSSPAR-YSFK6H4-SMKVZD6-6N5ABIV-FYTQSFU-K5QRZAQ";
          };
        };
      };
    };

    sops.secrets = {
      syncthing_key = {
        owner = "ma-gerbig";
        mode = "0440";
      };
      syncthing_cert = {
        owner = "ma-gerbig";
        mode = "0440";
      };
    };
  };
}
