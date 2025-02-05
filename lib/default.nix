{lib, ...} @ inputs: let
  specialLibraries = ["users.nix" "hypr.nix" "meta.nix" "images.nix"];
  metaFunctions = import ./meta.nix inputs;
in
  (lib.attrsets.foldlAttrs (
      acc: k: _:
        acc
        // (let
          importPath = ./. + "/${k}";
        in {
          ${lib.strings.removeSuffix ".nix" k} =
            if (builtins.elem k specialLibraries)
            then
              metaFunctions.withInputs importPath (inputs
                // {
                  lib =
                    lib
                    // metaFunctions;
                })
            else import importPath lib;
        })
    ) {} (
      lib.attrsets.filterAttrs (
        k: v: v != "directory" && !(builtins.elem k ["default.nix"])
      ) (builtins.readDir ./.)
    ))
  // metaFunctions
