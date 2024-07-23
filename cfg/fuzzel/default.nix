{pkgs, ...}: {
  main = {
    terminal = "${pkgs.kitty}/bin/kitty";
    layer = "top";

    prompt = ''"  "'';
    dpi-aware = "no";
    font = "JetBrainsMono:weight=light";

    line-height = 17;
    image-size-ratio = 1;
    tabs = 4;
  };
}
