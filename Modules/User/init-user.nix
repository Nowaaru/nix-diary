{ config, pkgs, lib, ...}: 
{
	imports = [
		./Hyprland/init.nix
		./Fish/init.nix
		./discord.nix
		./clip.nix
	];
}
