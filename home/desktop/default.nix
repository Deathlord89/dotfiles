{
  desktop,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./core
    ./optional
  ]
  ++ lib.optional (builtins.pathExists (./. + "/${desktop}")) ./${desktop};

  home.packages = with pkgs; [
    appimage-run
    discord
    mediainfo
    mediainfo-gui
    qownnotes
    zotero
    bitwarden-desktop
    nextcloud-client
  ];

}
