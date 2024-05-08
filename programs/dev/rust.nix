{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
  home.packages = [pkgs.rust-bin.stable.latest.default];
}
