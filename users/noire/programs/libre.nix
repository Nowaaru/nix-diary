{pkgs, stable, ...}:
{
  home.packages = with stable; [
    libreoffice
    librewolf
  ];
}
