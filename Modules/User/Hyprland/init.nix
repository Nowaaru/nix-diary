{ pkgs, ... }:
{
	imports = [
		./sys.nix
	];

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
