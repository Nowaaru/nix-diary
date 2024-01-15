{ pkgs, nix-colors, ... }:  with pkgs.lib; 
    attrsets.concatMapAttrs (
            name: value: 
            if (value == "directory") then
            {
                "${name}" = import ./${name} {
                    nix-colors = nix-colors;
                    colors-lib = nix-colors.lib.contrib {
                            inherit pkgs;
                    };
                };
            }
            else ({})
        ) (builtins.readDir ./.)

