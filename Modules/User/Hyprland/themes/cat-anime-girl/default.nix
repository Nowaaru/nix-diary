{
  lib,
  colors-lib,
  kind ? "light",
  ...
}: let
  background = ./cat-anime-girl.png;
  selfTrace = what:
    builtins.trace what what;
in {
  name = "Cat Anime Girl";
  author = "Nowaaru";
  widgets = ./eww;

  programs = {
    dunst = lib.mkForce (import ./dunst.nix);
  };

  colors =
    (colors-lib.colorSchemeFromPicture {
      path = background;
      inherit kind;
    })
    .palette;

  inherit background;
}
