{
  inputs,
  configure,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  # home.packages = [
  #   pkgs.nodePackages.neovim
  # ];

  nixpkgs.overlays = [
  ];

  programs.nvf = {
    enable = true;
    settings.vim = configure "nvf";
  };
}
