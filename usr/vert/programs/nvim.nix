{
  inputs,
  self,
  pkgs,
  lib,
}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
  ];

  programs = {
    neovim-flake = {
      enable = true;
      settings = import (inputs.self + /Config/Neovim) {
        inherit pkgs lib inputs;
      }; # bruh?
    };
  };
}
