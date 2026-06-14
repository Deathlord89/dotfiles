{
  inputs,
  libx,
  outputs,
  self,
  stateVersion,
  username,
  ...
}:
let
  sopsFolder = builtins.toString inputs.nix-secrets + "/sops";
in
{
  # Helper function for generating home-manager configs
  mkHome =
    {
      hostname,
      user ? username,
      desktop ? null,
      system ? "x86_64-linux",
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit
          desktop
          hostname
          inputs
          libx
          outputs
          self
          stateVersion
          ;
        username = user;
      };
      modules = [
        inputs.stylix.homeModules.stylix
        ../home
      ];
    };

  # Helper function for generating host configs
  mkHost =
    {
      hostname,
      desktop ? null,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          desktop
          hostname
          inputs
          libx
          outputs
          self
          sopsFolder
          stateVersion
          username
          ;
      };
      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.sops-nix.nixosModules.sops
        ../hosts
      ];
    };

  # Supported systems for your flake packages, shell, etc.
  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "x86_64-linux"
    #"aarch64-darwin"
    #"aarch64-linux"
    #"i686-linux"
    #"x86_64-darwin"
  ];
}
