{ pkgs, ... }:
{
    imports = [
        ./kitty.nix
    ];

	home.packages = with pkgs; [
        asciinema-agg
        asciinema

        notcurses
        neofetch
        ranger
        tldr
        page
        glow

    ];

    programs.starship = {
        settings = import ./starship.nix { inherit pkgs; };
        enable = true;
        enableTransience = true;
        enableFishIntegration = true;
    };
}
