{ pkgs, ... }:
{
	imports = [
		./Shell/init.nix
		./Git/init.nix
		./electron.nix
	];
}

