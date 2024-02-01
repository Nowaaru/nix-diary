{
  pkgs,
  nix-colors,
  kind ? "light",
  ...
}:
with pkgs.lib;
# first, verify if the /default
# directory exists.
#
# don't want to implement
# some goofy stuff when
# i can just error out early lol
  if (asserts.assertMsg (builtins.pathExists ./default) "directory '${builtins.toString ./.}default/' does not exist")
  then
    attrsets.concatMapAttrs (
      name: value:
        if (value == "directory")
        then {
          "${name}" = import ./${name} {
            inherit (pkgs) lib;
            inherit kind nix-colors;
            colors-lib = nix-colors.lib.contrib {
              inherit pkgs;
            };
          };
        }
        else {}
    ) (builtins.readDir ./.)
  else {}
