{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Marc-André Gerbig";
        email = "marc.gerbig@gmail.com";
      };
    };
    signing = {
      signByDefault = true;
      key = "39CB130C67B92382";
    };
  };
}
