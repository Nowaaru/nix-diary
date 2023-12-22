{ pkgs, unstable, ... }:
{
	home.packages = with unstable; [
		vinegar
	];
}
