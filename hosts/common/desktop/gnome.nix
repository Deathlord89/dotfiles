{ pkgs, ... }:
{
  services = {
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    # Mount, trash, and other functionalities
    gvfs.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      gnome-tweaks
      pinentry-gnome3
    ];

    #Excluding some GNOME applications from the default install
    gnome.excludePackages = with pkgs; [
      #evince # document viewer
      decibels # audio player
      epiphany # web browser
      geary # email reader
      gnome-music # audio player
      gnome-tour
      snapshot # camera
      totem # video player
    ];
  };
  programs = {
    dconf.enable = true;
  };
}
