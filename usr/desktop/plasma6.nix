args: let
  inherit (args) inputs;
in {
  home.packages = [inputs.plasma-manager.homeManagerModules.plasma-manager];

  programs.plasma = import (inputs.self + /cfg/plasma6);
}
