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
      # Bus 003 Device 005: ID 1532:00c1 Razer USA, Ltd Razer Viper V3 Pro
      acceleration = 0;
      accelerationProfile = "none";

      leftHanded = false;
      middleButtonEmulation = false;
      name = "Razer Viper V3 Pro";

      vendorId = "1532";
      productId = "00c1";
    }
  ];
}
