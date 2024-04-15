let
  themes = import ../themes;
in {
  enable = true;

  workspace = {
    clickItemTo = "select";
    lookAndFeel = "org.kde.breezedark.desktop";
    cursorTheme = "Bibata-Modern-Ice";
    iconTheme = "Papirus-Dark";
    wallpaper = themes.default.background;
  };

  hotkeys.commands."launch-kitty" = {
    name = "Launch Kitty";
    key = "Meta+Alt+K";
    command = "kitty";
  };
}
