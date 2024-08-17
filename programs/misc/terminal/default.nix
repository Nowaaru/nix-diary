{ pkgs, ... }:
{
  imports = [
      ./starship.nix
      ./kitty.nix
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
