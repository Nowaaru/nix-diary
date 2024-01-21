{ pkgs, lib, nix-colors, inputs, ... }:
let
    hypr-config = import ./conf { 
        inherit pkgs;
        nix-colors = nix-colors;
    };

    util = import ./conf/util.nix {
            inherit lib pkgs;
    };

    applySwayTheme = ''
    if [ -n "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ]; then
        $DRY_RUN_CMD ${selfTrace (util.str.applySwayTheme hypr-config.theme)}
    fi
    '';

    selfTrace = t:
        builtins.trace t t;
in
{
	imports = [
		./sys.nix
	];

	wayland.windowManager.hyprland = {
        enable = true;
        settings = hypr-config.hypr;
    };

	home.packages = with pkgs; [
		xdg-desktop-portal-hyprland
		xwaylandvideobridge
		wlr-randr

        ps
	];

    home.activation = {
        hyprland_apply_sww_theme = 
            lib.hm.dag.entryAfter ["writeBoundary"] applySwayTheme;
    };

    home.file =  {
        ".config/eww" = {
            enable = selfTrace (lib.attrsets.hasAttrByPath ["theme" "widgets"] hypr-config);
            source = hypr-config.theme.widgets;
        };
    };
}
