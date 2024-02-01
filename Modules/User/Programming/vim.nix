{
  inputs,
  pkgs,
  ...
}: let
  selfTrace = a:
    builtins.trace a a;
in {
  home.packages = [
    pkgs.neovim
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
