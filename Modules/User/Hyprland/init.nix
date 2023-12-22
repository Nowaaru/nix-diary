{ pkgs, ... }:
{
	imports = [
		./sys.nix
	];

	programs.hyprland = { 
		enable = true;
		enableNvidiaPatches = true;
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
