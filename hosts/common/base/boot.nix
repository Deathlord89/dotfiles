{
  # Systemd-Boot bootloader configuration
  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      timeout = 1;
    };

    consoleLogLevel = 0;
  };
}
