{pkgs, ...}: {
  home.packages = with pkgs; [
    catnip
  ];
}
