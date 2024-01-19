{ pkgs, ... }:
{
	home.packages = with pkgs; [
        prismlauncher
		gamemode
		steam
	];
}
