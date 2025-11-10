{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.optional.productivity.latex;

  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-medium
      adjustbox # macros to adjust boxed content
      biber # bibliography
      biblatex # bibliography
      chngcntr # continuous numbering of footnotes
      cleveref # intelligent cross-referencing
      enumitem # customizable enumerates/itemizes
      footmisc # a range of footnote options
      glossaries # create glossaries and lists of acronyms
      hyphenat # locale settings
      makecell # tabular column heads and multi-line cells
      multirow # merge multiple table rows
      relsize # set font size relatively
      tocloft # control table of contents
      todonotes # marking things to do
      ;
  };
in
{
  options.optional.productivity.latex = {
    enable = lib.mkEnableOption "enable latex";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tex
      texstudio
    ];
  };
}
