{
  description = "My NixOS configuration";

  inputs = {
    # NixOS Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # NixOS Stable - also see the 'stable-unstable' overlay at 'overlays/default.nix'.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # A collection of NixOS modules covering hardware quirks
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Bleeding edge packages from chaotic nyx, especially CachyOS kernel
    # Don't add follows nixpkgs, else will cause local rebuilds
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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

    # Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    stylix.url = "github:danth/stylix";

    # Minecraft server
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

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
        NitroX = libFlake.mkHost {
          hostname = "NitroX";
          desktop = "gnome";
        };

        NixosVM = libFlake.mkHost {
          hostname = "NixosVM";
          desktop = "plasma";
          pkgsInput = nixpkgs-stable;
        };

        T460p = libFlake.mkHost {
          hostname = "T460p";
          desktop = "gnome";
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "${username}@NitroX" = libFlake.mkHome {
          hostname = "T460p";
          desktop = "gnome";
        };

        "${username}@NixosVM" = libFlake.mkHome {
          hostname = "NixosVM";
          desktop = "plasma";
          pkgsInput = nixpkgs-stable;
        };

        "${username}@T460p" = libFlake.mkHome {
          hostname = "T460p";
          desktop = "gnome";
        };
      };
    };
}
