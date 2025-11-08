{
  config,
  libx,
  pkgs,
  ...
}:
{
  programs = {
    gpg = {
      enable = true;
      publicKeys = [
        {
          source = libx.relativeToRoot "home/users/ma-gerbig/gpg.asc";
          trust = 5;
        }
      ];
      scdaemonSettings = {
        reader-port = "Yubico Yubi";
        disable-ccid = true;
      };
    };
  };

  services = {
    # Disable default ssh-agent
    ssh-agent.enable = false;

    # Enable gpg-agent.ssh
    gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableSshSupport = true;
      enableScDaemon = true;
      pinentry.package = if config.gtk.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-qt;
      defaultCacheTtl = 60;
      maxCacheTtlSsh = 120;
    };
  };
}
