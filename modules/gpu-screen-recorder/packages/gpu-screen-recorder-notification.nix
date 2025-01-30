{
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
    pname = "gpu-screen-recorder-notification";
    version = "1.0.1";
    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-notify";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
      rev = "4eaeba2a39874c76bfc71d69b97f7619f471747a";
      hash = "sha256-i5rHyG66ZduibiL/zhriR/tS+yd5IVn2+heD3NiOluo=";
    };

    nativeBuildInputs = with xorg; [
      libX11
      libXrandr
      libXcursor
      libXcomposite
      libXfixes
      libXi
    ];

    buildInputs = [
      pkg-config
      cmake
      meson
      ninja
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

    meta = with lib; {
      description = "A program that produces a familiar, friendly greeting";
      longDescription = ''
        GNU Hello is a program that prints "Hello, world!" when you run it.
        It is fully customizable.
      '';
      homepage = "https://www.gnu.org/software/hello/manual/";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [eelco];
      platforms = platforms.all;
    };
  })
