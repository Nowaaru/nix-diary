{ pkgs, lib, ... }:
{
	imports = [
		./sys.nix
		./waybar.nix
	];

	wayland.windowManager.hyprland = {
        enable = false;
        settings = import ./conf { 
            inherit lib; 
        };
    };

	home.file = {
		".config/hypr/hyprland.conf" = {
			enable = true;
			text = "source=~/.diary/Config/Hyprland/startup.conf";
		};
	};

	home.packages = with pkgs; [
		xdg-desktop-portal-hyprland
		xwaylandvideobridge
		wlr-randr
	];
}
