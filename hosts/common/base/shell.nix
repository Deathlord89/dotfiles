{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-index-database.nixosModules.default
  ];

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    lm_sensors
    pciutils
    usbutils
    wget
  ];

  # comma runs a command without installing it
  programs.nix-index-database.comma.enable = true;
}
