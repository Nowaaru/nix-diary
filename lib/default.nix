{
  lib,
  pkgs,
  ...
} @ inputs:
(lib.attrsets.foldlAttrs (
    acc: k: _:
      acc
      // {
        ${lib.strings.removeSuffix ".nix" k} = import (./. + "/${k}") (
          if (builtins.elem k ["meta.nix" "users.nix"])
          then inputs
          else lib
        );
      }
  ) {} (
    lib.attrsets.filterAttrs (
      k: v: v != "directory" && !(builtins.elem k ["default.nix" "lib.nix"])
    ) (builtins.readDir ./.)
  ))
// (import ./lib.nix lib)
