# Utilities to make the system feel better.
{ pkgs, ... }:
{
	home.packages = with pkgs; [
		# hypr
		hyprpaper
		hyprdim
		swww

		# sway
		swayidle
		swaylock-effects

		# eyecandy
		fuzzel
		waybar
		dunst

		# utilities
		font-awesome
		wlogout
	];

    imports = [
        ./fuzzel.nix
    ];
}
