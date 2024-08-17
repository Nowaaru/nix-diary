{
  pkgs,
  nix-colors,
  inputs,
  ...
}: let
  inherit (pkgs) lib;

  mode = "dark";
  theme =
    (import (inputs.self + /cfg/themes) {
      inherit pkgs nix-colors;
      kind = mode;
    })
    .mountain-view;

  ###############################################

  workspaces = import ./workspaces.nix;
  bindings = import ./bindings.nix {
    inherit theme;
  };
  monitors = import ./monitors.nix;
  tearing = import ./tearing.nix;
  util = import ./util.nix {inherit pkgs lib;};
  vars = import ./vars.nix {
    inherit theme pkgs;
  };
in {
  inherit theme;
  hypr = {
    inherit (vars) input general decoration animations debug;
    inherit (workspaces) workspace;
    inherit (bindings) bind bindm;
    inherit (monitors) monitor;

    # Some default env vars.
    env =
      [
        "XCURSOR_SIZE,24"
      ]
      ++ tearing.env;

    windowrulev2 =
      [
        # Example windowrule v1
        # windowrule = float, ^(kitty)$

        # Example windowrule v2
        # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

        # "nomaximizerequest, class:(.*)"  You'll probably like this.

        # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
      ]
      ++ tearing.windowrulev2;

    layerrule = [
      "blur, eww-blur"
      "ignorealpha 0.3, eww-blur"
    ];

    # Stuff to run every reload.
    exec = [
      # "eww open-many -c ~/.config/eww topbar sidebarf"
      (util.str.applySwayTheme theme)
    ];

    # Background manager.
    exec-once =
      [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "sww kill; wait $!; swww init"
        "hyprdim"
        "xrandr --output XWAYLAND0"

        "wl-paste -p --watch wl-copy -p ''" # disable primary buffer
        "wl-paste --type text --watch cliphist store" # Stores only text data
        "wl-paste --type image --watch cliphist store" # Stores only image data
      ];
  };
}
