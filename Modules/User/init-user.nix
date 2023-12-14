{ config, pkgs, lib, ...}: 
{
	imports = [
		./Hyprland/init.nix
		./Fish/init.nix

		./print-screen.nix
		./electron.nix
		./discord.nix
		./clip.nix
		./git.nix
	];
}
