{pkgs, ...}: {
  home.packages = with pkgs; [
    libsForQt5.kdenlive
    obsidian
    ffmpeg
    mpv
  ];
}
