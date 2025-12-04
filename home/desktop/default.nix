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
    bitwarden-desktop
    discord
    logseq
    mediainfo
    mediainfo-gui
    nextcloud-client
    portfolio
    qownnotes
    zotero
  ];

}
