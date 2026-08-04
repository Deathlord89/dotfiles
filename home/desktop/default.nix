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
    unstable.bitwarden-desktop
    discord
    feishin
    libreoffice
    # (logseq.override {
    #   electron_39 = electron_40;
    # })
    mediainfo
    mediainfo-gui
    nextcloud-client
    qownnotes
    zotero
  ];

}
