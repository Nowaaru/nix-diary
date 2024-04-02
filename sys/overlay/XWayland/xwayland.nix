{ pkgs, lib, ... }:
let
  systemd = pkgs.systemd;
  libpciaccess = pkgs.xorg.libpciaccess;
  # xorgproto
  wayland-protocols-patched = pkgs.wayland-protocols.overrideAttrs (o: {
    patches = (o.patches or []) ++ [
      ./patches/dd5f95cf2951d46c3189a8a9612b4f6cbc51ed0e.patch
    ];
  });

  xorgproto-patched = pkgs.xorg.xorgproto.overrideAttrs (o: {
    patches = (o.patches or []) ++ [
      ./patches/e319f9cd044fd6a8e71ff9e03d99cd1fcabfb309.patch
    ];
  });
  xwayland-patched = pkgs.xwayland.overrideAttrs (o: {
    buildInputs = (o.buildInputs or []) ++ [
      systemd
      libpciaccess
    ];
    src = builtins.fetchGit {
      url = "https://gitlab.freedesktop.org/ekurzinger/xserver/";
      ref = "explicit-sync";
      rev = "636c9aa359eab45102c12a9fccb8f60587c7d485";
    };
    # patches = (o.patches or []) ++ [
    # ./patches/967.patch
    #];
  });
in 
{
  environment.systemPackages = with pkgs; [
    wayland-protocols-patched
    xorgproto-patched
  ];

  programs.xwayland = {
    enable = true;
    package = xwayland-patched;
  };
}
