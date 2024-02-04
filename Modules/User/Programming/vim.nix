{pkgs, ...}: {
  home.packages = [
    pkgs.neovim
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
