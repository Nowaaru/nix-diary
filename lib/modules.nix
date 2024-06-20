lib: let
  inherit (lib) strings attrsets;

  directoryPredicate = dir:
    attrsets.foldlAttrs (
      acc: filename: _type: let
        pureName = strings.removeSuffix ".nix" filename;
      in
        acc
        // {
          ${pureName} = "${dir}/${filename}";
        }
    ) {}
    (builtins.readDir dir);
in {
  mkModules = directoryPredicate;
}
