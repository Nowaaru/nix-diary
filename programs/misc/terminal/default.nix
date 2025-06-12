{ pkgs, ... }:
{
  imports = [
      ./starship.nix
      ./fish.nix
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

        lsd
    ];

}
