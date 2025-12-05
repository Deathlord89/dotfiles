{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Marc-André Gerbig";
        email = "marc.gerbig@gmail.com";
      };
      pretty = {
        line = "%C(auto)%h %<|(60,trunc)%s %C(green)%ad%C(auto)%d";
        detail = "%C(auto)%h %s%n  %C(yellow)by %C(blue)%an %C(magenta)<%ae> [%G?] %C(green)%ad%n %C(auto)%d%n";
      };
      diff = {
        compactionHeuristic = true;
        wordRegex = "[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+";
      };
    };
    signing = {
      signByDefault = true;
      key = "39CB130C67B92382";
    };
  };
}
