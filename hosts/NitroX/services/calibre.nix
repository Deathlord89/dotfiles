{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    calibre
  ];

  networking.firewall.allowedTCPPorts = [
    8080
    9090
  ];
}
