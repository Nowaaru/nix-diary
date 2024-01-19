{ pkgs, nix-colors, ... }: 
    let
        inherit (pkgs) lib;

        mode = "dark";
        theme = (import ../themes {
            inherit pkgs nix-colors;
            kind = mode;
        }).cat-anime-girl;

        ###############################################

        workspaces = import ./workspaces.nix;
        bindings = import ./bindings.nix {
            inherit theme;
        };
        monitors = import ./monitors.nix;
        tearing = import ./tearing.nix;
        util = import ./util.nix { inherit pkgs lib; };
        vars = import ./vars.nix { 
            inherit theme pkgs;
        };
    in {
        inherit theme;
        hypr = {
            inherit (vars) input general decoration animations;
            inherit (workspaces) workspace;
            inherit (bindings) bind bindm;
            inherit (monitors) monitor;
            
            # Some default env vars.
            env = [ 
                "XCURSOR_SIZE,24"
            ] ++ tearing.env;

            windowrulev2 = [
                # Example windowrule v1
                # windowrule = float, ^(kitty)$

                # Example windowrule v2
                # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

                "nomaximizerequest, class:(.*)" # You'll probably like this.

                # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            ] ++ tearing.windowrulev2;

            layerrule = [
                "blur, eww-blur"
                "ignorealpha 0.3, eww-blur"
            ];

            # Stuff to run every reload.
            exec = [
                "eww daemon"
            ];

            # Background manager.
            exec-once = [
                "swww init"
                "hyprdim"
                "xrandr --output XWAYLAND0"
                "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
                (util.str.applySwayTheme theme)
            ] ++ [
                "dunst"
            ];
        };
    }
