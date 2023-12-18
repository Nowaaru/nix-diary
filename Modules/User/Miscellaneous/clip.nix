{ pkgs, ... }:
{
	home.packages = with pkgs; [
		copyq
		wl-clipboard
		wl-clip-persist
	];
}

