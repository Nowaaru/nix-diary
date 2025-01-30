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
    version = "1.0.8";

    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-ui";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
      rev = "92401d8bc8fa3cbc8017936eb1d18280199942e0";
      hash = "sha256-dOsJvdW+cZ7U03XUEYgAA6GniQ85jl/HO9vRqzPLKEs=";
    };

    nativeBuildInputs = with xorg; [
      libX11
      libXrandr
      libXcursor
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
      ls -R;
      ninja -C $build install
    '';

    meta = {
      description = "dec05eba";
      homepage = "https://dec05eba.com";
      license = lib.licenses.gpl3;

      maintainers = with lib.maintainers; [""];
    };
  })
