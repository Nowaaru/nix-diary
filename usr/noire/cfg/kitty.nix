{ pkgs, lib }: 
let
  fontName = "VictorMonoNFM-Semibold";
in 
{
  themeFile = "kanagawabones";
  shellIntegration.enableFishIntegration = true;

  settings = {
    disable_ligatures = "cursor";
    font_family = lib.mkDefault fontName;
    font_features = "${ fontName } +liga";
  };

  font = {
    name = lib.mkForce fontName;
    package = lib.mkForce pkgs.nerdfonts; # (pkgs.nerdfonts.override {fonts = [ fontName ];});
  };
}

