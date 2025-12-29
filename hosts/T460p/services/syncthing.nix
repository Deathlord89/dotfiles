{
  # Enable syncthing globaly
  optional = {
    syncthing.enable = true;
  };

  # Host specific settings
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
