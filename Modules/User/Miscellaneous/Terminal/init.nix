{ pkgs, ... }:
{
    imports = [
        ./kitty.nix
    ];

	home.packages = with pkgs; [
		neofetch
		notcurses
		ranger
		tldr
		page
		glow
	];
        asciinema-agg
        asciinema

    programs.starship = {
        settings = import ./starship.nix { inherit pkgs; };
        enable = true;
        enableTransience = true;
        enableFishIntegration = true;
    };
}
