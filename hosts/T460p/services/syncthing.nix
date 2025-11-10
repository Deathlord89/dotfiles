{
  # Enable syncthing globaly
  optional = {
    syncthing.enable = true;
  };

  # Host specific eettings
  services = {
    syncthing = {
      settings = {
        folders = {
          "Default Folder" = {
            id = "default";
            path = "/home/ma-gerbig/Sync";
            devices = [
              "NAZGUL"
              "NitroX"
              "steamdeck"
            ];
          };
        };
      };
    };
  };
}
