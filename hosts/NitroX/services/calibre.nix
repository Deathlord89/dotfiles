{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (calibre.override {
      unrarSupport = true;
    })
  ];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
  ];
}
