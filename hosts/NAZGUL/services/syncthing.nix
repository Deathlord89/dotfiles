{
  imports = [
    ../../common/optional/syncthing.nix
  ];

  services = {
    syncthing = {
      settings = {
        folders = {
          "Default Folder" = {
            id = "default";
            path = "/home/ma-gerbig/Sync";
            devices = [
              "NitroX"
              "steamdeck"
              "T460p"
            ];
          };

          "Elder Scrolls Online - AddOns" = {
            id = "eso_addons";
            path = "/home/ma-gerbig/syncthing/eso_addons";
            type = "receiveonly";
            devices = [
              "NitroX"
              "steamdeck"
            ];
          };
          "Elder Scrolls Online - SavedVariables" = {
            id = "eso_saved";
            path = "/home/ma-gerbig/syncthing/eso_saved";
            type = "receiveonly";
            devices = [
              "NitroX"
              "steamdeck"
            ];
          };

          "Farming Simulator 25 - Mods" = {
            id = "fs25_mods";
            path = "/home/ma-gerbig/syncthing/fs25_mods";
            type = "receiveonly";
            devices = [
              "NitroX"
              "steamdeck"
            ];
          };
        };
      };
    };
  };
}
