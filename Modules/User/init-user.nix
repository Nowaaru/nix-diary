{ config, pkgs, lib, ...}: 
{
	imports = [
		# The specifics, baby!
		./Hyprland/init.nix
		./Fish/init.nix
		
		# Social media and social utilities.
		./Social/discord.nix
		
		# Programming utilities and goodies.
		./Programming/git.nix

		# General things, auxiliary functionalities.
		./Miscellaneous/print-screen.nix
		./Miscellaneous/electron.nix
		./Miscellaneous/wine.nix
		./Miscellaneous/clip.nix
		./Miscellaneous/disk.nix
		./Miscellaneous/dir.nix
	];
}
