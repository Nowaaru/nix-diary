{
  pkgs,
  nix-colors,
  inputs,
  ...
}: let
  themes = import (inputs.self + /cfg/themes) {inherit pkgs nix-colors;};
  configFile = import ./config.nix;
in {
  inherit configFile;
  enable = true;

  powerdevil = {
    AC = {
      powerProfile = "performance";
      displayBrightness = 100;

      dimDisplay = {
        enable = true;
        idleTimeout = 300;
      };
    };
  };

  workspace = {
    clickItemTo = "select";
    lookAndFeel = "org.kde.breezedark.desktop";
    iconTheme = "Papirus-Dark";
    wallpaper = themes.mountain-view.background;

    cursor.theme = "Bibata-Modern-Ice";
  };

  hotkeys.commands."launch-kitty" = {
    name = "Launch Kitty";
    key = "Meta+Q";
    command = "kitty";
  };

  input.mice = [
    {
      enable = true;

      acceleration = 0.5;
      accelerationProfile = "none";

      leftHanded = false;
      middleButtonEmulation = false;
      name = "Logitech G Pro";

      vendorId = "046d";
      productId = "c539";
    }
  ];
}
