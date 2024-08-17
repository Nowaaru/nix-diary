{ pkgs, ... }: {
  mkCursor = cursor-name: fetchzip-attrs: {
    home.file = let
      cursor = pkgs.fetchzip fetchzip-attrs;
    in {
      "hyprland-${cursor-name}" = {
        enable = true;
        target = ".local/share/icons/${cursor-name}";
        source = cursor;
      };
    };
  };
}
