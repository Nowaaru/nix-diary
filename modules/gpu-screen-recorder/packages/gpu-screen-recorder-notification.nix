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
    version = "0.1.0";
    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-notify";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
      rev = "2edd13cb94340bf2ddb0cfc66fe216889b216fa1";
      hash = "sha256-PRC/aEmU6lmoCbai8ZgNQFlFZFcthDuswkDlT0qk8A4=";
    };

    nativeBuildInputs = with xorg; [
      libX11
      libXrandr
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
