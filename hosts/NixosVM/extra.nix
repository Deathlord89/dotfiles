{ pkgs, ... }:
{
  services.xserver.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    fish
    git
    nil
  ];
}
