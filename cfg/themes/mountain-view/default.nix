{
  colors-lib,
  kind ? "dark",
  ...
}: rec {
  name = "Mountain View";
  author = "Nowaaru";
  widgets = ./eww;

  background = ./download.png;
  colors =
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    }).palette;
}
