{
  gpu-screen-recorder,
  callPackage,
  stdenv,
  fetchgit,
  lib,
  xorg,
  libGL,
  meson,
  cmake,
  ninja,
  pkg-config,
  ...
}:
with stdenv;
  mkDerivation (finalAttrs: {
    pname = "gpu-screen-recorder-ui";
    version = "0.1.0";

    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-ui";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
      rev = "ec6d4090af22db59991e9c621238c96795814379";
      hash = "sha256-ObVlSNVJM8qclr/0+XwFWs8kx1lT6Dl44xCfjIxhCuw=";
    };

    nativeBuildInputs = with xorg; [
      libX11
      libXrandr
      libXcomposite
      libXfixes
      libXi

      gpu-screen-recorder
      libGL # libglvnd
    ];

    buildInputs = [
      (callPackage ./gpu-screen-recorder-notification.nix {})
      pkg-config
      cmake # needed (i think?)
      meson # paired with ninja
      ninja # paired with meson
      libGL # libglvnd
    ];

    configurePhase = ''
      meson configure --prefix=$out --buildtype=release -Dstrip=true $build
    '';

    setupPhase = ''
      cd $src
      meson setup $build $src
    '';

    buildPhase = ''
      ninja -C $build install
    '';

    meta = {
      description = "dec05eba";
      homepage = "https://dec05eba.com";
      license = lib.licenses.gpl3;

      maintainers = with lib.maintainers; [""];
    };
  })
