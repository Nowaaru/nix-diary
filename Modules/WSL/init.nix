{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
    ./Git/init.nix
  ];

  programs.neovim-flake = {
    enable = true;
    settings = import (inputs.self + /Config/Neovim) {
      inherit pkgs lib inputs;
    }; # bruh?
  };

  home.packages = with pkgs; [
    lazygit
  ];

  programs.home-manager.enable = true;
}
