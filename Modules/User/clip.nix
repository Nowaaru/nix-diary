{ pkgs, ... }:
{
	home.packages = with pkgs; [
		cliphist
		wl-clip-persist
	];
}

