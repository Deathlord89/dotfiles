{
  description = "My NixOS configuration";

  inputs = {
    # NixOS Stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # NixOS Untable - also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # A collection of NixOS modules covering hardware quirks
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
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
    stylix.url = "github:danth/stylix/release-26.05";

    # Minecraft server
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # Private secrets repo
    nix-secrets = {
      url = "git+ssh://git@github.com/Deathlord89/nix-secrets";
      inputs = { };
    };
  };

  outputs =
    {
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
      formatter = libFlake.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

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
        NAZGUL = libFlake.mkHost {
          hostname = "NAZGUL";
        };

        NitroX = libFlake.mkHost {
          hostname = "NitroX";
          desktop = "gnome";
        };

        NixosVM = libFlake.mkHost {
          hostname = "NixosVM";
          desktop = "plasma";
        };

        T460p = libFlake.mkHost {
          hostname = "T460p";
          desktop = "gnome";
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # "${username}@NAZGUL" = libFlake.mkHome {
        #   hostname = "NAZGUL";
        # };

        # "${username}@NitroX" = libFlake.mkHome {
        #   hostname = "NitroX";
        #   desktop = "gnome";
        # };

        # "${username}@NixosVM" = libFlake.mkHome {
        #   hostname = "NixosVM";
        #   desktop = "plasma";
        # };

        # "${username}@T460p" = libFlake.mkHome {
        #   hostname = "T460p";
        #   desktop = "gnome";
        # };
      };
    };
}
