{
  pkgs,
  inputs,
  home-manager,
  ...
}: let
  selfTrace = what:
    builtins.trace what what;
in {
  imports = [inputs.neovim-flake.homeManagerModules.default];
  programs.neovim-flake = {
    enable = true;
    settings = import (inputs.self + /Config/Neovim) {
      inherit pkgs inputs;
    }; # bruh?
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
