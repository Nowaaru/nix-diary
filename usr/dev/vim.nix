{
  pkgs,
  inputs,
  lib,
  # home-manager,
  ...
}: let
  selfTrace = what:
    builtins.trace what what;
in {
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
