{
  pkgs,
  inputs,
  lib,
  ...
}: let
  selfTrace = what:
    builtins.trace what what;
in {
  imports = [
    inputs.neovim-flake.homeManagerModules.default
  ];

  programs.neovim-flake = {
    enable = true;
    settings = import (inputs.self + /cfg/neovim) {
      inherit pkgs lib inputs;
    }; # bruh?
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
