{ pkgs, ... }:
{
    home.packages = with pkgs; [
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      hydrus
    ];
}
