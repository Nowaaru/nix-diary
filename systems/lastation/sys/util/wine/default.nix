{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mono

    winetricks
    wineWowPackages.full
  ];
}
