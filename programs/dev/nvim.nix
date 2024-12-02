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
    (final: prev: {
      nodePackages = prev.nodePackages // {
        neovim = final.neovim-node-client;
      };
    })
  ];

  programs.nvf = {
    enable = true;
    settings.vim = configure "nvf";
  };
}
