{ pkgs, ... }: {
  home.packages = with pkgs; [
    jellyfin-web
  ];
}
