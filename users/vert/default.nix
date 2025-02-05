{
  pkgs,
  user,
  ...
}: {
  imports = [
    user.programs.git
    user.programs.fish
    user.programs.nvim
  ];

  home.shellAliases = {
    ls = "${pkgs.lsd}/bin/lsd";
  };

  programs.home-manager.enable = true;
}
