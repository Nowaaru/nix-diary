{pkgs, ...}: {
  imports = [
    ./anime-game.nix
    ./honkers.nix
    ./honkers-railway.nix
    ./wuthering-waves.nix
  ];
}
