{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      editor = {
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        inline-diagnostics = {
          cursor-line = "error";
        };
      };
    };
    languages.language = [
      {
        name = "markdown";
        auto-format = true;
        language-servers = [
          "marksman"
          "ltex-ls-plus"
        ];
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
    ];
    extraPackages = with pkgs; [
      # Markdown
      marksman
      ltex-ls-plus

      # Nix
      nixd
      nixfmt
    ];
  };
}
