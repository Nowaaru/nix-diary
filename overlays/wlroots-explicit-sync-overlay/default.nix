{
  pkgs,
  lib,
}: (_: prev: let
  inherit (prev) lib;
  inherit (lib) attrsets;

  mkPatchesFromDir = with attrsets;
    dir:
      (foldlAttrs (acc: k: v: acc ++ [(dir + "/${k}")])) [] (builtins.readDir dir);
in {
  wayland-protocols = prev.wayland-protocols.overrideAttrs (old: {
    patches = (old.patches or []) ++ mkPatchesFromDir ./patches/wayland-protocols;
  });
  wlroots = prev.wlroots.overrideAttrs (old: {
    patches = (old.patches or []) ++ mkPatchesFromDir ./patches/wlroots;
  });
  egl-wayland = prev.egl-wayland.overrideAttrs (old: {
    patches = (old.patches or []) ++ mkPatchesFromDir ./patches/egl-wayland;
  });
})
