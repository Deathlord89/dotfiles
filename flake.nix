{
  description = "My NixOS configuration";

  inputs = {
    # NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOS Stable - also see the 'stable-unstable' overlay at 'overlays/default.nix'.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager Stable
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Private secrets repo
    nix-secrets = {
      url = "git+ssh://git@github.com/Deathlord89/nix-secrets?shallow=1";
      inputs = { };
    };
  };

  outputs =
    {
      nixpkgs-stable,
      nixpkgs,
      self,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      username = "ma-gerbig";
      stateVersion = "24.05";

      libx = import ./lib { inherit nixpkgs; };
      libFlake = import ./lib/flake-helpers.nix {
        inherit
          inputs
          libx
          outputs
          self
          stateVersion
          username
          ;
      };

    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = libFlake.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      formatter = libFlake.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Pre-commit checks
      checks = libFlake.forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks.nix { inherit inputs system pkgs; }
      );

      devShells = libFlake.forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );

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
          pkgsInput = nixpkgs-stable;
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "${username}@NixosVM" = libFlake.mkHome {
          hostname = "NixosVM";
          desktop = "plasma";
          pkgsInput = nixpkgs-stable;
        };
      };
    };
}
