{inputs, ...}: {
  home.packages = [
    inputs.an-anime-game-launcher.packages.x86_64-linux.anime-game-launcher
  ];
}
