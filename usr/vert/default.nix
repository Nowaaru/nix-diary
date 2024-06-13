{
  pkgs,
  user,
  programs,
  ...
}: {
  imports = [
    user.programs.fish
    user.programs.nvim
    user.programs.git
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  nixpkgs = {
    config = {};
  };

  home = {
    shellAliases = {
      ls = "${pkgs.lsd}/bin/lsd";
    };
  };
}
