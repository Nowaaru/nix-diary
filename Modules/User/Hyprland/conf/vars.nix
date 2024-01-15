# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
{ lib, ... }: 
{
    input =  {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        accel_profile = "flat";

        follow_mouse = 1;

        touchpad = {
            natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
    };

    general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 20;
        border = 2;
        col = {
            active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            inactive_border = "rgba(595959aa)";
        };

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = true;
    };

    decoration = {
        rounding = 10;

        blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
        };

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        
        col = {
            shadow = "rgba(1a1a1aee)";
        };
    };

    animations = 
        let 
            curves = {
                myBezier = {
                    x0 = 0.05;
                    y0 = 0.9;
                    x1 = 0.1;
                    y1 = 1.1;
                };
            };

            animations = {
                windows = {
                    enabled = true;
                    speed = 7;
                    curve = "default";
                    style = "slide";
                };

                windows.out = {
                    enabled = true;
                    speed = 7;
                    curve = "default";
                    style = "popin 80%";
                };

                border = {
                    enabled = true;
                    speed = 10;
                    style = "slide";
                };

                borderangle = {
                    enabled = true;
                    speed = 8;
                    curve = "default";
                };

                fade = {
                    enabled = true;
                    speed = 7;
                    curve = "default";
                };

                workspaces = {
                    enabled = true;
                    speed = 6;
                    curve = "default";
                };
            };
        in with lib.attrsets; rec {
            formatAnimation = name: animation: 
                foldlAttrs
                    (acc: key: value: 
                        "${key},${if value.enabled then 1 else 0},${value.speed},${value.curve or "default"}${if value.style then ",${value.style}" else ""}"
                    ) name animation;

            bezier = foldlAttrs 
                        (acc: key: value: acc ++ [
                            "${key}, ${value.x0},${value.y0},${value.x1},${value.y1}"
                        ]) [] curves;

            animation = foldlAttrs
                        (acc: key: value: acc ++ [
                            formatAnimation key value
                        ] ++ lib.mkMerge [
                            lib.mkIf value."in" formatAnimation key . "In"
                            lib.mkIf value."out" formatAnimation key . "Out"
                        ]).contents.content [] animations;
        };
}
