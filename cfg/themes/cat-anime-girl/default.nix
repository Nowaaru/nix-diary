{
  lib,
  colors-lib,
  kind ? "light",
  ...
}: rec {
  name = "Cat Anime Girl";
  author = "Nowaaru";
  widgets = ./eww;
  background = ./cat-anime-girl.png;

  programs = {
    dunst = lib.mkForce (import ./dunst.nix);
  };

  colors =
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    })
    .palette;
}
