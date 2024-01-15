{ lib, ... }: 
    let
        bindings = import ./bindings.nix;
        monitors = import ./monitors.nix;
        tearing = import ./tearing.nix;
        vars = import ./vars { inherit lib; };
    in {
        inherit (vars) input general decoration animations;
        inherit (bindings) bind bindm;
        inherit (monitors) monitor;

        # Some default env vars.
        env = [ 
            "XCURSOR_SIZE,24"
        ] ++ lib.tearing.env;

        # Background manager.
        exec-once = [
            "swww init"
            "hyprdim"
            "xrandr --output XWAYLAND0"
            "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        ];
    }
