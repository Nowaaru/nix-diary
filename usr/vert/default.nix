{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  wsl-init = import ./Modules/WSL/init.nix {
    inherit inputs config pkgs lib;
  };
in {
  imports = [
    wsl-init
  ];

  nixpkgs = {
    config = {};
  };

  home = {
    shellAliases = {
      ls = "${pkgs.lsd}/bin/lsd";
    };
  };
}
