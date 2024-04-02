{pkgs, ...}: {
  gtk.font.size = 8;
  qt = {
    enable = true;
    platformTheme = "gtk";

    style.name = "adwaita";
    style.package = pkgs.adwaita-qt6;
  };
}
