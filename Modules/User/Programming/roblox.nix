{ pkgs, ... }:
{
	home.packages = with pkgs; [
		grapejuice
	];
}
