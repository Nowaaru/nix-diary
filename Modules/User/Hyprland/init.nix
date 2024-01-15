{ pkgs, nix-colors, ... }:
{
	imports = [
		./sys.nix
	];

	wayland.windowManager.hyprland = {
        enable = true;
        settings = import ./conf { 
            inherit pkgs;
            nix-colors = nix-colors;
        };
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
