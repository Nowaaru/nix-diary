{
  lib,
  inputs,
} @ args: let
  inherit (lib) strings attrsets;

  directoryPredicate = dir:
    attrsets.foldlAttrs (
      acc: filename: type:
        acc
        // {
          ${(strings.removeSuffix ".nix" filename)} =
            if type == "directory"
            then (directoryPredicate "${dir}/${filename}")
            else
              (mergePredicate dir (
                  if filename == "default"
                  then "all"
                  else filename
                )
                type);
        }
    ) {} (attrsets.filterAttrs (filename: type: type == "directory" || filename != "default.nix") (builtins.readDir dir));

  mergePredicate = dir: k: v: (
    if v == "directory"
    # TODO: if its a directory
    # then run mergepredicate on the builtin files
    then directoryPredicate "${dir}/${k}"
    else (import "${dir}/${k}" args)
  );
in
  directoryPredicate (inputs.self + /programs)
