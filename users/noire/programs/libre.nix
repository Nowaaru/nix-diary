{pkgs, ...}:
{
  home.packages = with pkgs; [
    librewolf
    libreoffice
  ];
}
