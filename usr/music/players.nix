
{pkgs, ...}: {
  home.packages = with pkgs; [
    ncmpcpp
  ];
}
