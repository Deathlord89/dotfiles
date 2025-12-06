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
      decibels # audio player
      epiphany # web browser
      geary # email reader
      gnome-music # audio player
      gnome-text-editor # editor
      gnome-tour
      showtime # video player
      snapshot # camera
      totem # video player
      yelp # help viewer
    ];
  };
  programs = {
    dconf.enable = true;
  };
}
