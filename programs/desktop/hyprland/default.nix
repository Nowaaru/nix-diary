{
  pkgs,
  lib,
  nix-colors,
  inputs,
  ...
}: let
  flakeRoot = inputs.self;
  configRoot = "${flakeRoot}/cfg/hyprland";

  hypr-config = import configRoot {
    inherit pkgs nix-colors;
  };

  util = import "${configRoot}/util.nix" {
    inherit pkgs lib;
  };

  ifHyprland = then-what: ''
    if [ -n "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ]; then
      ${then-what}
    fi
  '';

  ifHyprfish = then-what: ''
    if [ -n "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ] then
      ${then-what}
    end
  '';

  applySwayTheme = ''$DRY_RUN_CMD ${selfTrace (util.str.applySwayTheme hypr-config.theme)}'';

  selfTrace = t:
    builtins.trace t t;
in {
  imports = [
    ./fuzzel.nix
    ./eww.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = hypr-config.hypr;
  };

  programs.fish.loginShellInit = ifHyprfish ''
    $DRY_RUN_CMD ${selfTrace (util.str.applySwayTheme hypr-config.theme)}
  '';

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
        recursive = true;
        onChange = ''
          eww -c ~/.config/eww kill
        '';
      };
    };
  };
}
