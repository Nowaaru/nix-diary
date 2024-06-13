{pkgs, ...}: {
  gtk.font.size = 8;
  qt = {
    enable = true;
    platformTheme = "kde";

    style.name = "lightly";
    style.package = pkgs.lightly-qt;
  };
}
