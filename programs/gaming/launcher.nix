{pkgs, ...}: {
  home.packages = with pkgs; [
    steam-run
    prismlauncher
    gamemode
  ];
}
