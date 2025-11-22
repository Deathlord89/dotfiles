{
  inputs,
  pkgs,
  ...
}:
let
  # Stolen from kira-bruneau https://github.com/kira-bruneau/nixos-config/blob/main/services/minecraft/AboveAndBeyond/default.nix
  modpack = pkgs.fetchzip {
    url = "https://downloads.gtnewhorizons.com/ServerPacks/GT_New_Horizons_2.7.1_Server_Java_17-21.zip";
    stripRoot = false;
    postFetch = ''
      cd "$out"
      rm -rf *.json changelog*.md eula.txt server.properties startserver*.bat startserver*.sh
      sed -i 's/B:chunk_claiming=false/B:chunk_claiming=true/g' serverutilities/serverutilities.cfg
    '';
    hash = "sha256-ivN/zMC7Y3Grqt4ve3ono2qa9SuB0XYdTad/JM5OWUg=";
  };
  minecraft-server = pkgs.writeShellScriptBin "minecraft-server" ''
    exec ${pkgs.jre_headless}/bin/java $@ @${modpack}/java9args.txt -jar ${modpack}/lwjgl3ify-forgePatches.jar nogui
  '';
in
{
  # Gregtech: New Horizons
  services.minecraft-servers.servers = {
    GT_NewHorizons = {
      enable = true;
      enableReload = true;
      autoStart = false;
      package = minecraft-server;
      jvmOpts = "-Xms8G -Xmx8G -Dfml.readTimeout=180";
      inherit (inputs.nix-secrets.minecraft.GT_NewHorizons) whitelist;
      inherit (inputs.nix-secrets.minecraft.GT_NewHorizons) operators;
      symlinks = {
        "libraries" = "${modpack}/libraries";
        "server-icon.png" = "${modpack}/server-icon.png";
        "serverutilities" = "${modpack}/serverutilities";
      };
      files = {
        "config" = "${modpack}/config";
        "config/JourneyMapServer/world.cfg" = {
          value = {
            "WorldID" = "41cc7803-260b-4cdd-894f-ab627f993045";
          };
          format = pkgs.formats.json { };
        };
        "mods" = "${modpack}/mods";
      };
      serverProperties = {
        allow-flight = true;
        announce-player-achievements = true;
        difficulty = 3;
        enable-command-block = true;
        level-name = "world";
        server-id = "8zc74rzc84";
        level-seed = -1941723784208994818;
        level-type = "rwg";
        max-build-height = 256;
        max-players = 5;
        motd = "\\u00a77GT: New Horizons\\u00a7r\\n\\u00a7bv2.7.1 \\u00a7e[Whitelist]";
        op-permission-level = 2;
        pvp = false;
        server-name = "GT: New Horizons Server";
        server-port = 25565;
        spawn-protection = 1;
        view-distance = 8;
        white-list = true;
      };
    };
  };
}
