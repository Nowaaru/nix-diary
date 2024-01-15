{ pkgs, lib, nix-colors, ... }:
let
    config = import ./conf { 
        inherit pkgs;
        nix-colors = nix-colors;
    };
in
{
	imports = [
		./sys.nix
	];

	wayland.windowManager.hyprland = {
        enable = true;
        settings = config.hypr;
    };

    home.activation = {
        apply_theme = lib.hm.dag.entryAfter ["writeBoundary"] ''
            ${pkgs.swww}/bin/swww img ${config.theme.background}
        '';
    };

    /*
	home.file = {
		".config/hypr/hyprland.conf" = {
			enable = true;
			text = "source=~/.diary/Config/Hyprland/startup.conf";
		};
	};
    */

	home.packages = with pkgs; [
		xdg-desktop-portal-hyprland
		xwaylandvideobridge
		wlr-randr
	];
}
