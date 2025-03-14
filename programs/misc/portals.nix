{pkgs, ...}: let
  portalList = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
    # libsForQt5.xdg-desktop-portal-kde

    # xdg-desktop-portal-hyprland
  ];
in {
  /*
    warning: xdg-desktop-portal 1.17 reworked how portal implementations are loaded, you
  should either set `xdg.portal.config` or `xdg.portal.configPackages`
  to specify which portal backend to use for the requested interface.

  https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in

  If you simply want to keep the behaviour in < 1.17, which uses the first
  portal implementation found in lexicographical order, use the following:

  xdg.portal.config.common.default = "*";
  */
  
  /*
  xdg.portal.config.configPackages = sessionConfigurations;

  xdg.portal = {
    enable = true;
    extraPortals = portalList;
    xdgOpenUsePortal = true;
  };
  */

  home.packages = portalList;
}
