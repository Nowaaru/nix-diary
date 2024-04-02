{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: let
  wsl-init = import ./Modules/WSL/init.nix {
    inherit inputs config pkgs lib;
  };
in {
  imports = [
    wsl-init
  ];

  nixpkgs = {
    config = {};
  };
  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "vert";
    homeDirectory = "/home/vert";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = [
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
    };
    sessionVariables = {
      # EDITOR = "emacs";
      EDITOR = "nvim";
    };

    shellAliases = {
      ls = "${pkgs.lsd}/bin/lsd";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
