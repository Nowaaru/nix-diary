{pkgs, ...}: {
  global = {
    follow = "keyboard";
    width = "(0, 300)";
    height = 50;
    dmenu = "${pkgs.fuzzel}/bin/fuzzel --dmenu dunst";
  };
}
