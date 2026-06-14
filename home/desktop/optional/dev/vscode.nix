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
    programs.vscodium = {
      enable = true;
      package = pkgs.unstable.vscodium;
      profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
          jnoortheen.nix-ide
          mkhl.direnv
          ms-ceintl.vscode-language-pack-de
          naumovs.color-highlight
          shd101wyy.markdown-preview-enhanced
          yzhang.markdown-all-in-one
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
