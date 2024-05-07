lib:
lib.attrsets.foldlAttrs (
  acc: k: _:
    acc
    // {
      ${lib.strings.removeSuffix ".nix" k} = import (./. + "/${k}") lib;
    }
) {} (
  lib.attrsets.filterAttrs (
    k: v: v != "directory" && k != "default.nix"
  ) (builtins.readDir ./.)
)
