{pkgs, ...}: {
  home.packages = with pkgs; [
    libsForQt5.kdenlive
    glaxnimate
    ffmpeg

    wlsunset
  ];
}
