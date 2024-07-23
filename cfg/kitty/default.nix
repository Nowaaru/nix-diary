{ lib, ... }: let 
  fontName = "JetBrainsMono Nerd Font Mono";
in {
  settings = {
    disable_ligatures = "cursor";
    font_family = lib.mkDefault fontName;
    font_features = "${ fontName } +liga";
  };
}
