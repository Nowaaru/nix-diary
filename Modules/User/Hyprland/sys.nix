# Utilities to make the system feel better.
# #
{ pkgs, ... }:
{
    imports = [
        ./fuzzel.nix
        ./eww.nix
    ];

	home.packages = with pkgs; [
		# hypr
		hyprpaper
		hyprdim
		swww

		# sway
		swayidle
		swaylock-effects

		# eyecandy
		dunst

		# utilities
		font-awesome
		wlogout
	];
}
