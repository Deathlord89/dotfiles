# List all the just commands
default:
    @just --list

# Update all the flake inputs
up:
  nix flake update && \
  git add flake.lock && \
  git commit -m "chore(flake): update inputs"

# Update the nix-secrets repository
ups:
  nix flake update nix-secrets && \
  git add flake.lock && \
  git commit -m "chore(flake): update input nix-secrets"
