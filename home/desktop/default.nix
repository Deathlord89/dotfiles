{
  desktop,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./core
  ]
  ++ lib.optional (builtins.pathExists (./. + "/${desktop}")) ./${desktop};

  home.packages = with pkgs; [
    appimage-run
    discord
    mediainfo
    mediainfo-gui
    qownnotes
    thunderbird
    zotero
  ];

}
