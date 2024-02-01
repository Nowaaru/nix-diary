{
  colors-lib,
  kind ? "light",
  ...
}: rec {
  name = "NixOS Default";
  author = "Nowaaru";

  background = ./nix.png;
  inherit
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    })
    palette
    ;
}
