{
  pkgs,
  lib,
  ...
}: {
  # system configuration file

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-unstable-2021-11-01"
  ];

  environment.systemPackages = with pkgs; [
    deepin.deepin-screen-recorder
    warp-terminal
    yabar
  ];

  environment.sessionVariables.TERMINAL = lib.mkForce "warp-terminal";
  services.xserver.desktopManager.deepin.enable = lib.mkForce true;
}
