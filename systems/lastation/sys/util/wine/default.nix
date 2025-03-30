{pkgs, stable, ...}: {
  environment.systemPackages = with pkgs; [
    mono

    winetricks
    wineWowPackages.full
  ];
}
