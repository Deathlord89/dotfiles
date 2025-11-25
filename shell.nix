# Shell for bootstrapping flake-enabled nix and home-manager
# You can enter it through 'nix develop' or (legacy) 'nix-shell'
{
  checks,
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  default = pkgs.mkShell {
    inherit (checks.pre-commit-check) shellHook;
    buildInputs = checks.pre-commit-check.enabledPackages;

    nativeBuildInputs = with pkgs; [
      just
    ];
  };
  install = pkgs.mkShell {
    # Enable experimental features without having to specify the argument
    NIX_CONFIG = "experimental-features = nix-command flakes";

    nativeBuildInputs = with pkgs; [
      curl
      disko
      git
      home-manager
      nix
      ssh-to-age
      wget
    ];

    shellHook = ''
      echo "=== Shell for bootstrapping NixOS ==="
    '';
  };
}
