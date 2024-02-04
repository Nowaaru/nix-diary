{
  pkgs,
  lib,
  nix-colors,
  inputs,
  ...
}: let
  hypr-config = import ./conf {
    inherit pkgs nix-colors;
  };

  util = import ./conf/util.nix {
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
    ./sys.nix
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
      xdg-desktop-portal-hyprland
      xwaylandvideobridge
      wlr-randr

      ps
    ];

    activation = {
      hyprland_reload =
        lib.hm.dag.entryAfter ["writeBoundary"] (ifHyprland "${pkgs.hyprland}/bin/hyprctl reload");
    };

    file = {
      ".config/eww" = {
        enable = selfTrace (lib.attrsets.hasAttrByPath ["theme" "widgets"] hypr-config);
        source = hypr-config.theme.widgets;
      };
    };
  };
}
