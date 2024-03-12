{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
    ./Git/init.nix
    ./Terminal/init.nix
  ];

  home.shellAliases = {
    ls = "${pkgs.lsd}/bin/lsd";
  };

  programs = {
    neovim-flake = {
      enable = true;
      settings = import (inputs.self + /Config/Neovim) {
        inherit pkgs lib inputs;
      }; # bruh?
    };

    fish = {
      enable = true;
      # useBabelfish = true;
      shellInit = ''
        set -Ux DIARY ~/.diary
        source $DIARY/Config/Fish/init.fish
      '';
      interactiveShellInit = ''
        set -U fish_greeting
        ${pkgs.neofetch}/bin/neofetch
        fish_vi_key_bindings
      '';
    };

    lazygit = {
      enable = true;
      settings = {
        # git.commit.signOff = true;
      };
    };

    home-manager.enable = true;
  };
}
