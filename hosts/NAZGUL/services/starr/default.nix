{
  inputs,
  config,
  libx,
  ...
}:
{
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ]
  ++ (libx.scanPaths ./.);

  sops.secrets = {
    "vpn-confinement/wg0.enc" = {
    };
  };

  vpnNamespaces.wg0 = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."vpn-confinement/wg0.enc".path;
    accessibleFrom = [
      "192.168.10.0/24"
    ];
    allowedEgress = [ "192.168.10.10" ];
    portMappings = [
      {
        from = 8084;
        to = 8084;
      }
      {
        from = 9696;
        to = 9696;
      }
    ];
    openVPNPorts = [
      {
        port = 6881;
        protocol = "both";
      }
    ];
  };

}
