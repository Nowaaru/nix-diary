{lib, ...} @ args:
lib.attrsets.foldlAttrs (
  acc: k: v:
    acc
    // {
      ${lib.strings.removeSuffix ".nix" k} = import v args;
    }
) {} (
  lib.attrsets.filterAttrs (
    k: v: v == "directory" && k != "default.nix"
  ) (builtins.readDir ./.)
)
