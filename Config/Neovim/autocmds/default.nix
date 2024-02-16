{
  lib,
  dag,
}: let
  selfTrace = w:
    builtins.trace (builtins.toJSON w) w;

  autocmdsDir = ./.;
in
  with lib.attrsets;
    selfTrace (foldlAttrs (
        a: k: v:
          if (hasAttrByPath [k] a)
          then abort "autocommand ${k} already exists"
          else (a // setAttrByPath [k] (dag.entryAnywhere (builtins.readFile "${autocmdsDir}/${k}")))
      ) {}
      (filterAttrs
        (n: v: v == "regular" && (lib.strings.hasSuffix ".lua" n))
        (builtins.readDir autocmdsDir)))
