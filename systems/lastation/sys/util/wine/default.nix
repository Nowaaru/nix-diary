{pkgs, stable, ...}: {
  environment.systemPackages = with pkgs; [
    winetricks
    freetype
    wineWow64Packages.staging
  ];
}
