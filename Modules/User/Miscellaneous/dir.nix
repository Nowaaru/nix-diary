# Initialize XDG environment variables that aren't
# set up on Hyprland.
_: {
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";

      publicShare = "$HOME/.public";
      templates = "$HOME/.templates";
    };
  };
}
