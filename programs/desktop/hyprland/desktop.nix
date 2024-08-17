{
  pkgs,
  lib,
  configure,
  inputs,
  ...
}: let
  hypr-config = configure "hyprland";

  ifHyprland = then-what: ''
    if [ -n "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ]; then
      ${then-what}
    fi
  '';
in {
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
      inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
      hyprdim
      swww

      # sway
      swayidle
      swaylock-effects

      # utilities
      font-awesome
      wlogout
    ];

    activation = {
      hyprland_reload =
        lib.hm.dag.entryAfter ["writeBoundary"] (ifHyprland "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl reload");
    };
  };
}
