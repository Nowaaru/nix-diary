{ config, lib, ... }:
let
  cfg = config.programs.plasma;
in with lib; {
  imports = [];

  options.programs.plasma = with types; {
    globalThemes = mkOption {
        type = attrsOf (oneOf [ package string ]);
        description = "attribute set of packages to be extracted into '~/.local/share/plasma'.";
        default = {};
    };
  };

  config = mkIf cfg.enable {
      home.file = if (builtins.hasAttr "globalThemes" cfg) then ((foldlAttrs (a: k: v: a // {
        ${k} = {
          enable = true;
          recursive = true;
          target = ".local/share/plasma";
          source = builtins.toString v;
        };
      })) {} cfg.globalThemes) else {};
  };
}
