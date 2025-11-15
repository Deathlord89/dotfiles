{
  desktop,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (./. + "/${desktop}.nix")
    ./25.05-compat.nix

    ../hardware/printer.nix
  ];

  # Quiet boot with plymouth - supports LUKS passphrase entry if needed
  boot = {
    plymouth.enable = true;
    kernelParams = [
      "boot.shell_on_fail"
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  hardware.graphics.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = lib.mkDefault false;
    # Exclude XTerm
    excludePackages = [ pkgs.xterm ];
    # Configure keymap in X11
    xkb = {
      layout = "de";
      variant = "";
    };
  };

  environment = {
    variables.NIXOS_OZONE_WL = "1";
  };

  programs = {
    firefox = {
      enable = true; # Install firefox.
      languagePacks = [
        "de"
        "en-US"
      ];
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;
        DisablePocket = true;
        SearchBar = "unified";
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };

        # ---- EXTENSIONS ----
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installe
        ExtensionSettings =
          with builtins;
          let
            extension = shortId: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortId}/latest.xpi";
                installation_mode = "force_installed";
              };
            };
          in
          listToAttrs [
            (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
            (extension "multi-account-containers" "@testpilot-containers")
            (extension "sponsorblock" "sponsorBlocker@ajay.app")
            (extension "tabliss" "extension@tabliss.io")
            (extension "ublock-origin" "uBlock0@raymondhill.net")
          ];

        "*".installation_mode = "allowed";
      };
    };
  };
}
