{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = "gtk";

    style.name = "adwaita";
    style.package = pkgs.adwaita-qt;
  };
}
