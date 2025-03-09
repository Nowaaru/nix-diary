{
  stdenv,
  fetchgit,
  lib,
  libGL,
  libdrm,
  libpulseaudio,
  libcap,
  libva,
  vulkan-headers,
  libX11,
  libXcomposite,
  libXrandr,
  libXfixes,
  libXdamage,
  ffmpeg-full,
  egl-wayland,
  wayland,
  dbus,
  pipewire,
  meson,
  cmake,
  ninja,
  pkg-config,

  addDriverRunpath,
  wrapperDir ? "/run/wrappers/bin",
  makeWrapper,
  ...
}:
with stdenv;
  mkDerivation (finalAttrs: {
    pname = "gpu-screen-recorder";
    version = "5.1.1";
    outputs = ["build" "out"];
    phases = ["setupPhase" "configurePhase" "buildPhase" "fixupPhase"];

    src = fetchgit {
      name = "gsr";
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
      rev = "015570ca75e4c7891f02708b1ec29da8887578ef";
      hash = "sha256-MZMl5OMPfZP8h/Pj6M22lMt94wXXKfAJbP5TZIb2kZ0=";
    };

    nativeBuildInputs = [
      pkg-config
      cmake
      meson
      ninja
    ];

    buildInputs = [
      libX11
      libXcomposite
      libXrandr
      libXfixes
      libXdamage

      ffmpeg-full
      vulkan-headers

      libpulseaudio
      libcap

      egl-wayland
      wayland

      libGL # libglvnd
      libdrm
      libva

      dbus
      pipewire
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

    sourceRoot = ".";

    postInstall = ''
      mkdir $out/bin/.wrapped
      mv $out/bin/gpu-screen-recorder $out/bin/.wrapped/
      makeWrapper "$out/bin/.wrapped/gpu-screen-recorder" "$out/bin/gpu-screen-recorder" \
        --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          addDriverRunpath.driverLink
        ]
      }" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "$out/bin"
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
