{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.productivity.vivaldi;
  vivaldi-codec = pkgs.vivaldi.override {
    proprietaryCodecs = true;
    enableWidevine = true;
  };
in
{
  options.optional.productivity.vivaldi = {
    enable = lib.mkEnableOption "enable vivaldi browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ vivaldi-codec ];
  };
}
