{ config, pkgs, lib, ...}: 
{
	imports = [
		./Hyprland/init.nix
		./Fish/init.nix
		./electron.nix
		./discord.nix
		./clip.nix
	];
}
