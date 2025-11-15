# https://github.com/gorschu/nix-config-blueprint/blob/main/modules/nixos/services-cups.nix
{
  lib,
  pkgs,
  ...
}:
{
  # Enable CUPS to print documents
  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = with pkgs; [
        cups-browsed
        cups-filters
        epson-escpr2
      ];
    };

    # Enable autodiscovery of network printers
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  hardware =
    let
      epsonWF3820Ipp = "EPSON_WF_3820_Series";
    in
    {
      printers = {
        ensureDefaultPrinter = epsonWF3820Ipp;
        ensurePrinters = [
          {
            name = epsonWF3820Ipp;
            description = lib.replaceStrings [ "_" ] [ " " ] epsonWF3820Ipp;
            location = "Home Office";
            deviceUri = "ipps://192.168.10:631/ipp/print";
            model = "epson-inkjet-printer-escpr2/Epson-WF-3820_Series-epson-escpr2-en.ppd";
            ppdOptions = {
              PageSize = "A4";
            };
          }
        ];
      };
      sane = {
        enable = true;
        extraBackends = [
          pkgs.epson-escpr2
        ];
      };
    };
}
