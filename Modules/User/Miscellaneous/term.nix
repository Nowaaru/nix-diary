{ pkgs, ... }:
{
	home.packages = with pkgs; [
		neovim
		neofetch
		notcurses
		kitty-themes
		ranger
		tldr
		page
		glow
	];
}
