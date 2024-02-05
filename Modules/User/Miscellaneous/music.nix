{pkgs, ...}: {
  home.packages = with pkgs; [
    pulsemixer
    ncspot
    catnip
  ];
}
