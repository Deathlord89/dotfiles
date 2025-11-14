# Reference:
# https://rzetterberg.github.io/yubikey-gpg-nixos.html
{
  lib,
  pkgs,
  sopsFolder,
  ...
}:
let
  u2fFile =
    if pkgs.stdenv.isLinux then
      "/home/ma-gerbig/.config/Yubico/u2f_keys"
    else
      "/Users/ma-gerbig/.config/Yubico/u2f_keys";
in
{
  # Sink this option when under 25.11
  options.services.gnome = lib.optionalAttrs (lib.versionOlder lib.trivial.release "25.11") {
    gcr-ssh-agent.enable = lib.mkSinkUndeclaredOptions { };
  };

  config = {
    sops.secrets."ma-gerbig/yubico_y2f_keys" = {
      sopsFile = "${sopsFolder}/shared.yaml";
      path = "${u2fFile}";
      owner = "ma-gerbig";
    };

    programs.ssh.startAgent = lib.mkForce false;

    # https://discourse.nixos.org/t/gpg-smartcard-for-ssh/33689
    hardware.gpgSmartcards.enable = true; # for yubikey

    environment.systemPackages = with pkgs; [
      yubikey-manager # cli-based authenticator tool
      pam_u2f # yubikey with sudo
    ];

    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      u2f = {
        enable = true;
        settings = {
          cue = true; # tells the user to press the button
          authFile = "${u2fFile}";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };

    services = {
      gnome.gcr-ssh-agent.enable = lib.mkForce false;
      pcscd.enable = true;
      udev.packages = with pkgs; [
        yubikey-personalization # End of Life at 2026-02-19
      ];
    };
  };
}
