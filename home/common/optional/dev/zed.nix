{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.dev.zed;
in
{
  options.optional.dev.zed = {
    enable = lib.mkEnableOption "Enable zed editor";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.unstable.zed-editor;
      # Use the name of a repository in https://github.com/zed-industries/extensions/tree/main/extensions
      extensions = [
        "git-firefly"
        "nix"
      ];
      extraPackages = with pkgs; [
        nil
        nixfmt-rfc-style
        package-version-server
      ];

      userSettings = {
        hour_format = "hour24";
        auto_update = false;
        load_direnv = "shell_hook";
        format_on_save = "on";
        minimap = {
          max_width_columns = 80;
          thumb = "always";
          show = "always";
        };
        scrollbar.show = "never";
        indent_guides = {
          enabled = true;
          coloring = "indent_aware";
        };
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
        };
        tabs = {
          git_status = true;
          file_icons = true;
        };
        inlay_hints = {
          enabled = true;
          show_type_hints = false;
          show_parameter_hints = true;
          show_other_hints = true;
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        lsp = {
          nil = {
            binary = {
              path_lookup = true;
            };
            settings = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };
      };
    };
  };
}
