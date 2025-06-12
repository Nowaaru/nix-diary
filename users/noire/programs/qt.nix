{stable, ...}: {
  gtk.font.size = 8;
  qt = {
    enable = true;
    platformTheme.name = "kde";

    style.name = "lightly";
    style.package = stable.lightly-qt;
  };
}
