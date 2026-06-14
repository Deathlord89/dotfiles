{
  config,
  desktop,
  hostname,
  inputs,
  lib,
  libx,
  pkgs,
  sopsFolder,
  stateVersion,
  username,
  ...
}:
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
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "networkmanager"
      "gamemode"
      "libvirtd"
    ];

    hashedPasswordFile = config.sops.secrets."ma-gerbig/password".path;

    openssh.authorizedKeys.keys = lib.splitString "\n" (
      builtins.readFile (libx.relativeToRoot "home/users/ma-gerbig/ssh.pub")
    );

    packages = [ pkgs.home-manager ];
  };

  sops.secrets = {
    "ma-gerbig/password" = {
      neededForUsers = true;
      sopsFile = "${sopsFolder}/shared.yaml";
    };
  };

  home-manager = {
    users.ma-gerbig = import ../../../../home;
    extraSpecialArgs = {
      inherit
        desktop
        hostname
        inputs
        libx
        stateVersion
        username
        ;
    };
  };

}
