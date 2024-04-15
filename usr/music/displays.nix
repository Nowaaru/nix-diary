{pkgs, ...}: {
  home.packages = with pkgs; [
    pulsemixer
    catnip
  ];
}
