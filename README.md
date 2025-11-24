<div align="center">

# :snowflake: Deathlord89's .dotfiles :snowflake:

[![built with nix](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)](https://builtwithnix.org)
[![built with garnix](https://img.shields.io/endpoint?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2FDeathlord89%2Fdotfiles%3Fbranch%3Dmain)](https://garnix.io/repo/Deathlord89/dotfiles)

</div>


A reproducible setup for my personal NixOS and Home-Manager environment, fully managed through [flakes](https://nixos.wiki/wiki/Flakes).
This repository contains system configuration, user environment, development tools, and desktop management.

> [!CAUTION]
> This flake is only designed for my systems.
> The user password is encrypted in a separate private repository using sops-nix.
> Without the secrets, you cannot log in to the system.

---

## Highlights

- Multiple NixOS configurations and package releases, including desktop (`unstable`) and server (`stable`)
- Declarative partitioning with [disko](https://github.com/nix-community/disko)
- Modular configuration
- Declarative themes with [stylix](https://github.com/nix-community/stylix)
- Deployment of secrets using [sops-nix](https://github.com/Mic92/sops-nix) (**with yubikey**) via a private repository called `nix-secrets`
- Includes declarative [pre-commit scripts](https://github.com/pre-commit/pre-commit) with [git-hooks.nix](https://github.com/cachix/git-hooks.nix)
- Built-in development shell via `direnv`

## References

This is a list of repositories that I used as inspiration, sorted by the time of discovery.
- [librephoenix's nixos-config](https://github.com/librephoenix/nixos-config) and [YouTube Channel](https://www.youtube.com/@librephoenix) - Beginner-friendly video series about NixOS and a configuration with many helpful ideas.
- [Vimjoyer](https://www.youtube.com/@vimjoyer) - Beginner-friendly video series about NixOS.
- [Misterio77's nix-config](https://github.com/Misterio77/nix-config) and [flake starter config](https://github.com/Misterio77/nix-starter-configs) - For the fundamental flake structure and recommended settings.
- [jnsgruk's nixos-config](https://github.com/jnsgruk/nixos-config) - For the host / home-manager helper libraries and the blog post about [Secure Boot & TPM-backed Full Disk Encryption](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde).
- [EmergentMind's nix-config](https://github.com/EmergentMind/nix-config) and [nix-secrets-reference](https://github.com/EmergentMind/nix-secrets-reference) - Helpful secret tips and nix-secrets + sops-nix deployment inspiration.
- [eisfunke's NixOS](https://git.eisfunke.com/config/nixos) and [sophie raven's dotfiles-nix](https://git.catgirl.cloud/999eagle/dotfiles-nix) - For their extremely helpful server configurations
