{
  config,
  lib,
  ...
}: let
  cfg = config.programs.plasma;
in
  with lib; {
    imports = [];

    options.programs.plasma = with types; {
      globalThemes = mkOption {
        type = attrsOf (oneOf [package string]);
        description = "attribute set of packages to be extracted into '~/.local/share/plasma'.";
        default = {};
      };

      iconThemes = mkOption {
        type = attrsOf (oneOf [package string]);
        description = "attribute set of packages to be extracted into '~/.local/share/icons'.";
        default = {};
      };

      cursorThemes = mkOption {
        type = attrsOf (oneOf [package string]);
        description = "attribute set of packages to be extracted into '~/.local/icons'.";
        default = {};
      };
    };

    config = mkIf cfg.enable {
      home.file =
        (foldlAttrs (a: k: v:
          a
          // {
            "plasma-icon-theme-${k}" = {
              enable = true;
              recursive = true;
              target = ".local/share/icons";
              source = builtins.toString v;
            };
          }) {}
        cfg.iconThemes)
        // (foldlAttrs (a: k: v:
          a
          // {
            "plasma-global-theme-${k}" = {
              enable = true;
              recursive = true;
              target = ".local/share/plasma";
              source = builtins.toString v;
            };
          }) {}
        cfg.globalThemes);
    };
  }
