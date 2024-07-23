{
  pkgs,
  lib,
  # nix-colors,
  configure,
  inputs,
  ...
}: let
  # flakeRoot = inputs.self;
  # configRoot = "${flakeRoot}/cfg/hyprland";

  # hypr-config = import configRoot {
  #   inherit pkgs nix-colors;
  # };

  hypr-config = configure "hyprland";

  # util = import "${configRoot}/util.nix" {
  #   inherit pkgs lib;
  # };

  ifHyprland = then-what: ''
    if [ -n "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ]; then
      ${then-what}
    fi
  '';
in {
  imports = [
    ./fuzzel.nix
    ./eww.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = hypr-config.hypr;
  };

  home = {
    packages = with pkgs; [
      # dependencies 'n stuff.
      xwaylandvideobridge
      wlr-randr

      ps

      # hypr
      hyprpicker
      hyprdim
      swww

      # sway
      swayidle
      swaylock-effects

      # eyecandy
      dunst

      # utilities
      font-awesome
      wlogout
    ];

    activation = {
      hyprland_reload =
        lib.hm.dag.entryAfter ["writeBoundary"] (ifHyprland "${pkgs.hyprland}/bin/hyprctl reload");
    };

    file = {
      ".config/eww" = {
        enable = lib.attrsets.hasAttrByPath ["theme" "widgets"] hypr-config;
        source = hypr-config.theme.widgets;
        recursive = lib.mkForce true;
      };
    };
  };
}
