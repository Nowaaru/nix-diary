{ pkgs, ... }: {
  home.packages = with pkgs; [
      ncpamixer
  ];
}
