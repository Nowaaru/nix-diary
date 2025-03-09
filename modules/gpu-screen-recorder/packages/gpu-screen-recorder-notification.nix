{
  stdenv,
  fetchgit,
  lib,
  libGL,
  meson,
  cmake,
  ninja,
  pkg-config,

  libX11,
  libXrandr,
  libXcursor,
  libXrender,
  libXcomposite,
  libXfixes,
  libXext,
  libXi,

  ...
}:
with stdenv;
  mkDerivation (finalAttrs: {
    pname = "gpu-screen-recorder-notification";
    version = "1.0.3";
    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr-notify";
      url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
      rev = "d0aee0cb0f8e471aedc40554ccd92ba60cf8aab6";
      hash = "sha256-OXUQMnBu0m1jew9ZQXfc42k6sR9+OJiDwJGAOqTKxII=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake
      meson
      ninja
    ];

    buildInputs = [
      libX11
      libXrandr
      libXcursor
      libXrender
      libXcomposite
      libXfixes
      libXext
      libXi

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
