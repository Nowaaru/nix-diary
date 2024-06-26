{ pkgs, ... }: {
  home.shellAliases = {
    ls = "${pkgs.lsd}/bin/lsd";
  };

  programs.fish = {
    enable = true;
    # useBabelfish = true;
    shellInit = ''
      set -Ux DIARY ~/.diary
      source $DIARY/cfg/fish/init.fish
    '';
    interactiveShellInit = ''
      set -U fish_greeting
      ncneofetch
      fish_vi_key_bindings
    '';
  };
}
