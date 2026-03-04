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
    bitwarden-desktop
    discord
    feishin
    logseq
    mediainfo
    mediainfo-gui
    nextcloud-client
    portfolio
    qownnotes
    zotero
  ];

}
