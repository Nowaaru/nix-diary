{ pkgs, ... }:
{
	home.packages = with pkgs; [
		udiskie
	];
}