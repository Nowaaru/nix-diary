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
  inherit (import ./icons { inherit (pkgs) stdenv lib; inherit inputs; }) iconThemes;
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
    iconTheme = "Tela-dracula-dark";
    wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Mountain/contents/images_dark/5120x2880.png";

    cursor.theme = "Colloid-Pastel Dark";
  };

  hotkeys = {
    commands = {
      "launch-kitty" = {
        name = "Launch Kitty";
        key = "Meta+Q";
        command = "kitty";
        comment = "Open the KiTTY terminal.";
      };

      "brave-browser" = {
        name = "Open Browser";
        key = "Meta+B";
        command = "xdg-open https://search.brave.com";
      };
    };
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
