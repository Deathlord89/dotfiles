{ pkgs, config, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users.ma-gerbig = {
    description = "Marc-André Gerbig";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "audio"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "gamemode"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
    ];

    packages = [ pkgs.home-manager ];
  };
}
