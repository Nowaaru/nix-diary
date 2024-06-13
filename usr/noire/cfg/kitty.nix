{pkgs}: {
  theme = "kanagawabones";
  shellIntegration.enableFishIntegration = true;

  font = {
    name = "SpaceMono";
    package = pkgs.nerdfonts.override {fonts = ["SpaceMono"];};
  };
}
