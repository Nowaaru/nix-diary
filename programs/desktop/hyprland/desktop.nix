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
  hyprland = hyprPackages.hyprland.overrideAttrs (prev: {
    buildInputs = lib.lists.foldl' (a: v:
      if v.pname == "wayland-protocols"
      then a ++ (lib.singleton (pkgs.callPackage (inputs.self + /packages/wayland-protocols.nix) {}))
      else a ++ (lib.singleton v)) []
    prev.buildInputs;
  });
in {
  xdg.portal = {
    enable = true;
    configPackages = [
      hyprland
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [];
    package = hyprland;
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
        lib.hm.dag.entryAfter ["writeBoundary"] (ifHyprland "${hyprland}/bin/hyprctl reload");
    };
  };
}
