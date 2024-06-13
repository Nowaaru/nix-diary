{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "osu-lazer-bin"
    ];
  home.packages = with pkgs; [
    osu-lazer-bin
  ];
}
