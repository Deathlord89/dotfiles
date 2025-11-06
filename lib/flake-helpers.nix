{
  self,
  inputs,
  outputs,
  username,
  ...
}:
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
          self
          inputs
          outputs
          hostname
          desktop
          ;
        username = user;
      };
      modules = [
        ../home/home.nix
      ];
    };

  # Helper function for generating host configs
  mkHost =
    {
      hostname,
      desktop ? null,
      pkgsInput ? inputs.nixpkgs,
    }:
    pkgsInput.lib.nixosSystem {
      specialArgs = {
        inherit
          self
          inputs
          outputs
          username
          hostname
          desktop
          ;
      };
      modules = [
        ../hosts/configuration.nix
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
