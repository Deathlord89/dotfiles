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
              "NAZGUL"
              "steamdeck"
              "T460p"
            ];
          };

          "Elder Scrolls Online - AddOns" = {
            id = "eso_addons";
            path = "/home/ma-gerbig/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/Documents/Elder Scrolls Online/live/AddOns";
            devices = [
              "NAZGUL"
              "steamdeck"
            ];
          };
          "Elder Scrolls Online - SavedVariables" = {
            id = "eso_saved";
            path = "/home/ma-gerbig/.steam/steam/steamapps/compatdata/306130/pfx/drive_c/users/steamuser/Documents/Elder Scrolls Online/live/SavedVariables";
            devices = [
              "NAZGUL"
              "steamdeck"
            ];
          };

          "Farming Simulator 25 - Mods" = {
            id = "fs25_mods";
            path = "/home/ma-gerbig/.steam/steam/steamapps/compatdata/2300320/pfx/drive_c/users/steamuser/Documents/My Games/FarmingSimulator2025/mods";
            devices = [
              "NAZGUL"
              "steamdeck"
            ];
          };
        };
      };
    };
  };
}
