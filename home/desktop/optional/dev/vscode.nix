{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.dev.vscode;
in
{
  options.optional.dev.vscode = {
    enable = lib.mkEnableOption "Enable vscode editor";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          shd101wyy.markdown-preview-enhanced
          naumovs.color-highlight
          ms-ceintl.vscode-language-pack-de
          mkhl.direnv
          yzhang.markdown-all-in-one
          jnoortheen.nix-ide
          bbenoist.nix
        ];
        userSettings = {
          "git.enableCommitSigning" = true;
          "git.confirmSync" = false; # Do not ask for confirmation when syncing
          "git.autofetch" = true; # Periodically fetch from remotes
          "explorer.confirmDelete" = false;
          "editor.formatOnSave" = true;
          "editor.formatOnPaste" = true;
          "direnv.restart.automatic" = true; # Automatically restart direnv if .envrc changes
          "editor.formatOnType" = true;

          # --- Nix LSP ---
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
          "nix.serverSettings" = {
            "nixd" = {
              "formatting" = {
                "command" = [ "${pkgs.nixfmt}/bin/nixfmt" ];
              };
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      # Nix IDE
      nixd
    ];
  };
}
