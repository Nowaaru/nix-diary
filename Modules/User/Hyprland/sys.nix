# Utilities to make the system feel better.
{ pkgs, ... }:
{
	home.packages = with pkgs; [
		wlogout

		hyprpaper
		hyprdim

		swayidle
		swaylock-effects
		swww
	];
}
