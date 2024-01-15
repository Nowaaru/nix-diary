# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
{ lib, theme, ... }: 
let
    util = import ./util.nix {
            inherit lib;
    };
in
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

    /* 
     * default colors:
     * active_border - 33ccffee 00ff99ee 0deg
     * inactive_border - 595959aa
     * shadow - 1a1a1aee
     */
    general = with util.color; with theme; {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = gradient colors.base09 colors.base0B 0; # "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = convertRgb ("1a1a1a");

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = true;
    };

    decoration = with theme; with util.color; {
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
        
        "col.shadow" = convertRgb colors.base08;
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

            utilityFunctions = with lib.attrsets; {
                # builtins.trace, but to print
                # itself!
                trace = what:
                    builtins.trace what what;

                toStrDeep = value: 
                    mapAttrs (_: maybe_num: 
                        if (builtins.isInt maybe_num) then
                            builtins.toString maybe_num
                        else
                            if (builtins.isFloat maybe_num) then
                                builtins.toString maybe_num
                            else maybe_num
                    ) value;

                formatAnimation = name: animation: 
                    "${name},${if animation.enabled then "1" else "0"},${animation.speed},${if hasAttrByPath ["curve"] animation then animation.curve else "default"}${if hasAttrByPath ["style"] animation then ",${animation.style}" else ""}";
            };
        in with lib.attrsets; {
            bezier = foldlAttrs 
                        (acc: key: value: acc ++ [
                            "${key}, ${value.x0},${value.y0},${value.x1},${value.y1}"
                        ]) [] (
                            mapAttrs (_: value: 
                                utilityFunctions.toStrDeep value
                            ) curves
                        );

            animation = builtins.filter (x: x != null) (foldlAttrs
                            (
                                acc: key: value: 
                                    acc ++ [
                                        (utilityFunctions.formatAnimation key (utilityFunctions.toStrDeep value))
                                    ] ++ [
                                        (if (hasAttrByPath ["in"] value) then (utilityFunctions.formatAnimation "${key}In" (utilityFunctions.toStrDeep value."in")) else null)
                                        (if (hasAttrByPath ["out"] value) then (utilityFunctions.formatAnimation "${key}Out" (utilityFunctions.toStrDeep value.out)) else null)
                                    ]
                            ) [] animations);
        };
}
