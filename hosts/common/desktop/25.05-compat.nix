{
  lib,
  ...
}:
{
  # Backward-compat for 25.05
  imports = lib.optionals (lib.versionOlder lib.version "25.11pre") [
    (lib.mkAliasOptionModule
      [ "services" "displayManager" "gdm" "enable" ]
      [ "services" "xserver" "displayManager" "gdm" "enable" ]
    )
    (lib.mkAliasOptionModule
      [ "services" "desktopManager" "gnome" "enable" ]
      [ "services" "xserver" "desktopManager" "gnome" "enable" ]
    )
  ];
}
