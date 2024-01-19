{ colors-lib, kind ? "light", ... }:
    rec {
        name = "Cat Anime Girl";
        author = "Nowaaru";

        background = ./cat-anime-girl.png;
        widgets = ./eww;

        inherit (colors-lib.colorSchemeFromPicture {
            path = background;
            inherit kind;
        }) colors;
    }
