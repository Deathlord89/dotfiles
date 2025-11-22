{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./GT_NewHorizons
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/var/lib/minecraft";
  };
}
