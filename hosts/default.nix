{
  config,
  desktop,
  hostname,
  inputs,
  lib,
  modulesPath,
  outputs,
  stateVersion,
  username,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (./. + "/${hostname}/boot.nix")
    (./. + "/${hostname}/hardware.nix")

    ./common/base
    ./common/optional
    ./common/users/${username}
  ]
  # Include custom nixos modules
  ++ (builtins.attrValues outputs.nixosModules)
  # Include host specific additional settings
  ++ lib.optional (builtins.pathExists (./. + "/${hostname}/extra.nix")) ./${hostname}/extra.nix
  # Include host specific services if defined
  ++ lib.optional (builtins.pathExists (./. + "/${hostname}/services")) ./${hostname}/services
  # Include desktop config if a desktop is defined
  ++ lib.optional (builtins.isString desktop) ./common/desktop;

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-unstable

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mkForce (
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry
    );

    # Automatically run the nix store optimiser at a specific time.
    optimise.automatic = true;

    settings = {
      # Automatically optimise store after rebuild
      auto-optimise-store = true;

      experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];

      substituters = [ "https://cache.garnix.io" ];
      trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
    };
  };

  system = {
    inherit stateVersion;
  };
}
