{lib, ...} @ inputs:
lib.attrsets.foldlAttrs (
  acc: k: _:
    acc
    // {
      ${lib.strings.removeSuffix ".nix" k} = import (./. + "/${k}") (
        if (k == "meta.nix")
        then inputs
        else lib
      );
    }
) {} (
  lib.attrsets.filterAttrs (
    k: v: v != "directory" && k != "default.nix"
  ) (builtins.readDir ./.)
)
