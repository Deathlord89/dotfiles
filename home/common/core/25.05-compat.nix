{
  lib,
  ...
}:
{
  # Backward-compat for 25.05
  imports = lib.optionals (lib.versionOlder lib.version "25.11pre") [
    (lib.mkAliasOptionModule
      [ "programs" "git" "settings" "user" "name" ]
      [ "programs" "git" "userName" ]
    )
    (lib.mkAliasOptionModule
      [ "programs" "git" "settings" "user" "email" ]
      [ "programs" "git" "userEmail" ]
    )
  ];
}
