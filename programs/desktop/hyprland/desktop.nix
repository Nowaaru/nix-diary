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

  hyprPackages = inputs.hyprland.packages.${pkgs.system};
in {
  xdg.portal = {
    configPackages = [
      hyprPackages.hyprland
    ];

    extraPortals = [
      hyprPackages.xdg-desktop-portal-hyprland
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    package = hyprPackages.hyprland;
    settings = hypr-config.hypr;

    sourceFirst = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };
  };

  home = {
    packages = with pkgs; [
      inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      inputs.hyprcursor.packages.${pkgs.system}.hyprcursor
      hyprdim
      swww

      # utilities
      font-awesome
    ];

    activation = {
      hyprland_reload =
        lib.hm.dag.entryAfter ["writeBoundary"] (ifHyprland "${hyprPackages.hyprland}/bin/hyprctl reload");
    };
  };
}
