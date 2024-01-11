{ ... }: 
{
	imports = [
		# The specifics, baby!
		./Hyprland/init.nix
		./Fish/init.nix
		
		# Gaming and the like.
		./Gaming/launcher.nix
		./Gaming/mod.nix
		./Gaming/monitor.nix

		# Social media and social utilities.
		./Social/discord.nix
		
		# Programming utilities and goodies.
		./Programming/LazyVim/init.nix
		./Programming/Git/init.nix

		./Programming/node.nix
		./Programming/rust.nix
		./Programming/dotnet.nix
		./Programming/roblox.nix

		./Programming/formatters.nix

		# General things, auxiliary functionalities.
		./Miscellaneous/Terminal/init.nix 
		./Miscellaneous/Firefox/init.nix 

		./Miscellaneous/print-screen.nix
		./Miscellaneous/electron.nix
		./Miscellaneous/music.nix
		./Miscellaneous/hydrus.nix
		./Miscellaneous/audio.nix
		./Miscellaneous/delta.nix
		./Miscellaneous/font.nix
		./Miscellaneous/clip.nix
		./Miscellaneous/disk.nix
		./Miscellaneous/dir.nix
	];
}
