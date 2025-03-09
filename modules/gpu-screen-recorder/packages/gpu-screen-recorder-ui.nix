{
  stdenv,
  fetchgit,
  lib,
  libglvnd,
  libpulseaudio,
  egl-wayland,
  meson,
  cmake,
  ninja,
  pkg-config,

  libX11,
  libXcomposite,
  libXrandr,
  libXcursor,
  libXfixes,
  libXi,

  ...
}:
with stdenv;
  mkDerivation (finalAttrs: {
    pname = "gpu-screen-recorder-ui";
    version = "1.1.7";

    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-ui";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
      rev = "8003c209fea16cd164817306cb33d46ac61a44f0";
      hash = "sha256-qDehZ4Csj79kyGOZwbI6LUu2OlC3032tZ7Vr662knpg=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake # needed (i think?)
      meson # paired with ninja
      ninja # paired with meson
    ];

    buildInputs = [
      libX11
      libXrandr
      libXcursor
      libXcomposite
      libXfixes
      libXi

      libpulseaudio
      egl-wayland
      libglvnd
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
