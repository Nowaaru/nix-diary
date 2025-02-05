{lib, ...} @ args:
with lib.fileset; {
  iconThemes =
    builtins.foldl'
    (acc: elem: acc // {${builtins.baseNameOf elem} = elem;}) {}
    (toList (fileFilter ({
      name,
      hasExt,
      ...
    }:
      (hasExt ".nix") && name != "default.nix")
    ./.));
}
