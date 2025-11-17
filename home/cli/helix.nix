{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
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
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
      }
    ];
    extraPackages = with pkgs; [
      # Markdown
      marksman
      ltex-ls-plus

      # Nix
      nixd
      nixfmt-rfc-style
    ];
  };
}
