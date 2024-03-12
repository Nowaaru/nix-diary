{
  colors-lib,
  kind ? "light",
  ...
}: rec {
  name = "Ocean View";
  author = "Nowaaru";

  background = ./ocean.png;
  inherit
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    })
    palette
    ;
}
