{
  inputs,
  lib,
  pkgs,
  nur,
  ...
}: {
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
