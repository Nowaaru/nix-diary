{pkgs, ...}: {
  home.packages = with pkgs; [
    glaxnimate
    ffmpeg
  ];
}
