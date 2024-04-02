{pkgs, ...}: {
  fish = {
    enable = true;
    # useBabelfish = true;
    shellInit = ''
      set -Ux DIARY ~/.diary
      source $DIARY/config/fish/init.fish
    '';
    interactiveShellInit = ''
      set -U fish_greeting
      ${pkgs.neofetch}/bin/neofetch
      fish_vi_key_bindings
    '';
  };
}
