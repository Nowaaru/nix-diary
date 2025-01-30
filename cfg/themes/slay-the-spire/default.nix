{
  colors-lib,
  kind ? "dark",
  ...
}: rec {
  name = "Slay the Spire";
  author = "Nowaaru";

  background = ./spire.jpg;
  inherit
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    })
    palette
    ;
}
