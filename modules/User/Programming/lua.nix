{pkgs, ...}: let
  luaPackages = with pkgs.luajitPackages; [
    image-nvim
    luarocks
    magick
  ];
in {
  home.packages = with pkgs; [
    luajit
    luau
  ] ++ luaPackages;
}
