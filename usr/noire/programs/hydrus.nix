{stable, ...}: {
  home.packages = with stable; [
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    hydrus
  ];
}
