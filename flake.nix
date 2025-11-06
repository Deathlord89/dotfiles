{
  description = "My NixOS configuration";

  inputs = {
    # NixOS Stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # NixOS Unstable - also see the 'stable-unstable' overlay at 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "ma-gerbig";

      libFlake = import ./lib/flake-helpers.nix {
        inherit
          self
          inputs
          outputs
          username
          ;
      };
      libx = import ./lib { inherit nixpkgs; };

    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = libFlake.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = libFlake.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = libFlake.forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # Desktop machines
        NixosVM = libFlake.mkHost {
          hostname = "NixosVM";
          desktop = "plasma";
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "${username}@NixosVM" = libFlake.mkHome {
          hostname = "NixosVM";
          desktop = "plasma";
        };
      };
    };
}
