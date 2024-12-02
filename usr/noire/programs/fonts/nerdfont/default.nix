{ pkgs, ... }: {
  home.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
    fira-mono
    space-mono
  ];
}
