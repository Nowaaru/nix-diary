{
  lib,
  config,
  inputs,
  ...
} @ args: let
  inherit (lib) strings attrsets;

  directoryPredicate = dir:
    attrsets.foldlAttrs (
      acc: filename: type: let
        pureName = strings.removeSuffix ".nix" filename;
      in
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
    ) {}
    (builtins.readDir dir);

  mergePredicate = dir: k: v: (
    if v == "directory"
    # TODO: if its a directory
    # then run mergepredicate on the builtin files
    then directoryPredicate "${dir}/${k}"
    else import "${dir}/${k}"
  );
in
  directoryPredicate (inputs.self + /programs)
