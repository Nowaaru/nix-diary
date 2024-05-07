{
  lib,
  inputs,
  ...
} @ args: let
  inherit (lib) strings attrsets;
  selfTrace = w: builtins.trace w w;

  directoryPredicate = dir:
    attrsets.foldlAttrs (
      acc: filename: type: let
        pureName = strings.removeSuffix ".nix" filename;
      in
        if (acc ? "only")
        then acc
        else
          (
            if pureName != "only"
            then
              acc
              // {
                ${
                  if filename == "default.nix"
                  then "all"
                  else pureName
                } =
                  if type == "directory"
                  then (directoryPredicate "${dir}/${filename}")
                  else (mergePredicate dir filename type);
              }
            else acc
          )
    ) {}
    (builtins.readDir dir);

  mergePredicate = dir: k: v: (
    if v == "directory"
    # TODO: if its a directory
    # then run mergepredicate on the builtin files
    then directoryPredicate "${dir}/${k}"
    else lib.gamindustri.meta.withInputs "${dir}/${k}" args
  );
in
  directoryPredicate (inputs.self + /programs)
