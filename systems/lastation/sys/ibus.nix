{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    maliit-keyboard
    maliit-framework
  ];
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [
  #     /*
  #     any engine you want, for example
  #     */
  #     ibus-engines.mozc
  #   ];
  # };
}
