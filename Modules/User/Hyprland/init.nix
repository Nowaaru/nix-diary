{ pkgs, ... }:
{
	imports = [
		./sys.nix
	];

	# wayland.windowManager.hyprland.enable = true;

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
