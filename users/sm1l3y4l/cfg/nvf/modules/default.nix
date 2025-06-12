{
  lib,
  dir ? ./.,
  ...
}:
with lib.attrsets;
  lib.mkMerge (foldlAttrs (acc: key: value:
    acc
    ++ (
      let
        importLibIfFunction = imported:
          if (builtins.isFunction imported)
          then (imported lib)
          else imported;
        nextDir = "${dir}/${key}";
        imported = import nextDir;
      in [
        (
          if (value != "directory")
          then importLibIfFunction imported
          else
            (
              if (builtins.pathExists "${nextDir}/default.nix")
              then importLibIfFunction (import "${nextDir}/default.nix")
              else
                import ./. {
                  inherit lib;
                  dir = nextDir;
                }
            )
        )
      ]
    )) [] (filterAttrsRecursive (key: _: key != "default.nix") (builtins.readDir dir)))
