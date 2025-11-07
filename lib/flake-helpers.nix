{
  inputs,
  libx,
  outputs,
  self,
  stateVersion,
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
      pkgsInput ? inputs.nixpkgs,
      system ? "x86_64-linux",
      homeManagerInput ? (
        if pkgsInput == inputs.nixpkgs-stable then inputs.home-manager-stable else inputs.home-manager
      ),
    }:
    homeManagerInput.lib.homeManagerConfiguration {
      pkgs = pkgsInput.legacyPackages.${system};
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
        ../home
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
          desktop
          hostname
          inputs
          libx
          outputs
          self
          stateVersion
          username
          ;
      };
      modules = [
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
