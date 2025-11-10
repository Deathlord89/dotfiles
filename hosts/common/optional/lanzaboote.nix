{
  config,
  lib,
  ...
}:
let
  cfg = config.optional.secureboot;
in
{
  options.optional.secureboot = {
    enable = lib.mkEnableOption "Enable Lanzaboote Secureboot";
  };

  config = lib.mkIf cfg.enable {

    # sbctl - a frontend to create, enroll manage keys
    # just need once for importing secureboot keys
    # Spawnm a shell with `nix run -p sbctl`

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot = {
      bootspec.enable = true;
      initrd.systemd.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;

      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
