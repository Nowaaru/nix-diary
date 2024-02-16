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
 home.packages = with pkgs; [
  lua
 ];

  programs.neovim-flake = {
    enable = true;
    settings = import (inputs.self + /Config/Neovim) {
      inherit pkgs lib inputs;
    }; # bruh?
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
