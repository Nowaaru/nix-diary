{ pkgs, ... }:
{
    home.packages = with pkgs; [
        spotify-player
        pulsemixer
        catnip
    ];
}
